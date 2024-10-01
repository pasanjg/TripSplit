import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:tripsplit/entities/user.dart';
import 'package:tripsplit/services/firebase_service.dart';

import '../common/helpers/helpers.dart';
import '../entities/expense.dart';
import '../entities/trip.dart';

class TripService {
  TripService._();

  static final TripService instance = TripService._();
  final FirebaseService _firebaseService = FirebaseService.instance;

  Stream<List<User>> getTripUsersStream(String tripId) {
    return FirebaseFirestore.instance
        .collection(Trip.collection)
        .doc(tripId)
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
  }

  Stream<Map<String, List<Expense>>> getTripExpensesStream(String tripId) {
    return _firebaseService.firestore
        .collection(Trip.collection)
        .doc(tripId)
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
  }

  Stream<List<Trip>> getUserTripsStream() {
    return _firebaseService.firestore
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
  }

  Future<void> createTrip(Trip trip) async {
    DocumentReference tripRef = await _firebaseService.firestore
        .collection(Trip.collection)
        .add(trip.toMap());
    String userId = _firebaseService.auth.currentUser!.uid;

    await tripRef.update({Trip.fieldInviteCode: tripRef.id.substring(0, 6)});
    await addUserToTripWithReference(tripRef.id, userId);
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

  Future<List<Trip>> getUserTrips() async {
    final user = await _firebaseService.firestore
        .collection(User.collection)
        .doc(_firebaseService.auth.currentUser!.uid)
        .get();

    final List<Trip> trips = await Future.wait(
      user.get(User.fieldTripRefs).map<Future<Trip>>((tripRef) async {
        DocumentSnapshot tripSnapshot = await tripRef.get();
        return Trip.fromMap(
          tripSnapshot.id,
          tripSnapshot.data() as Map<String, dynamic>,
        );
      }),
    );

    trips.sort((a, b) => a.startDate!.compareTo(b.startDate!));
    return trips;
  }

  Future<Trip> getTrip(String tripId) async {
    final tripSnapshot = await _firebaseService.firestore
        .collection(Trip.collection)
        .doc(tripId)
        .get();

    return Trip.fromMap(
      tripSnapshot.id,
      tripSnapshot.data() as Map<String, dynamic>,
    );
  }

  Future<String> refreshInviteCode(String tripId) async {
    final randomCode = generateRandomCode(6);
    await _firebaseService.firestore
        .collection(Trip.collection)
        .doc(tripId)
        .update({Trip.fieldInviteCode: randomCode});

    return randomCode;
  }

  Future<Map<String, dynamic>> joinTrip(String inviteCode) async {
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
        return {
          "success": false,
          "message": 'You are already a member of this trip',
          "trip": null,
        };
      }

      await addUserToTripWithReference(
        trip.id!,
        _firebaseService.auth.currentUser!.uid,
      );

      return {
        "success": true,
        "message": 'You have successfully joined the trip',
        "trip": trip,
      };
    } else {
      return {
        "success": false,
        "message": 'The invite code is invalid or invoked. Please try again with a valid code',
      };
    }
  }

  Future<Trip> assignGuestUserToTrip(User user, Trip trip) async {
    DocumentReference userRef = await _firebaseService.firestore
        .collection(User.collection)
        .add(user.toMap());

    trip.userRefs.add(userRef);
    await addUserToTripWithReference(trip.id!, userRef.id);

    return trip;
  }

  Future<Trip> assignMultipleGuests(List<String> guestIds, Trip trip) async {
    final tripRef = _firebaseService.firestore
        .collection(Trip.collection)
        .doc(trip.id);

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

    trip.userRefs.addAll(userRefs);
    return trip;
  }

  Future<void> addExpenseRecord(String tripId, Expense expense) async {
    await _firebaseService.firestore
        .collection(Trip.collection)
        .doc(tripId)
        .collection(Expense.collection)
        .add(expense.toMap());
  }

  Future<void> updateExpenseRecord(String tripId, Expense expense) async {
    await _firebaseService.firestore
        .collection(Trip.collection)
        .doc(tripId)
        .collection(Expense.collection)
        .doc(expense.id)
        .update(expense.toMap());
  }

  Future<void> deleteExpenseRecord(String tripId, String expenseId) async {
    await _firebaseService.firestore
        .collection(Trip.collection)
        .doc(tripId)
        .collection(Expense.collection)
        .doc(expenseId)
        .delete();
  }

  Future<String> uploadReceipt(XFile file, String tripId) async {
    final String extension = file.path.split('.').last;

    final ref = _firebaseService.storage
        .ref()
        .child(Trip.collection)
        .child(tripId)
        .child('receipts')
        .child('receipt_${DateTime.now().millisecondsSinceEpoch}.$extension');

    return await _firebaseService.uploadFile(file, ref);
  }
}
