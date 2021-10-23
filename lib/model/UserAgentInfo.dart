import 'package:cloud_firestore/cloud_firestore.dart';

class UserAgentInfo {
  String? name;
  String? image;
  int? revTotalNumber;
  int? revNumber;


  UserAgentInfo({this.name, this.image, this.revTotalNumber, this.revNumber});

  factory UserAgentInfo.fromFirestore(DocumentSnapshot? snapshot) {
    var d = snapshot!.data();
    return UserAgentInfo(
      name: d!['name'],
      image: d['image'],
      revTotalNumber: d['revTotalNumber'],
      revNumber: d['revNumber'],
    );
  }
}
