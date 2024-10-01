import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

import '../entities/trip.dart';
import '../entities/user.dart';
import 'firebase_service.dart';

class UserService {
  UserService._();

  static final UserService instance = UserService._();

  final FirebaseService _firebaseService = FirebaseService.instance;

  Future<firebase_auth.UserCredential> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    return await _firebaseService.auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<firebase_auth.UserCredential> loginFirebaseEmail({
    required String email,
    required String password,
  }) async {
    return await _firebaseService.auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> saveUserToFirestore(User user) async {
    final token = await _firebaseService.messaging.getToken();
    user.deviceToken = token;
    debugPrint('token: $token');
    await _firebaseService.firestore.collection(User.collection).doc(user.id).set(user.toMap());
  }

  Future<void> saveDeviceTokenToFirestore() async {
    final token = await _firebaseService.messaging.getToken();
    await _firebaseService.firestore
        .collection(User.collection)
        .doc(_firebaseService.auth.currentUser!.uid)
        .update({User.fieldDeviceToken: token});
  }

  Future<User?> getUserFromFirestore() async {
    if (_firebaseService.auth.currentUser == null) {
      return null;
    }

    final userSnapshot = await _firebaseService.firestore
        .collection(User.collection)
        .doc(_firebaseService.auth.currentUser!.uid)
        .get();

    return User.fromMap(
      userSnapshot.id,
      userSnapshot.data() as Map<String, dynamic>,
    );
  }

  Future<List<User>> getUserGuestsFromFirestore(String tripId) async {
    final tripRef = _firebaseService.firestore
        .collection(Trip.collection)
        .doc(tripId);

    final userSnapshot = await _firebaseService.firestore
        .collection(User.collection)
        .where(User.fieldCreatedBy, isEqualTo: _firebaseService.auth.currentUser!.uid)
        .get();

    final users = userSnapshot.docs.map((doc) {
      return User.fromMap(doc.id, doc.data());
    }).toList();

    return users.where((user) => !user.tripRefs.contains(tripRef)).toList();
  }

  Future<void> logout() async {
    await _firebaseService.auth.signOut();
  }
}
