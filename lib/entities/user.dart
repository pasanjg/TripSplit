import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String? id;
  String? firstname;
  String? lastname;
  String? email;
  String? deviceToken;
  DateTime? createdAt;
  DateTime? updatedAt;

  String? password;

  User({
    this.id,
    this.firstname,
    this.lastname,
    this.email,
    this.createdAt,
    this.updatedAt,
  }) {
    createdAt = DateTime.now();
    updatedAt = DateTime.now();
  }

  String get fullName => '$firstname $lastname';
  String get initials => '${firstname![0]}${lastname![0]}';

  User.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data() as Map<String, dynamic>);

  User.fromMap(Map<String, dynamic> data) {
    id = data['id'];
    firstname = data['firstname'];
    lastname = data['lastname'];
    email = data['email'];
    deviceToken = data['deviceToken'];
    createdAt = data['createdAt'].toDate();
    updatedAt = data['updatedAt'].toDate();
  }

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstname = json['firstname'];
    lastname = json['lastname'];
    email = json['email'];
    deviceToken = json['deviceToken'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
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

  @override
  String toString() {
    return toJson().toString();
  }
}
