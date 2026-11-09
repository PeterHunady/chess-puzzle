// ignore_for_file: file_names

// file: classUser_model.dart
//
// author: Peter Huňady (xhunadp00)
//
// date: 2024

import 'package:cloud_firestore/cloud_firestore.dart';

// Class of users in class
class ClassUsers {
  String id;
  String userId;
  String classId;
  bool isTeacher;

  ClassUsers({
    required this.id,
    required this.userId,
    required this.classId,
    required this.isTeacher,
  });

  // Create a ClassUsers object from a Firestore document snapshot
  factory ClassUsers.fromSnapshot(DocumentSnapshot snapshot) {
    return ClassUsers(
        id: snapshot['id'],
        userId: snapshot['userId'],
        classId: snapshot['classId'],
        isTeacher: snapshot['isTeacher']);
  }

  // Store data to map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'classId': classId,
      'isTeacher': isTeacher
    };
  }
}
