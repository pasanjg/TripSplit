import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuthException;
import 'package:flutter/material.dart';
import 'package:tripsplit/services/connectivity_service.dart';
import 'package:tripsplit/services/services.dart';
import 'package:tripsplit/services/user_service.dart';

import '../entities/user.dart';

class UserModel with ChangeNotifier {
  User? user;
  String? successMessage;
  String? errorMessage;

  final UserService _userService = Service.instance.user;
  final ConnectivityService _connectivityService = Service.instance.connectivity;

  bool get isLoggedIn => user != null;

  Future<void> createUser({
    required String firstname,
    required String lastname,
    required String email,
    required String password,
  }) async {
    clearMessages();
    try {
      final isOnline = await _connectivityService.checkConnectivity();

      if (!isOnline) {
        errorMessage = 'You need to be online to register';
        notifyListeners();
        return;
      }

      final credential = await _userService.createUserWithEmailAndPassword(
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
      final isOnline = await _connectivityService.checkConnectivity();

      if (!isOnline) {
        errorMessage = 'You need to be online to login';
        notifyListeners();
        return;
      }

      await _userService.loginFirebaseEmail(
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
      await _userService.logout();
      user = null;
    } catch (err) {
      debugPrint(err.toString());
    } finally {
      notifyListeners();
    }
  }

  Future<void> getUser() async {
    try {
      final user = await _userService.getUserFromFirestore();
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
      await _userService.saveUserToFirestore(user);

      // TODO: Save user to Box
    } catch (err) {
      debugPrint(err.toString());
    }
  }

  Future<void> saveDeviceToken() async {
    try {
      final isOnline = await _connectivityService.checkConnectivity();

      if (isOnline) {
        await _userService.saveDeviceTokenToFirestore();
      } else {
        _userService.saveDeviceTokenToFirestore();
      }
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
