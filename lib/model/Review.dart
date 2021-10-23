import 'package:cloud_firestore/cloud_firestore.dart';

class Review {
  int? number;
  int? totalNumber;
  String? uId;
  String? lastId;
  Timestamp? time;

  Review({this.number, this.totalNumber, this.uId, this.lastId, this.time});

  factory Review.fromFirestore(DocumentSnapshot? snapshot) {
    var d = snapshot!.data();
    return Review(
      number: d!['number'],
      totalNumber: d['totalNumber'],
      uId: d['uId'],
      lastId: d['lastId'],
      time: d['time'],
    );
  }
}
