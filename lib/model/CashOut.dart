import 'package:cloud_firestore/cloud_firestore.dart';

class CashOut {
  double? amount;
  Timestamp? time;
  int? method;
  int? way;

  CashOut({this.amount, this.time, this.method, this.way});

  factory CashOut.fromFirestore(DocumentSnapshot? snapshot) {
    var d = snapshot!.data();
    return CashOut(
      amount: d!['amount'].toDouble(),
      time: d['time'],
      method: d['method'],
      way: d['way'],
    );
  }
}
