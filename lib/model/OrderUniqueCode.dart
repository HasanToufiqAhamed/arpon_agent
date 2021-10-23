import 'package:cloud_firestore/cloud_firestore.dart';

class OrderUniqueCode {
  String? orderCode;
  String? uId;
  DateTime? time;

  OrderUniqueCode({this.orderCode, this.uId, this.time});

  factory OrderUniqueCode.fromFirestore(DocumentSnapshot? snapshot) {
    var d = snapshot!.data();
    return OrderUniqueCode(
      orderCode: d!['orderCode'],
      uId: d['uId'],
      time: d['time'],
    );
  }
}
