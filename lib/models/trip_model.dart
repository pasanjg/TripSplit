import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tripsplit/entities/user.dart';
import 'package:tripsplit/services/firebase_service.dart';

import '../entities/expense.dart';
import '../entities/trip.dart';

class TripModel with ChangeNotifier {
  Trip? selectedTrip;
  String? successMessage;
  String? errorMessage;

  final FirebaseService _firebaseService = FirebaseService.instance;

  bool get canAddUser =>
      selectedTrip != null &&
      selectedTrip!.createdBy == _firebaseService.auth.currentUser!.uid;

  bool get canAddExpense => selectedTrip != null;

  int get userCount => selectedTrip?.userRefs.length ?? 0;

  double get totalSpent {
    if (selectedTrip == null) return 0.0;
    return selectedTrip!.expenses.fold(0.0, (prev, expense) => prev + expense.amount!);
  }

  Stream<List<Trip>> get userTripsStream {
    Stream<List<Trip>> stream;
    try {
      stream = FirebaseFirestore.instance
          .collection(User.collection)
          .doc(_firebaseService.auth.currentUser!.uid)
          .snapshots()
          .asyncMap((snapshot) async {
        final data = snapshot.data() as Map<String, dynamic>;
        final tripRefs = (data[User.fieldTripRefs] as List<dynamic>)
            .map((ref) => ref as DocumentReference)
            .toList();

        final trips = await Future.wait(tripRefs.map((tripRef) async {
          final tripSnapshot = await tripRef.get();
          return Trip.fromMap(
            tripSnapshot.id,
            tripSnapshot.data() as Map<String, dynamic>,
          );
        }));
        trips.sort((a, b) => a.startDate!.compareTo(b.startDate!));
        return trips;
      });
    } catch (err) {
      debugPrint(err.toString());
      stream = const Stream.empty();
    }

    return stream;
  }

  Stream<List<User>> get usersStream {
    Stream<List<User>> stream;
    try {
      stream = FirebaseFirestore.instance
          .collection(Trip.collection)
          .doc(selectedTrip!.id)
          .snapshots()
          .asyncMap((snapshot) async {
        final data = snapshot.data() as Map<String, dynamic>;
        final userRefs = (data[Trip.fieldUserRefs] as List<dynamic>)
            .map((ref) => ref as DocumentReference)
            .toList();

        final users = await Future.wait(userRefs.map((userRef) async {
          final userSnapshot = await userRef.get();
          return User.fromMap(
            userSnapshot.id,
            userSnapshot.data() as Map<String, dynamic>,
          );
        }));
        return users;
      });
    } catch (err) {
      debugPrint(err.toString());
      stream = const Stream.empty();
    }

    return stream;
  }

  Stream<Map<String, List<Expense>>> get tripExpensesStream {
    Stream<Map<String, List<Expense>>> stream;
    try {
      stream = FirebaseFirestore.instance
          .collection(Trip.collection)
          .doc(selectedTrip!.id)
          .collection(Expense.collection)
          .orderBy(Expense.fieldDate, descending: true)
          .snapshots()
          .asyncMap((snapshot) async {
        final expenses = snapshot.docs.map((doc) {
          return Expense.fromMap(doc.id, doc.data());
        }).toList();

        // Group expenses by date
        final groupedExpenses = <String, List<Expense>>{};
        for (var expense in expenses) {
          final dateKey = DateFormat.yMMMMd().format(expense.date!);
          if (groupedExpenses.containsKey(dateKey)) {
            groupedExpenses[dateKey]!.add(expense);
          } else {
            groupedExpenses[dateKey] = [expense];
          }
        }

        return groupedExpenses;
      });
    } catch (err) {
      debugPrint(err.toString());
      stream = const Stream.empty();
    }

    return stream;
  }

  double getUserExpenses(String userId) {
    if (selectedTrip == null) return 0.0;
    return selectedTrip!.expenses
        .where((expense) => expense.userRef!.id == userId)
        .fold(0.0, (prev, expense) => prev + expense.amount!);
  }

