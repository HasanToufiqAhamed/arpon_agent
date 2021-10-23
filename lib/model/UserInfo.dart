import 'package:cloud_firestore/cloud_firestore.dart';

class UserInf {
  String? firstName;
  String? lastName;
  String? email;
  String? mobile;
  String? uId;
  String? token;
  String? image;
  String? referId;
  Timestamp? time;


  UserInf({this.firstName, this.lastName, this.email, this.mobile, this.uId,
    this.token, this.image, this.referId, this.time});

  factory UserInf.fromFirestore(DocumentSnapshot? snapshot) {
    var d = snapshot!.data();
    return UserInf(
      firstName: d!['firstName'],
      lastName: d['lastName'],
      email: d['email'],
      mobile: d['mobile'],
      uId: d['uId'],
      token: d['token'],
      image: d['image'],
      referId: d['referId'],
      time: d['time'],
    );
  }
}
