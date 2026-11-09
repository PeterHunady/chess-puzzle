// ignore_for_file: file_names

// file: pendingInvitations_model.dart
//
// author: Peter Huňady (xhunadp00)
//
// date: 2024

import 'package:cloud_firestore/cloud_firestore.dart';

// Class of pending invitations for class
class PendingInvitations {
  String id;
  String classId;
  String userId;

  PendingInvitations(
      {required this.id, required this.classId, required this.userId});

  // Create a PendingInvitations object from a Firestore document snapshot
  factory PendingInvitations.fromSnapshot(DocumentSnapshot snapshot) {
    return PendingInvitations(
        id: snapshot['id'],
        classId: snapshot['classId'],
        userId: snapshot['userId']);
  }

  // Store data to map
  Map<String, dynamic> toMap() {
    return {'id': id, 'classId': classId, 'userId': userId};
  }
}
