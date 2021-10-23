import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  int? operator;
  int? price;
  int? validity;
  int? internet;
  int? talkTime;
  int? sms;
  int? available;
  bool? unlimited;
  String? title;
  String? description;
  bool? checkBeforeBuy;
  String? uId;
  String? productCode;
  bool? activeStatus;
  Timestamp? time;

  Product(
      {this.operator,
      this.price,
      this.validity,
      this.internet,
      this.talkTime,
      this.sms,
      this.available,
      this.unlimited,
      this.title,
      this.description,
      this.checkBeforeBuy,
      this.uId,
      this.productCode,
      this.activeStatus,
      this.time});

  factory Product.fromFirestore(DocumentSnapshot? snapshot) {
    var d = snapshot!.data();
    return Product(
      operator: d!['operator'],
      price: d['price'].round(),
      validity: d['validity'],
      internet: d['internet'],
      talkTime: d['talkTime'],
      sms: d['sms'],
      available: d['available'],
      unlimited: d['unlimited'],
      title: d['title'],
      description: d['description'],
      checkBeforeBuy: d['checkBeforeBuy'],
      uId: d['uId'],
      productCode: d['productCode'],
      activeStatus: d['activeStatus'],
      time: d['time'],
    );
  }
}
