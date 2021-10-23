import 'package:cloud_firestore/cloud_firestore.dart';

class Bank {
  String? accountName;
  String? accountNumber;
  int? bName;

  Bank({this.accountName, this.accountNumber, this.bName});

  factory Bank.fromFirestore(DocumentSnapshot? snapshot) {
    var d = snapshot!.data();
    return Bank(
      accountName: d!['accountName'],
      accountNumber: d['accountNumber'],
      bName: d['bName'],
    );
  }
}
