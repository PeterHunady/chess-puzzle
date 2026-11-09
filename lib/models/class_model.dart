// file: class_model.dart
//
// author: Peter Huňady (xhunadp00)
//
// date: 2024

import 'package:cloud_firestore/cloud_firestore.dart';

// Class of classes
class Classes {
  String id;
  String name;
  String iconName;
  String classId;

  Classes(
      {required this.id,
      required this.name,
      required this.iconName,
      required this.classId});

  // Create a Classes object from a Firestore document snapshot
  factory Classes.fromSnapshot(DocumentSnapshot snapshot) {
    return Classes(
        id: snapshot['id'],
        name: snapshot['name'],
        iconName: snapshot['iconName'],
        classId: snapshot['classId']);
  }

  // Store data to map
  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'iconName': iconName, 'classId': classId};
  }
}