  Future<void> createTrip({
    required String title,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    clearMessages();
    try {
      final trip = Trip(
        title: title,
        startDate: startDate,
        endDate: endDate,
      );

      trip.createdBy = _firebaseService.auth.currentUser!.uid;

      DocumentReference tripRef = await _firebaseService.firestore
          .collection(Trip.collection)
          .add(trip.toMap());

      await tripRef.update({Trip.fieldInviteCode: tripRef.id.substring(0, 6)});

      String userId = _firebaseService.auth.currentUser!.uid;
      await addUserToTripWithReference(tripRef.id, userId);
      await getUserTrips();

      successMessage = 'Trip created successfully';
    } catch (err) {
      errorMessage = 'Error creating trip';
      debugPrint("Error creating trip: $err");
    }
  }

  Future<void> getUserTrips({Trip? selected}) async {
    try {
      final user = await _firebaseService.firestore
          .collection(User.collection)
          .doc(_firebaseService.auth.currentUser!.uid)
          .get();

      final trips = await Future.wait(
        user.get(User.fieldTripRefs).map<Future<Trip>>((tripRef) async {
          DocumentSnapshot tripSnapshot = await tripRef.get();
          return Trip.fromMap(
            tripSnapshot.id,
            tripSnapshot.data() as Map<String, dynamic>,
          );
        }),
      );

      trips.sort((a, b) => a.startDate!.compareTo(b.startDate!));

      if (selected != null) {
        await selectTrip(selected);
      } else {
        await selectTrip(trips.first);
      }
    } catch (err) {
      debugPrint(err.toString());
    } finally {
      notifyListeners();
    }
  }

  Future<void> selectTrip(Trip t) async {
    if (selectedTrip != t) {
      selectedTrip = t;
      await selectedTrip!.loadExpenses();
      await selectedTrip!.loadUsers();
    } else {
      selectedTrip = null;
    }

    notifyListeners();
  }

  Future<void> joinTrip(String inviteCode) async {
    clearMessages();
    final tripQuerySnapshot = await _firebaseService.firestore
        .collection(Trip.collection)
        .where(Trip.fieldInviteCode, isEqualTo: inviteCode)
        .get();

    if (tripQuerySnapshot.docs.isNotEmpty) {
      final tripSnapshot = await tripQuerySnapshot.docs.first.reference.get();
      final trip = Trip.fromMap(
        tripSnapshot.id,
        tripSnapshot.data() as Map<String, dynamic>,
      );

      final userRef = _firebaseService.firestore
          .collection(User.collection)
          .doc(_firebaseService.auth.currentUser!.uid);

      if (trip.userRefs.contains(userRef)) {
        errorMessage = 'You are already part of this trip';
        notifyListeners();
        return;
      }

      await addUserToTripWithReference(
        trip.id!,
        _firebaseService.auth.currentUser!.uid,
      );
      await getUserTrips();
      await selectTrip(trip);
      successMessage = 'Trip joined successfully';
    } else {
      errorMessage = 'Trip not found';
    }

    notifyListeners();
  }

  Future<void> assignGuestUser({
    required String firstname,
    required String lastname,
  }) async {
    clearMessages();
    try {
      final user = User(
        firstname: firstname,
        lastname: lastname,
      );

      DocumentReference userRef = await _firebaseService.firestore
          .collection(User.collection)
          .add(user.toMap());

      await addUserToTripWithReference(selectedTrip!.id!, userRef.id);
      selectedTrip!.userRefs.add(userRef);
      await selectedTrip!.loadUsers();

      successMessage = "${user.fullName} added successfully";
    } catch (err) {
      errorMessage = 'Error adding user';
      debugPrint(err.toString());
    } finally {
      notifyListeners();
    }
  }

  Future<void> addUserToTripWithReference(String tripId, String userId) async {
    DocumentReference userRef =
        _firebaseService.firestore.collection(User.collection).doc(userId);
    DocumentReference tripRef =
        _firebaseService.firestore.collection(Trip.collection).doc(tripId);

    await _firebaseService.firestore.runTransaction((transaction) async {
      // Add the trip reference to the user
      transaction.update(userRef, {
        User.fieldTripRefs: FieldValue.arrayUnion([tripRef])
      });

      // Add the user reference to the trip
      transaction.update(tripRef, {
        Trip.fieldUserRefs: FieldValue.arrayUnion([userRef])
      });
    });
  }

  Future<void> addExpense({
    required String title,
    required String category,
    required DateTime date,
    required double amount,
    required String userId,
    ImageProvider? receiptImage,
  }) async {
    clearMessages();
    try {
      final userRef =
          _firebaseService.firestore.collection(User.collection).doc(userId);

      final expense = Expense(
        title: title,
        category: category,
        date: date,
        amount: amount,
        userRef: userRef,
      );

      // if (receiptImage != null) {
      //   final url = await _firebaseService.uploadImage(receiptImage);
      //   expense.receiptUrl = url;
      // }

      await _firebaseService.firestore
          .collection(Trip.collection)
          .doc(selectedTrip!.id)
          .collection(Expense.collection)
          .add(expense.toMap());

      await selectedTrip!.loadExpenses();
      successMessage = 'Expense added successfully';
    } catch (err) {
      errorMessage = 'Error adding expense';
      debugPrint(err.toString());
    } finally {
      notifyListeners();
    }
  }

  void clearSelectedTrip() {
    selectedTrip = null;
    notifyListeners();
  }

  void clearMessages() {
    successMessage = null;
    errorMessage = null;
    // notifyListeners();
  }
}
