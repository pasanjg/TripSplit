import 'package:cloud_firestore/cloud_firestore.dart';

class Expense {
  String? id;
  String? title;
  String? category;
  double? amount;
  DateTime? date;
  DocumentReference? user;
  DateTime? createdAt = DateTime.now();
  DateTime? updatedAt = DateTime.now();

  static const String collection = 'expenses';

  Expense({
    this.id,
    this.title,
    this.category,
    this.amount,
    this.date,
    this.user,
  });

  Expense.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data() as Map<String, dynamic>);

  Expense.fromMap(Map<String, dynamic> data) {
    id = data['id'];
    title = data['title'];
    category = data['category'];
    amount = data['amount'];
    date = data['date'].toDate();
    user = data['user'];
    createdAt = data['createdAt'].toDate();
    updatedAt = data['updatedAt'].toDate();
  }

  Expense.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    category = json['category'];
    amount = json['amount'];
    date = json['date'];
    user = json['user'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['category'] = category;
    data['amount'] = amount;
    data['date'] = date;
    data['user'] = user;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }

  @override
  String toString() {
    return toJson().toString();
  }
}
