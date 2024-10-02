
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:tripsplit/entities/user.dart';
import 'package:tripsplit/services/connectivity_service.dart';
import 'package:tripsplit/services/firebase_service.dart';
import 'package:tripsplit/services/services.dart';
import 'package:tripsplit/services/trip_service.dart';
import 'package:tripsplit/services/user_service.dart';

import '../entities/expense.dart';
import '../entities/trip.dart';

class TripModel with ChangeNotifier {
  Trip? selectedTrip;
  String? successMessage;
  String? errorMessage;

  final FirebaseService _firebaseService = Service.instance.firebase;
  final TripService _tripService = Service.instance.trip;
  final UserService _userService = Service.instance.user;
  final ConnectivityService _connectivityService = Service.instance.connectivity;

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
      stream = _tripService.getUserTripsStream();
    } catch (err) {
      debugPrint(err.toString());
      stream = const Stream.empty();
    }

    return stream;
  }

  Stream<List<User>> get tripUsersStream {
    Stream<List<User>> stream;
    try {
      stream = _tripService.getTripUsersStream(selectedTrip!.id!);
    } catch (err) {
      debugPrint(err.toString());
      stream = const Stream.empty();
    }

    return stream;
  }

  Stream<Map<String, List<Expense>>> get tripExpensesStream {
    Stream<Map<String, List<Expense>>> stream;
    try {
      stream = _tripService.getTripExpensesStream(selectedTrip!.id!);
    } catch (err) {
      debugPrint(err.toString());
      stream = const Stream.empty();
    }

    return stream;
  }

  double getUserExpensesTotal(String userId) {
    if (selectedTrip == null) {
      return 0.0;
    }

    return selectedTrip!.expenses
        .where((expense) => expense.userRef!.id == userId)
        .fold(0.0, (prev, expense) => prev + expense.amount!);
  }

  Map<String, List<Expense>> getUserExpenses(String userId) {
    if (selectedTrip == null) {
      return {};
    }

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
        createdBy: _firebaseService.auth.currentUser!.uid,
      );

      bool isOnline = await _connectivityService.checkConnectivity();

      if (isOnline) {
        await _tripService.createTrip(trip);
        successMessage = 'Trip created successfully';
      } else {
        _tripService.createTrip(trip);
        successMessage = 'Trip created in offline mode';
      }

      await getUserTrips();
    } catch (err) {
      errorMessage = 'Error creating trip';
      debugPrint("Error creating trip: $err");
    }
  }

  Future<void> getUserTrips({Trip? selected}) async {
    try {
      final List<Trip> trips = await _tripService.getUserTrips();

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
      selectedTrip = await _tripService.getTrip(tripId);

      await selectedTrip!.loadExpenses();
      await selectedTrip!.loadUsers();
    } catch (err) {
      debugPrint(err.toString());
    } finally {
      notifyListeners();
    }
  }

  Future<void> refreshInviteCode() async {
    try {
      final isOnline = await _connectivityService.checkConnectivity();

      if (!isOnline) {
        errorMessage = 'You need to be online to refresh the invite code';
        notifyListeners();
        return;
      }

      final String randomCode = await _tripService.refreshInviteCode(selectedTrip!.id!);

      selectedTrip!.inviteCode = randomCode;
      successMessage = 'Invite code refreshed successfully';
    } catch (err) {
      errorMessage = 'Error refreshing invite code';
      debugPrint(err.toString());
    } finally {
      notifyListeners();
    }
  }

  Future<void> joinTrip(String inviteCode) async {
    clearMessages();
    try {
      final isOnline = await _connectivityService.checkConnectivity();

      if (!isOnline) {
        errorMessage = 'You need to be online to join a trip';
        notifyListeners();
        return;
      }

      Map<String, dynamic> result = await _tripService.joinTrip(inviteCode);
      bool success = result['success'];
      String message = result['message'];
      Trip? trip = result['trip'];

      if (success == true && trip != null) {
        // success - trip joined
        await getUserTrips();
        await selectTrip(trip);
        successMessage = message;
      } else if(success == false && trip == null) {
        // error - user already a member of the trip
        errorMessage = message;
      } else {
        // error - invalid invite code
        errorMessage = result.values.first;
      }
    } catch (err) {
      errorMessage = 'Error joining trip';
      debugPrint(err.toString());
    } finally {
      notifyListeners();
    }
  }

  Future<void> assignGuestUserToTrip({
    required String firstname,
    required String lastname,
  }) async {
    clearMessages();
    try {
      final isOnline = await _connectivityService.checkConnectivity();

      if (!isOnline) {
        errorMessage = 'You need to be online to add a user';
        notifyListeners();
        return;
      }

      final user = User(
        firstname: firstname,
        lastname: lastname,
        createdBy: _firebaseService.auth.currentUser!.uid,
      );

      selectedTrip = await _tripService.assignGuestUserToTrip(
        user,
        selectedTrip!,
      );

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
      final isOnline = await _connectivityService.checkConnectivity();

      if (!isOnline) {
        errorMessage = 'You need to be online to add users';
        notifyListeners();
        return;
      }

      selectedTrip = await _tripService.assignMultipleGuests(
        guestIds,
        selectedTrip!,
      );

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
      return await _userService.getUserGuestsFromFirestore(selectedTrip!.id!);
    } catch (err) {
      debugPrint(err.toString());
    }

    return [];
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
      bool isOnline = await _connectivityService.checkConnectivity();

      final expense = Expense(
        id: id,
        title: title,
        category: category,
        date: date,
        amount: amount,
        userRef: userRef,
        receiptUrl: receiptUrl,
      );

      final operation = id != null
          ? _tripService.updateExpenseRecord(selectedTrip!.id!, expense)
          : _tripService.addExpenseRecord(selectedTrip!.id!, expense);

      if (isOnline) {
        await operation;
      } else {
        operation;

        if (id == null) {
          selectedTrip!.expenses.add(expense);
        } else {
          final index = selectedTrip!.expenses.indexWhere((e) => e.id == id);
          selectedTrip!.expenses[index] = expense;
        }
      }

      await selectedTrip!.loadExpenses();
      successMessage = 'Expense record ${id != null ? 'updated' : 'added'} successfully ${isOnline ? '' : 'in offline mode'}';
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
      final isOnline = await _connectivityService.checkConnectivity();

      if (isOnline) {
        await _tripService.deleteExpenseRecord(selectedTrip!.id!, expenseId);
        await selectedTrip!.loadExpenses();
        successMessage = 'Expense record deleted successfully';
      } else {
        _tripService.deleteExpenseRecord(selectedTrip!.id!, expenseId);
        await selectedTrip!.loadExpenses();
        successMessage = 'Expense record deleted in offline mode';
      }
    } catch (err) {
      errorMessage = 'Error deleting expense record';
      debugPrint(err.toString());
    } finally {
      notifyListeners();
    }
  }

  Future<String?> uploadImage(XFile image) async {
    clearMessages();
    final isOnline = await _connectivityService.checkConnectivity();

    if (!isOnline) {
      errorMessage = 'You need to be online to upload an image';
      notifyListeners();
      return null;
    }

    try {
      final downloadUrl = await _tripService.uploadReceipt(image, selectedTrip!.id!);
      successMessage = 'Image uploaded successfully';

      return downloadUrl;
    } catch (err) {
      errorMessage = 'Error uploading image';
      debugPrint(err.toString());
      return null;
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

  void clearSelectedTrip() {
    selectedTrip = null;
    notifyListeners();
  }

  void clearMessages() {
    successMessage = null;
    errorMessage = null;
  }
}
