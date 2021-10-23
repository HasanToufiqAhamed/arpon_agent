import 'package:cloud_firestore/cloud_firestore.dart';

class AgentActiveInfo {
  int? verified;

  AgentActiveInfo({this.verified});

  factory AgentActiveInfo.fromFirestore(DocumentSnapshot? snapshot) {
    var d = snapshot!.data();
    return AgentActiveInfo(
      verified: d!['verified'],
    );
  }
}
