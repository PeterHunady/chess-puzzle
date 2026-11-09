// file: user_model.dart
//
// author: Peter Huňady (xhunadp00)
//
// date: 2024

import 'package:cloud_firestore/cloud_firestore.dart';

// Class of users
class Users {
  String id;
  String name;
  String email;
  String password;
  String userId;

  Users(
      {required this.id,
      required this.name,
      required this.email,
      required this.password,
      required this.userId});

  // Create a Users object from a Firestore document snapshot
  factory Users.fromSnapshot(DocumentSnapshot snapshot) {
    return Users(
        id: snapshot['id'],
        name: snapshot['name'],
        email: snapshot['email'],
        password: snapshot['password'],
        userId: snapshot['userId']);
  }

  // Store data to map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'password': password,
      'userId': userId
    };
  }
}
