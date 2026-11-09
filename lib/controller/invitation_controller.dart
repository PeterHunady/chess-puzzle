// ignore_for_file: file_names, use_build_context_synchronously

// file: invitation_controller.dart
//
// author: Peter Huňady (xhunadp00)
//
// date: 2024

import 'package:chess/navigationAndToasts.dart';
import 'package:chess/controller/classUser_controller.dart';
import 'package:chess/controller/user_controller.dart';
import 'package:chess/models/invitations_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Controller for invitations from classes to users
class InvitationsController extends GetxController {
  final invitationsDatabase =
      FirebaseFirestore.instance.collection('invitations');
  final invitations = <Invitations>[].obs;
  final UserController userController = Get.put(UserController());

  // Function to fetch all data as a stream.
  Stream<List<Invitations>> getAllInvitations() {
    return invitationsDatabase.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => Invitations.fromSnapshot(doc)).toList();
    });
  }

  @override
  void onInit() {
    invitations.bindStream(getAllInvitations());
    super.onInit();
  }

  // Create a new invitation for user (as teacher)
  Future<void> createInvitation(BuildContext context, String shortIdOfUser,
      String classId, ClassUsersController classUsersController) async {
    try {
      String userId = userController.getIdOfUsersFromShortId(shortIdOfUser);

      if (userId != "") {
        if (classUsersController.isAlreadyInClass(classId, userId)) {
          showToast("User is already in class!");
          return;
        }
        final documentUuid = invitationsDatabase.doc().id;
        Invitations invitation =
            Invitations(id: documentUuid, classId: classId, userId: userId);

        await invitationsDatabase.doc(documentUuid).set(invitation.toMap());
        showToast("Your request has been sent!");
        Navigator.pop(context);
      }
    } on FirebaseException {
      showToast("Error!");
    }
  }

  // Reject invitation
  Future<void> deleteInvitation(
      BuildContext context, String userId, String classId) async {
    try {
      String id = invitations
          .where((element) =>
              element.classId == classId && element.userId == userId)
          .first
          .id;
      await invitationsDatabase.doc(id).delete();
    } on FirebaseException {
      showToast("Error!");
    }
  }

  // Get the number of invitations of user
  int numberOfInvitationsOfUser(String userId) {
    try {
      return invitations.where((element) => element.userId == userId).length;
    } on FirebaseException {
      showToast("Error!");
      return 0;
    }
  }
}
