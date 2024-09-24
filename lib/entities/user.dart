import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tripsplit/entities/trip.dart';

import '../services/firebase_service.dart';

class User {
  String? id;
  String? firstname;
  String? lastname;
  String? email;
  String? password;
  String? deviceToken;
  List<DocumentReference> tripRefs = [];
  List<Trip> trips = [];
  DateTime? createdAt = DateTime.now();
  DateTime? updatedAt = DateTime.now();

  static const String collection = 'users';
  static const String fieldTripRefs = 'tripRefs';
  static const String fieldDeviceToken = 'deviceToken';

  String get fullName => '$firstname $lastname';

  String get initials => '${firstname![0]}${lastname![0]}'.toUpperCase();

  bool get mySelf => id == FirebaseService.instance.auth.currentUser!.uid;

  Stream<List<Trip>> get tripStreams {
    List<Stream<DocumentSnapshot>> tripSnapshots = tripRefs.map((tripRef) {
      return tripRef.snapshots();
    }).toList();

    return CombineLatestStream.list(tripSnapshots).map((snapshots) {
      return snapshots.map((snapshot) {
        return Trip.fromMap(snapshot.id, snapshot.data() as Map<String, dynamic>);
      }).toList();
    });
  }

  User({
    this.id,
    this.firstname,
    this.lastname,
    this.email,
  });

  User.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.id, snapshot.data() as Map<String, dynamic>);

  User.fromMap(String this.id, Map<String, dynamic> data) {
    firstname = data['firstname'];
    lastname = data['lastname'];
    email = data['email'];
    deviceToken = data['deviceToken'];
    tripRefs = data['tripRefs'] != null
        ? List<DocumentReference>.from(data['tripRefs'])
        : [];
    createdAt = data['createdAt'].toDate();
    updatedAt = data['updatedAt'].toDate();
  }

  Map<String, dynamic> toMap() {
    return {
      'firstname': firstname,
      'lastname': lastname,
      'email': email,
      'deviceToken': deviceToken,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['firstname'] = firstname;
    data['lastname'] = lastname;
    data['email'] = email;
    data['deviceToken'] = deviceToken;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }

  Future<void> loadTrips() async {
    if (tripRefs.isNotEmpty) {
      trips = await Future.wait(tripRefs.map((tripRef) async {
        final tripSnapshot = await tripRef.get();
        return Trip.fromMap(tripSnapshot.id, tripSnapshot.data() as Map<String, dynamic>);
      }));
    }
  }

  @override
  String toString() {
    return toJson().toString();
  }
}
