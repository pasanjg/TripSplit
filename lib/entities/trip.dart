import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tripsplit/entities/expense.dart';
import 'package:tripsplit/services/firebase_service.dart';

class Trip {
  String? id;
  String? title;
  DateTime? dateFrom;
  DateTime? dateTo;
  List<DocumentReference> users = [];
  String? inviteCode;
  List<Expense> expenses = [];
  DateTime? createdAt = DateTime.now();
  DateTime? updatedAt = DateTime.now();

  static const String collection = 'trips';

  Trip({
    this.id,
    this.title,
    this.dateFrom,
    this.dateTo,
    this.users = const [],
    this.inviteCode,
  });

  Trip.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data() as Map<String, dynamic>);

  Trip.fromMap(Map<String, dynamic> data) {
    id = data['id'];
    title = data['title'];
    dateFrom = data['dateFrom'].toDate();
    dateTo = data['dateTo'].toDate();
    users = data['users'];
    inviteCode = data['inviteCode'];
    createdAt = data['createdAt'].toDate();
    updatedAt = data['updatedAt'].toDate();
  }

  Trip.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    dateFrom = json['dateFrom'];
    dateTo = json['dateTo'];
    users = json['users'];
    inviteCode = json['inviteCode'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['dateFrom'] = dateFrom;
    data['dateTo'] = dateTo;
    data['users'] = users;
    data['inviteCode'] = inviteCode;
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
      return Expense.fromMap(doc.data());
    }).toList();
  }

  @override
  String toString() {
    return toJson().toString();
  }
}
