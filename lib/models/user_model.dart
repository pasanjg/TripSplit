import 'package:flutter/material.dart';
import 'package:tripsplit/services/firebase_service.dart';

import '../entities/user.dart';

class UserModel with ChangeNotifier {
  User? user;
  final FirebaseService _firebaseService = FirebaseService();
  // final authStateChanges = FirebaseService().authStateChanges;

  bool get isLoggedIn => user != null;

  Future<void> createUser({
    required String firstname,
    required String lastname,
    required String email,
    required String password,
  }) async {
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
      notifyListeners();
    } catch (err) {
      print(err);
    }
  }

  Future<void> login({required String email, required String password}) async {
    try {
      await _firebaseService.loginFirebaseEmail(
        email: email,
        password: password,
      );

      await getUser();
    } catch (err) {
      print(err);
    }
  }

  Future<void> logout() async {
    try {
      await _firebaseService.logout();
      user = null;
      notifyListeners();
    } catch (err) {
      print(err);
    }
  }

  Future<void> setUser(User? user) async {
    if (user != null) {
      this.user = user;
      await saveUser(user);
      notifyListeners();
    }
  }

  Future<void> getUser() async {
    try {
      final user = await _firebaseService.getUserFromFirestore();
      setUser(user);
    } catch (err) {
      print(err);
    }
  }

  Future<void> saveUser(User user) async {
    try {
      await _firebaseService.saveUserToFirestore(user);

      // TODO: Save user to Box

    } catch (err) {
      print(err);
    }
  }
}
