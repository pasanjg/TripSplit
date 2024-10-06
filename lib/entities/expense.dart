import 'package:cloud_firestore/cloud_firestore.dart';

import 'user.dart';

class Expense {
  String? id;
  String? title;
  String? category;
  double? amount;
  DateTime? date;
  String? receiptUrl;
  DocumentReference? userRef;
  User? user;
  DateTime? createdAt = DateTime.now();
  DateTime? updatedAt = DateTime.now();

  static const String collection = 'expenses';
  static const String fieldDate = 'date';

  Expense({
    this.id,
    this.title,
    this.category,
    this.amount,
    this.date,
    this.receiptUrl,
    this.userRef,
  });

  Expense.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.id, snapshot.data() as Map<String, dynamic>);

  Expense.fromMap(String this.id, Map<String, dynamic> data) {
    title = data['title'];
    category = data['category'];
    amount = double.parse(data['amount'].toString());
    date = data['date'].toDate();
    receiptUrl = data['receiptUrl'];
    userRef = data['userRef'] != null
        ? data['userRef'] as DocumentReference
        : null;
    createdAt = data['createdAt'].toDate();
    updatedAt = data['updatedAt'].toDate();
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'category': category,
      'amount': amount,
      'date': date,
      'receiptUrl': receiptUrl,
      'userRef': userRef,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['category'] = category;
    data['amount'] = amount;
    data['date'] = date;
    data['receiptUrl'] = receiptUrl;
    data['userRef'] = userRef;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }

  @override
  String toString() {
    return toJson().toString();
  }
}
