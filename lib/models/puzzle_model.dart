// ignore_for_file: file_names

// file: puzzle_model.dart
//
// author: Peter Huňady (xhunadp00)
//
// date: 2024

import 'package:cloud_firestore/cloud_firestore.dart';

// Class of puzzles
class Puzzles {
  String id;
  String puzzleName;
  String classId;
  String startingPosition;
  String imageUrl;
  List puzzleMoves;
  List puzzleMoveNotation;

  Puzzles(
      {required this.id,
      required this.puzzleName,
      required this.classId,
      required this.startingPosition,
      required this.imageUrl,
      required this.puzzleMoves,
      required this.puzzleMoveNotation});

  // Create a Puzzles object from a Firestore document snapshot
  factory Puzzles.fromSnapshot(DocumentSnapshot snapshot) {
    return Puzzles(
        id: snapshot['id'],
        puzzleName: snapshot['puzzleName'],
        classId: snapshot['classId'],
        startingPosition: snapshot['startingPosition'],
        imageUrl: snapshot['imageUrl'],
        puzzleMoves: snapshot['puzzleMoves'],
        puzzleMoveNotation: snapshot['puzzleMoveNotation']);
  }

  // Store data to map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'puzzleName': puzzleName,
      'classId': classId,
      'startingPosition': startingPosition,
      'imageUrl': imageUrl,
      'puzzleMoves': puzzleMoves,
      'puzzleMoveNotation': puzzleMoveNotation
    };
  }
}
