import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:image_picker/image_picker.dart';


class FirebaseService {
  FirebaseService._();

  static final FirebaseService instance = FirebaseService._();

  final firebase_auth.FirebaseAuth _auth = firebase_auth.FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  firebase_auth.FirebaseAuth get auth => _auth;

  FirebaseFirestore get firestore => _firestore;

  FirebaseMessaging get messaging => _messaging;

  FirebaseStorage get storage => FirebaseStorage.instance;

  // Stream<auth.User?> get authStateChanges => auth.authStateChanges();

  Future<String> uploadFile(XFile xFile, Reference ref) async {
    final String extension = xFile.path.split('.').last;
    final File file = File(xFile.path);
    final metadata = SettableMetadata(
      contentType: 'image/$extension',
      customMetadata: {
        'picked-file-path': file.path,
        'picked-file-user': auth.currentUser!.uid
      },
    );

    final uploadTask = ref.putFile(file, metadata);
    await uploadTask.whenComplete(() {});

    return await ref.getDownloadURL();
  }
}
