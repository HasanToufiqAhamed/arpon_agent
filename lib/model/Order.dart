import 'package:cloud_firestore/cloud_firestore.dart';

class Order {
  String? receiverNumber;
  String? orderId;
  String? uId;
  String? sellerUId;
  String? productId;
  Timestamp? time;
  int? paymentFrom;
  bool? payment;
  int? paymentAmount;
  Timestamp? paymentDate;
  bool? confirm;
  Timestamp? confirmDate;
  bool? send;
  Timestamp? sendDate;
  bool ?received;
  Timestamp? receiveDate;
  int ?status;
  bool? sellerPayment;

  Order(
      {this.receiverNumber,
      this.orderId,
      this.uId,
      this.sellerUId,
      this.productId,
      this.time,
      this.paymentFrom,
      this.payment,
      this.paymentAmount,
      this.paymentDate,
      this.confirm,
      this.confirmDate,
      this.send,
      this.sendDate,
      this.received,
      this.receiveDate,
      this.status,
      this.sellerPayment});

  factory Order.fromFirestore(DocumentSnapshot? snapshot) {
    var d = snapshot!.data();
    return Order(
      receiverNumber: d!['receiverNumber'],
      orderId: d['orderId'],
      uId: d['uId'],
      sellerUId: d['sellerUId'],
      productId: d['productId'],
      time: d['time'],
      paymentFrom: d['paymentFrom'],
      payment: d['payment'],
      paymentAmount: d['paymentAmount'].round(),
      paymentDate: d['paymentDate'],
      confirm: d['confirm'],
      confirmDate: d['confirmDate'],
      send: d['send'],
      sendDate: d['sendDate'],
      received: d['received'],
      receiveDate: d['receiveDate'],
      status: d['status'],
      sellerPayment: d['sellerPayment'],
    );
  }
}
