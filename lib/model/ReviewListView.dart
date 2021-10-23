import 'package:cloud_firestore/cloud_firestore.dart';

class ReviewList {
  String? reviewId;
  String? productId;
  String? orderId;
  String? uId;
  Timestamp? time;


  ReviewList({this.reviewId, this.productId, this.orderId, this.uId, this.time});

  factory ReviewList.fromFirestore(DocumentSnapshot? snapshot) {
    var d = snapshot!.data();
    return ReviewList(
      reviewId: d!['reviewId'],
      productId: d['productId'],
      orderId: d['orderId'],
      uId: d['uId'],
      time: d['time'],
    );
  }
}
