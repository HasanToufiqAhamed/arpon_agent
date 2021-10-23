import 'package:cloud_firestore/cloud_firestore.dart';

class MainReview {
  String? reviewId;
  String? productId;
  String? orderId;
  int? number;
  String? reviewText;
  String? sellerUid;
  String? uId;
  Timestamp? time;


  MainReview({this.reviewId, this.productId, this.orderId, this.number,
    this.reviewText, this.sellerUid, this.uId, this.time});

  factory MainReview.fromFirestore(DocumentSnapshot? snapshot) {
    var d = snapshot!.data();
    return MainReview(
      reviewId: d!['reviewId'],
      productId: d['productId'],
      orderId: d['orderId'],
      number: d['number'],
      reviewText: d['reviewText'],
      sellerUid: d['sellerUid'],
      uId: d['uId'],
      time: d['time'],
    );
  }
}
