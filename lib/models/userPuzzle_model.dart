// ignore_for_file: file_names

// file: puzzle_model.dart
//
// author: Peter Huňady (xhunadp00)
//
// date: 2024

import 'package:cloud_firestore/cloud_firestore.dart';

// Class of puzzle statistics of user
class UserPuzzles {
  String id;
  String puzzleId;
  String userId;
  String time;
  int attempts;
  bool solved;

  UserPuzzles(
      {required this.id,
      required this.puzzleId,
      required this.userId,
      required this.time,
      required this.attempts,
      required this.solved});

  // Create a UserPuzzles object from a Firestore document snapshot
  factory UserPuzzles.fromSnapshot(DocumentSnapshot snapshot) {
    return UserPuzzles(
        id: snapshot['id'],
        puzzleId: snapshot['puzzleId'],
        userId: snapshot['userId'],
        time: snapshot['time'],
        attempts: snapshot['attempts'],
        solved: snapshot['solved']);
  }

  // Store data to map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'puzzleId': puzzleId,
      'userId': userId,
      'time': time,
      'attempts': attempts,
      'solved': solved
    };
  }
}
