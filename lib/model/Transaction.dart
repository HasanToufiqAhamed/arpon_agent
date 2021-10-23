import 'package:cloud_firestore/cloud_firestore.dart';

class Transactions {
  int? category;
  double? amount;
  String? id;
  Timestamp? time;
  int? medium;


  Transactions({this.category, this.amount, this.id, this.time, this.medium});

  factory Transactions.fromFirestore(DocumentSnapshot? snapshot) {
    var d = snapshot?.data();
    return Transactions(
      category: d!['category'],
      amount: d['amount'].toDouble(),
      id: d['id'],
      time: d['time'],
      medium: d['medium'],
    );
  }
}
