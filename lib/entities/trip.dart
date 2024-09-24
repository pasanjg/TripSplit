import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tripsplit/entities/expense.dart';
import 'package:tripsplit/entities/user.dart';
import 'package:tripsplit/services/firebase_service.dart';

class Trip {
  String? id;
  String? title;
  DateTime? startDate;
  DateTime? endDate;
  String? inviteCode;
  List<DocumentReference> userRefs = [];
  List<User> users = [];
  List<Expense> expenses = [];
  String? createdBy;
  DateTime? createdAt = DateTime.now();
  DateTime? updatedAt = DateTime.now();

  static const String collection = 'trips';
  static const String fieldStartDate = 'startDate';
  static const String fieldUserRefs = 'userRefs';
  static const String fieldInviteCode = 'inviteCode';
  static const String fieldCreatedBy = 'createdBy';

  Stream<QuerySnapshot> get expensesStream {
    return FirebaseService.instance.firestore
        .collection(collection)
        .doc(id)
        .collection(Expense.collection)
        .snapshots();
  }

  Stream<List<User>> get userStreams {
    List<Stream<DocumentSnapshot>> userSnapshots = userRefs.map((userRef) {
      return userRef.snapshots();
    }).toList();

    return CombineLatestStream.list(userSnapshots).map((snapshots) {
      return snapshots.map((snapshot) {
        return User.fromMap(snapshot.id, snapshot.data() as Map<String, dynamic>);
      }).toList();
    });
  }

  Trip({
    this.id,
    this.title,
    this.startDate,
    this.endDate,
    this.userRefs = const [],
    this.inviteCode,
  });

  Trip.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.id, snapshot.data() as Map<String, dynamic>);

  Trip.fromMap(String this.id, Map<String, dynamic> data) {
    title = data['title'];
    startDate = data['startDate'].toDate();
    endDate = data['endDate'].toDate();
    userRefs = data['userRefs'] != null
        ? List<DocumentReference>.from(data['userRefs'])
        : [];
    inviteCode = data['inviteCode'];
    createdBy = data['createdBy'];
    createdAt = data['createdAt'].toDate();
    updatedAt = data['updatedAt'].toDate();
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'startDate': startDate,
      'endDate': endDate,
      'userRefs': userRefs,
      'inviteCode': inviteCode,
      'createdBy': createdBy,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['startDate'] = startDate;
    data['endDate'] = endDate;
    data['userRefs'] = userRefs;
    data['inviteCode'] = inviteCode;
    data['createdBy'] = createdBy;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }

  Future<void> loadExpenses() async {
    final expensesCollection = FirebaseService.instance.firestore
        .collection(collection)
        .doc(id)
        .collection(Expense.collection);

    final expenseSnapshots = await expensesCollection.get();
    expenses = expenseSnapshots.docs.map((doc) {
      return Expense.fromMap(doc.id, doc.data());
    }).toList();
  }

  Future<void> loadUsers() async {
    if (userRefs.isNotEmpty) {
      users = await Future.wait(userRefs.map((userRef) async {
        final userSnapshot = await userRef.get();
        return User.fromMap(userSnapshot.id, userSnapshot.data() as Map<String, dynamic>);
      }));
    }
  }

  @override
  String toString() {
    return toJson().toString();
  }
}
