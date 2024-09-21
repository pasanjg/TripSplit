import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tripsplit/entities/user.dart';

class Expense {
  String? id;
  String? title;
  String? category;
  double? amount;
  DateTime? date;
  DocumentReference? userRef;
  User? user;
  DateTime? createdAt = DateTime.now();
  DateTime? updatedAt = DateTime.now();

  static const String collection = 'expenses';

  Expense({
    this.id,
    this.title,
    this.category,
    this.amount,
    this.date,
    this.userRef,
  });

  Expense.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data() as Map<String, dynamic>);

  Expense.fromMap(Map<String, dynamic> data) {
    id = data['id'];
    title = data['title'];
    category = data['category'];
    amount = data['amount'];
    date = data['date'].toDate();
    userRef = data['userRef'] != null
        ? data['userRef'] as DocumentReference
        : null;
    createdAt = data['createdAt'].toDate();
    updatedAt = data['updatedAt'].toDate();
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'category': category,
      'amount': amount,
      'date': date,
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
    data['userRef'] = userRef;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }

  Future<void> loadUser() async {
    if (userRef != null) {
      final userSnapshot = await userRef!.get();
      user = User.fromMap(userSnapshot.id, userSnapshot.data() as Map<String, dynamic>);
    }
  }

  @override
  String toString() {
    return toJson().toString();
  }
}
