// ignore_for_file: file_names, use_build_context_synchronously

// file: pendingInvitation_controller.dart
//
// author: Peter Huňady (xhunadp00)
//
// date: 2024

import 'package:chess/navigationAndToasts.dart';
import 'package:chess/controller/classUser_controller.dart';
import 'package:chess/controller/class_controller.dart';
import 'package:chess/models/invitations_model.dart';
import 'package:chess/models/pendingInvitations_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Controller for pending invitations from users to classes
class PendingInvitationsController extends GetxController {
  final pendingInvitationsDatabase =
      FirebaseFirestore.instance.collection('pendingInvitations');
  final pendingInvitations = <PendingInvitations>[].obs;
  final ClassController classController = Get.put(ClassController());

  // Function to fetch all data as a stream.
  Stream<List<PendingInvitations>> getAllPendingInvitations() {
    return pendingInvitationsDatabase.snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => PendingInvitations.fromSnapshot(doc))
          .toList();
    });
  }

  @override
  void onInit() {
    pendingInvitations.bindStream(getAllPendingInvitations());
    super.onInit();
  }

  // Create an invitation to be sent to the class.
  Future<void> createPendingInvitation(BuildContext context, String userId,
      String classShortId, ClassUsersController classUsersController) async {
    try {
      String classId = classController.getIdOfClassFromShortId(classShortId);

      if (classId != "") {
        if (classUsersController.isAlreadyInClass(classId, userId)) {
          showToast("You are already in this class!");
          return;
        }

        final documentUuid = pendingInvitationsDatabase.doc().id;
        Invitations invitation =
            Invitations(id: documentUuid, classId: classId, userId: userId);

        await pendingInvitationsDatabase
            .doc(documentUuid)
            .set(invitation.toMap());
        showToast("Your request has been sent!");
        Navigator.pop(context);
      }
    } on FirebaseException {
      showToast("Error!");
    }
  }

  // Delete pending invitation (as teacher)
  Future<void> deletePendingInvitation(
      BuildContext context, String userId, String classId) async {
    try {
      String id = pendingInvitations
          .where((element) =>
              element.classId == classId && element.userId == userId)
          .first
          .id;
      await pendingInvitationsDatabase.doc(id).delete();
      Navigator.pop(context);
    } on FirebaseException {
      showToast("Error!");
    }
  }

  // Get the number of pending invitations for class
  int numberOfPendingInvitationsOfClass(String classId) {
    try {
      return pendingInvitations
          .where((element) => element.classId == classId)
          .length;
    } on FirebaseException {
      showToast("Error!");
      return 0;
    }
  }
}
