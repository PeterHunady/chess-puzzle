// file: invitations_model.dart
//
// author: Peter Huňady (xhunadp00)
//
// date: 2024

import 'package:cloud_firestore/cloud_firestore.dart';

// Class of invitations for user
class Invitations {
  String id;
  String classId;
  String userId;

  Invitations({required this.id, required this.classId, required this.userId});

  // Create Invitations object from a Firestore document snapshot
  factory Invitations.fromSnapshot(DocumentSnapshot snapshot) {
    return Invitations(
        id: snapshot['id'],
        classId: snapshot['classId'],
        userId: snapshot['userId']);
  }

  // Store data to map
  Map<String, dynamic> toMap() {
    return {'id': id, 'classId': classId, 'userId': userId};
  }
}
