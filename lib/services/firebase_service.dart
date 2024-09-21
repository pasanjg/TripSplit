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

  // Stream<auth.User?> get authStateChanges => auth.authStateChanges();

  Future<firebase_auth.UserCredential> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    return await auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<firebase_auth.UserCredential> loginFirebaseEmail({
    required String email,
    required String password,
  }) async {
    return await auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> logout() async {
    await auth.signOut();
  }

  Future<void> saveUserToFirestore(User user) async {
    final token = await messaging.getToken();
    user.deviceToken = token;
    print('token: $token');
    await firestore
        .collection(User.collection)
        .doc(user.id)
        .set(user.toMap());
  }

  Future<User?> getUserFromFirestore() async {
    if (auth.currentUser == null) {
      return null;
    }

    final userSnapshot = await firestore
        .collection(User.collection)
        .doc(auth.currentUser!.uid)
        .get();

    return User.fromMap(
      userSnapshot.id,
      userSnapshot.data() as Map<String, dynamic>,
    );
  }
}
