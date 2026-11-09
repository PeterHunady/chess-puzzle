// ignore_for_file: use_build_context_synchronously

// file: class_controller.dart
//
// author: Peter Huňady (xhunadp00)
//
// date: 2024

import 'package:chess/controller/classUser_controller.dart';
import 'package:chess/models/class_model.dart';
import 'package:chess/navigationAndToasts.dart';
import 'package:chess/subpages/classHome_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';

// Controller for classes
class ClassController extends GetxController {
  final classDatabase = FirebaseFirestore.instance.collection('classes');
  final ClassUsersController classUsersController =
      Get.put(ClassUsersController());

  final classes = <Classes>[].obs;

  // Function to fetch all data as a stream.
  Stream<List<Classes>> getAllClasses() {
    return classDatabase.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => Classes.fromSnapshot(doc)).toList()
        ..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    });
  }

  @override
  void onInit() {
    classes.bindStream(getAllClasses());
    super.onInit();
  }

  // Create a new class
  Future<void> createClass(
      BuildContext context, String name, String iconName, String userId) async {
    try {
      final documentUuid = classDatabase.doc().id;
      //throw error if some input is wrong
      if (name.length < 2) {
        showToast("Name of the class should be at least 2 characters long!");
        return;
      } else if (name.length > 20) {
        showToast("Name of the class should be less than 20 characters long!");
        return;
      } else if (iconName == "") {
        showToast("Pick icon of your class!");
        return;
      }

      //create new class
      Classes chessClass = Classes(
          id: documentUuid,
          name: name.trim(),
          iconName: iconName,
          classId: "#${documentUuid.substring(0, 6)}");
      await classDatabase.doc(documentUuid).set(chessClass.toMap());

      SharedPreferences preferences = await SharedPreferences.getInstance();

      preferences.setString('classId', documentUuid);

      if (userId != "") {
        await classUsersController.createClassWithUser(
            context, userId, documentUuid);
      } else {
        showToast("User ID not found in SharedPreferences.");
      }

      navigateScreenWithoutBackNavigation(
          context,
          ClassHomePage(
            userId: userId,
            isTeacher: true,
          ));
    } on FirebaseException {
      showToast("Error while creating class!");
    }
  }

  // Get the current (opened) class name.
  String getCurrentClassName(String classId) {
    getAllClasses();
    try {
      return classes
          .where(
            (element) => element.id == classId,
          )
          .first
          .name;
    } catch (e) {
      showToast("Error fetching class name.");
      return "";
    }
  }

  // Get the current (opened) class icon.
  String getCurrentClassIcon(String classId) {
    try {
      return classes
          .where(
            (element) => element.id == classId,
          )
          .first
          .iconName;
    } catch (e) {
      showToast("Error fetching class name.");
      return "";
    }
  }

  // Get current (opened) class short id
  String getCurrentClassShortId(String classId) {
    try {
      return classes
          .where(
            (element) => element.id == classId,
          )
          .first
          .classId;
    } catch (e) {
      showToast("Error fetching class name.");
      return "";
    }
  }

  // Get ID of class from short ID
  String getIdOfClassFromShortId(String shortIdOfClass) {
    try {
      String classId = "";

      if (shortIdOfClass.length != 7 && shortIdOfClass.length != 6) {
        showToast("Invalid length of class ID!");
        return "";
      }

      if (!shortIdOfClass.contains("#")) {
        shortIdOfClass = "#$shortIdOfClass";

        classId = classes
            .where((element) => element.classId == shortIdOfClass)
            .first
            .id;
      } else {
        classId = classes
            .where((element) => element.classId == shortIdOfClass)
            .first
            .id;
      }

      return classId;
    } catch (e) {
      showToast("Class ID not found!");
      return "";
    }
  }
}
