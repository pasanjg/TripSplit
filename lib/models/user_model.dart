import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuthException;
import 'package:flutter/material.dart';
import 'package:tripsplit/services/firebase_service.dart';

import '../entities/user.dart';

class UserModel with ChangeNotifier {
  User? user;
  String? successMessage;
  String? errorMessage;

  final FirebaseService _firebaseService = FirebaseService.instance;

  // final authStateChanges = FirebaseService().authStateChanges;

  bool get isLoggedIn => user != null;

  Future<void> createUser({
    required String firstname,
    required String lastname,
    required String email,
    required String password,
  }) async {
    clearMessages();
    try {
      final credential = await _firebaseService.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      user = User(
        id: credential.user!.uid,
        firstname: firstname,
        lastname: lastname,
        email: email,
      );

      await saveUser(user!);
      successMessage = 'Registration successful';
    } catch (err) {
      switch (err.toString()) {
        case 'email-already-in-use':
          errorMessage = 'Email already in use';
          break;
        default:
          errorMessage = 'An error occurred';
          break;
      }
      debugPrint(err.toString());
    } finally {
      notifyListeners();
    }
  }

  Future<void> login({required String email, required String password}) async {
    clearMessages();
    try {
      await _firebaseService.loginFirebaseEmail(
        email: email,
        password: password,
      );

      await getUser();

      if (user != null) {
        await saveDeviceToken();
      } else {
        errorMessage = 'Unable to get user details';
      }
    } on FirebaseAuthException catch (err) {
      errorMessage = err.message ?? 'Something went wrong';
      debugPrint("[Auth] $err");
    } catch (err) {
      errorMessage = 'Something went wrong';
      debugPrint(err.toString());
    } finally {
      notifyListeners();
    }
  }

  Future<void> logout() async {
    try {
      await _firebaseService.logout();
      user = null;
    } catch (err) {
      debugPrint(err.toString());
    } finally {
      notifyListeners();
    }
  }

  Future<void> getUser() async {
    try {
      final user = await _firebaseService.getUserFromFirestore();
      setUser(user);
    } catch (err) {
      debugPrint(err.toString());
    }
  }

  Future<void> setUser(User? user) async {
    if (user != null) {
      this.user = user;
      notifyListeners();
    }
  }

  Future<void> saveUser(User user) async {
    try {
      await _firebaseService.saveUserToFirestore(user);

      // TODO: Save user to Box
    } catch (err) {
      debugPrint(err.toString());
    }
  }

  Future<void> saveDeviceToken() async {
    try {
      await _firebaseService.saveDeviceTokenToFirestore();
    } catch (err) {
      debugPrint(err.toString());
    }
  }

  void clearMessages() {
    successMessage = null;
    errorMessage = null;
    notifyListeners();
  }
}
