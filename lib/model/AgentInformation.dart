import 'package:cloud_firestore/cloud_firestore.dart';

class AgentInformation {
  String? name;
  String? uid;
  String? image;
  String? token;
  Timestamp? time;


  AgentInformation({this.name, this.uid, this.image, this.token, this.time});

  factory AgentInformation.fromFirestore(DocumentSnapshot? snapshot) {
    var d = snapshot!.data();
    return AgentInformation(
      name: d!['name'],
      uid: d['uid'],
      image: d['image'],
      token: d['token'],
      time: d['time'],
    );
  }
}
