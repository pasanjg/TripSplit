import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
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
    return selectedTrip!.expenses
        .fold(0.0, (prev, expense) => prev + expense.amount!);
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

  double getUserExpensesTotal(String userId) {
    if (selectedTrip == null) return 0.0;
    return selectedTrip!.expenses
        .where((expense) => expense.userRef!.id == userId)
        .fold(0.0, (prev, expense) => prev + expense.amount!);
  }

  Map<String, List<Expense>> getUserExpenses(String userId) {
    if (selectedTrip == null) return {};
    return selectedTrip!.expenses
        .where((expense) => expense.userRef!.id == userId)
        .fold(<String, List<Expense>>{}, (prev, expense) {
      final dateKey = DateFormat.yMMMMd().format(expense.date!);
      if (prev.containsKey(dateKey)) {
        prev[dateKey]!.add(expense);
      } else {
        prev[dateKey] = [expense];
      }

      return prev;
    });
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

  Future<void> getTrip(String tripId) async {
    try {
      final tripSnapshot = await _firebaseService.firestore
          .collection(Trip.collection)
          .doc(tripId)
          .get();

      selectedTrip = Trip.fromMap(
        tripSnapshot.id,
        tripSnapshot.data() as Map<String, dynamic>,
      );
      await selectedTrip!.loadExpenses();
      await selectedTrip!.loadUsers();
    } catch (err) {
      debugPrint(err.toString());
    } finally {
      notifyListeners();
    }
  }

  Future<void> selectTrip(Trip trip) async {
    try {
      selectedTrip = trip;
      await selectedTrip!.loadExpenses();
      await selectedTrip!.loadUsers();
    } catch (err) {
      debugPrint(err.toString());
    } finally {
      notifyListeners();
    }
  }

  Future<void> joinTrip(String inviteCode) async {
    clearMessages();
    try {
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
          errorMessage = 'You are already a member of this trip';
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
        errorMessage = 'The invite code is invalid or expired. Please try again with a valid code';
      }
    } catch (err) {
      errorMessage = 'Error joining trip';
      debugPrint(err.toString());
    } finally {
      notifyListeners();
    }
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
        createdBy: _firebaseService.auth.currentUser!.uid,
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

  Future<void> assignMultipleGuests(List<String> guestIds) async {
    clearMessages();
    try {
      final tripRef = _firebaseService.firestore
          .collection(Trip.collection)
          .doc(selectedTrip!.id);

      final userRefs = guestIds
          .map((userId) => _firebaseService.firestore
              .collection(User.collection)
              .doc(userId))
          .toList();

      await _firebaseService.firestore.runTransaction((transaction) async {
        for (var userRef in userRefs) {
          // Add the trip reference to the user
          transaction.update(userRef, {
            User.fieldTripRefs: FieldValue.arrayUnion([tripRef])
          });

          // Add the user reference to the trip
          transaction.update(tripRef, {
            Trip.fieldUserRefs: FieldValue.arrayUnion([userRef])
          });
        }
      });

      selectedTrip!.userRefs.addAll(userRefs);
      await selectedTrip!.loadUsers();

      successMessage = '${guestIds.length} user(s) added successfully';
    } catch (err) {
      errorMessage = 'Error adding users';
      debugPrint(err.toString());
    } finally {
      notifyListeners();
    }
  }

  Future<List<User>> getUserGuests() async {
    try {
      final tripRef = _firebaseService.firestore
          .collection(Trip.collection)
          .doc(selectedTrip!.id);

      return await _firebaseService.getUserGuestsFromFirestore(tripRef);
    } catch (err) {
      debugPrint(err.toString());
    }

    return [];
  }

  Future<void> addUserToTripWithReference(String tripId, String userId) async {
    try {
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
    } catch (err) {
      debugPrint(err.toString());
    }
  }

  Future<void> addOrUpdateExpense({
    String? id,
    required String title,
    required String category,
    required DateTime date,
    required double amount,
    required String userId,
    String? receiptUrl,
  }) async {
    clearMessages();
    try {
      final userRef = _firebaseService.firestore.collection(User.collection).doc(userId);

      final expense = Expense(
        title: title,
        category: category,
        date: date,
        amount: amount,
        userRef: userRef,
        receiptUrl: receiptUrl,
      );

      if (id != null) {
        await _firebaseService.firestore
            .collection(Trip.collection)
            .doc(selectedTrip!.id)
            .collection(Expense.collection)
            .doc(id)
            .update(expense.toMap());
      } else {
        await _firebaseService.firestore
            .collection(Trip.collection)
            .doc(selectedTrip!.id)
            .collection(Expense.collection)
            .add(expense.toMap());
      }

      await selectedTrip!.loadExpenses();
      successMessage = 'Expense record ${id != null ? 'updated' : 'added'} successfully';
    } catch (err) {
      errorMessage = 'Error ${id != null ? 'updating' : 'adding'} expense record';
      debugPrint(err.toString());
    } finally {
      notifyListeners();
    }
  }

  Future<void> deleteExpense(String expenseId) async {
    clearMessages();
    try {
      await _firebaseService.firestore
          .collection(Trip.collection)
          .doc(selectedTrip!.id)
          .collection(Expense.collection)
          .doc(expenseId)
          .delete();

      await selectedTrip!.loadExpenses();
      successMessage = 'Expense record deleted successfully';
    } catch (err) {
      errorMessage = 'Error deleting expense record';
      debugPrint(err.toString());
    } finally {
      notifyListeners();
    }
  }

  Future<String?> uploadImage(XFile image) async {
    clearMessages();
    try {
      final String extension = image.path.split('.').last;
      final ref = _firebaseService.storage
          .ref()
          .child(Trip.collection)
          .child(selectedTrip!.id!)
          .child('receipts')
          .child('receipt_${DateTime.now().millisecondsSinceEpoch}.$extension');

      final File file = File(image.path);
      final metadata = SettableMetadata(
        contentType: 'image/$extension',
        customMetadata: {
          'picked-file-path': file.path,
          'picked-file-user': _firebaseService.auth.currentUser!.uid
        },
      );

      final uploadTask = ref.putFile(file, metadata);
      await uploadTask.whenComplete(() {});

      successMessage = 'Image uploaded successfully';
      return await ref.getDownloadURL();
    } catch (err) {
      errorMessage = 'Error uploading image';
      debugPrint(err.toString());
      return null;
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
