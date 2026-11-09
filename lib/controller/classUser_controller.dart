// ignore_for_file: file_names, use_build_context_synchronously

// file: classUser_controller.dart
//
// author: Peter Huňady (xhunadp00)
//
// date: 2024

import 'package:chess/navigationAndToasts.dart';
import 'package:chess/controller/invitation_controller.dart';
import 'package:chess/controller/pendingInvitations_controller.dart';
import 'package:chess/controller/userPuzzle_controller.dart';
import 'package:chess/models/classUser_model.dart';
import 'package:chess/subpages/classHome_page.dart';
import 'package:chess/subpages/home_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Controller for users in classes
class ClassUsersController extends GetxController {
  final classUsersDatabase =
      FirebaseFirestore.instance.collection('classUsers');
  final classUsers = <ClassUsers>[].obs;

  // Function to fetch all data as a stream.
  Stream<List<ClassUsers>> getAllClassesOfUser() {
    return classUsersDatabase.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => ClassUsers.fromSnapshot(doc)).toList();
    });
  }

  @override
  void onInit() {
    classUsers.bindStream(getAllClassesOfUser());
    super.onInit();
  }

  // Create a new class and assign the teacher role to the user who is creating it.
  Future<void> createClassWithUser(
      BuildContext context, String userId, String classId) async {
    try {
      final documentUuid = classUsersDatabase.doc().id;
      ClassUsers classUser = ClassUsers(
          id: documentUuid, userId: userId, classId: classId, isTeacher: true);

      await classUsersDatabase.doc(documentUuid).set(classUser.toMap());
    } on FirebaseException {
      showToast("Error while creating class!");
    }
  }

  // Get role of the currently signed in user
  bool getCurrentUserRole(String userId, String classId) {
    try {
      return classUsers
          .where(
            (element) => element.userId == userId && element.classId == classId,
          )
          .first
          .isTeacher;
    } catch (e) {
      showToast("Error fetching short id of user!");
      return false;
    }
  }

  // Get the number of users in a class
  int getNumberOfUsers(String classId) {
    try {
      return classUsers.where((element) => element.classId == classId).length;
    } catch (e) {
      showToast("Error.");
      return 0;
    }
  }

  // Get ID of the class
  String getId(String classId) {
    try {
      return classUsers.where((element) => element.classId == classId).first.id;
    } catch (e) {
      showToast("Error.");
      return "";
    }
  }

  // Accept invitation from class
  Future<void> addUserToClass(BuildContext context, String classId,
      String userId, InvitationsController invitationsController) async {
    try {
      final documentUuid = classUsersDatabase.doc().id;
      ClassUsers classUser = ClassUsers(
          id: documentUuid, userId: userId, classId: classId, isTeacher: false);

      await classUsersDatabase.doc(documentUuid).set(classUser.toMap());
      invitationsController.deleteInvitation(context, userId, classId);
      SharedPreferences preferences = await SharedPreferences.getInstance();
      preferences.setString('classId', classId);
      navigateScreenWithoutBackNavigation(
          context,
          ClassHomePage(
            userId: userId,
            isTeacher: false,
          ));
    } catch (e) {
      showToast("Error.");
    }
  }

  // Accept invitation of member
  Future<void> confirmUserToClass(
      BuildContext context,
      String classId,
      String userId,
      PendingInvitationsController pendingInvitationsController) async {
    try {
      final documentUuid = classUsersDatabase.doc().id;
      ClassUsers classUser = ClassUsers(
          id: documentUuid, userId: userId, classId: classId, isTeacher: false);

      await classUsersDatabase.doc(documentUuid).set(classUser.toMap());
      pendingInvitationsController.deletePendingInvitation(
          context, userId, classId);

      navigateScreen(
          context,
          ClassHomePage(
            userId: userId,
            isTeacher: false,
          ));
    } catch (e) {
      showToast("Error.");
    }
  }

  // Check if the user is already in the class
  bool isAlreadyInClass(String classId, String userId) {
    try {
      int userInClass = classUsers
          .where(
            (element) => element.classId == classId && userId == element.userId,
          )
          .length;

      if (userInClass == 0) {
        return false;
      } else {
        return true;
      }
    } catch (e) {
      showToast("Error fetching class name.");
      return false;
    }
  }

  // Get the number of classes of user
  int numberOfClassesOfUser(String userId) {
    try {
      return classUsers.where((element) => element.userId == userId).length;
    } on FirebaseException {
      showToast("Error!");
      return 0;
    }
  }

  // Navigate user to class
  Future<void> navigateUserToClass(
      BuildContext context, String userId, bool isTeacher) async {
    try {
      if (numberOfClassesOfUser(userId) == 0) {
        showToast("You are not in any class!");
        navigateScreenWithoutBackNavigation(context, const HomePage());
        return;
      }

      String firstClassId =
          classUsers.where((element) => element.userId == userId).first.classId;

      SharedPreferences preferences = await SharedPreferences.getInstance();

      if (preferences.getString("classId") == null) {
        preferences.setString('classId', firstClassId);
      }

      navigateScreenWithoutBackNavigation(
          context,
          ClassHomePage(
            userId: userId,
            isTeacher: isTeacher,
          ));
    } catch (e) {
      showToast("Error.");
    }
  }

  // Change role of the user (to teacher or student)
  Future<void> changeUserRole(BuildContext context, String userId,
      String classId, bool isTeacher) async {
    try {
      String id = classUsers
          .where((element) =>
              element.classId == classId && element.userId == userId)
          .first
          .id;

      await classUsersDatabase.doc(id).update({'isTeacher': isTeacher});
    } on FirebaseException {
      showToast("Error while creating statistic of user!");
    }
  }

  // Remove user from class and delete his statistics
  Future<void> removeUserFromClass(BuildContext context, String userId,
      String classId, bool isTeacher) async {
    try {
      UserPuzzleController userPuzzleController =
          Get.put(UserPuzzleController());

      String id = classUsers
          .where((element) =>
              element.classId == classId && element.userId == userId)
          .first
          .id;

      await classUsersDatabase.doc(id).delete();
      userPuzzleController.removeUserFromStatistics(context, userId);
      Navigator.pop(context);
    } on FirebaseException {
      showToast("Error while creating statistic of user!");
    }
  }
}
