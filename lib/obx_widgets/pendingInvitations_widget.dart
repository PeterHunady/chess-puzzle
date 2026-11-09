// ignore_for_file: file_names, non_constant_identifier_names

// file: pendingInvitations_widget.dart
//
// author: Peter Huňady (xhunadp00)
//
// date: 2024

import 'package:chess/controller/classUser_controller.dart';
import 'package:chess/controller/class_controller.dart';
import 'package:chess/controller/pendingInvitations_controller.dart';
import 'package:chess/controller/user_controller.dart';
import 'package:chess/customWidgets/customIconWithText_widget.dart';
import 'package:chess/models/pendingInvitations_model.dart';
import 'package:chess/navigationAndToasts.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

// List of all pending invitations for class
class PendingInvitationsGrid extends StatelessWidget {
  final BuildContext context;
  final String classId;
  final PendingInvitationsController pendingInvitationController;
  final ClassController classController;
  final ClassUsersController classUsersController;
  final UserController userController;

  const PendingInvitationsGrid(
      {super.key,
      required this.context,
      required this.classId,
      required this.pendingInvitationController,
      required this.classController,
      required this.classUsersController,
      required this.userController});

  final Color whiteColor = const Color.fromARGB(255, 235, 227, 208);
  final Color grayColor = const Color.fromARGB(255, 121, 121, 121);
  final Color blueColor = const Color.fromARGB(255, 52, 95, 178);
  final Color redColor = const Color.fromARGB(255, 178, 52, 52);

  @override
  Widget build(BuildContext context) {
    // Display all invitations
    if (pendingInvitationController
            .numberOfPendingInvitationsOfClass(classId) !=
        0) {
      return Obx(() {
        return GridView.count(
          crossAxisCount: 1,
          childAspectRatio: 8,
          scrollDirection: Axis.vertical,
          padding: const EdgeInsets.all(0),
          mainAxisSpacing: 20,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 0,
          shrinkWrap: true,
          children: pendingInvitationController.pendingInvitations
              .where((element) => element.classId == classId)
              .map((PendingInvitations pendingInvitationsInfo) {
            return PendingInvitationItem(pendingInvitationsInfo.userId);
          }).toList(),
        );
      });
    } else {
      return Text(
        "No pending invitations",
        style: GoogleFonts.openSans(
            fontSize: 16, color: grayColor, fontWeight: FontWeight.w600),
      );
    }
  }

  // One item (pending invitation) in list
  Widget PendingInvitationItem(String userId) {
    return CustomRoundedIconWithText(
      text: userController.getCurrentUserName(userId),
      smallText: userController.getCurrentUserShortId(userId),
      mainIcon: Icon(
        Icons.person_2_outlined,
        color: whiteColor,
        size: 30,
      ),
      sizeOfText: 18,
      sizeOfIcon: 14,
      firstIcon: Icon(
        FontAwesomeIcons.check,
        color: whiteColor,
        size: 12,
      ),
      firstIconBorderColor: blueColor,
      secondIcon: Icon(
        FontAwesomeIcons.x,
        color: whiteColor,
        size: 12,
      ),
      secondIconBorderColor: redColor,
      // Join the class
      function1: () {
        classUsersController.confirmUserToClass(
            context, classId, userId, pendingInvitationController);
      },
      function2: () {
        // Reject invitation
        showDialogWithoutContent(context, "Reject user?", "Reject", () {
          pendingInvitationController.deletePendingInvitation(
              context, userId, classId);
        }, redColor);
      },
    );
  }
}
