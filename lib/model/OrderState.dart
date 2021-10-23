import 'package:cloud_firestore/cloud_firestore.dart';

class OrderState {

  int? state;
  String? title;
  Timestamp? time;

  OrderState(this.state, this.title, this.time);
}
