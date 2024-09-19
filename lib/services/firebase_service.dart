import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:firebase_messaging/firebase_messaging.dart';

import '../entities/user.dart';

class FirebaseService {
  FirebaseService._();

  static final instance = FirebaseService._();

  final firebase_auth.FirebaseAuth _auth = firebase_auth.FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  firebase_auth.FirebaseAuth get auth => _auth;

  FirebaseFirestore get firestore => _firestore;

  FirebaseMessaging get messaging => _messaging;

  // Stream<auth.User?> get authStateChanges => _auth.authStateChanges();

  Future<firebase_auth.UserCredential> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    return await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> loginFirebaseEmail({
    required String email,
    required String password,
  }) async {
    await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> logout() async {
    await _auth.signOut();
  }

  Future<void> saveUserToFirestore(User user) async {
    final token = await _messaging.getToken();
    user.deviceToken = token;
    print('token: $token');
    await _firestore.collection(User.collection).doc(user.id).set(user.toJson());
  }

  Future<User?> getUserFromFirestore() async {
    if (_auth.currentUser == null) {
      return null;
    }
    print('uid: ${_auth.currentUser!.uid}');

    final user =
        await _firestore.collection(User.collection).doc(_auth.currentUser!.uid).get();
    return User.fromMap(user.data() as Map<String, dynamic>);
  }
}
