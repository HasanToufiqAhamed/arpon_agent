import 'package:cloud_firestore/cloud_firestore.dart';

class Balance {
  double? balance;

  Balance({this.balance});

  factory Balance.fromFirestore(DocumentSnapshot? snapshot) {
    var d = snapshot!.data();
    return Balance(
      balance: d!['balance'].toDouble(),
    );
  }
}
