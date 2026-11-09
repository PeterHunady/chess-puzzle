// ignore_for_file: file_names, non_constant_identifier_names

// file: invitations_widget.dart
//
// author: Peter Huňady (xhunadp00)
//
// date: 2024

import 'package:chess/controller/classUser_controller.dart';
import 'package:chess/controller/class_controller.dart';
import 'package:chess/controller/invitation_controller.dart';
import 'package:chess/customWidgets/customRoundedIcon_widget.dart';
import 'package:chess/models/invitations_model.dart';
import 'package:chess/navigationAndToasts.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

// List of invitations for user
class InvitationsGrid extends StatelessWidget {
  final BuildContext context;
  final String userId;
  final InvitationsController invitationController;
  final ClassController classController;
  final ClassUsersController classUsersController;

  const InvitationsGrid(
      {super.key,
      required this.context,
      required this.userId,
      required this.invitationController,
      required this.classController,
      required this.classUsersController});

  final Color whiteColor = const Color.fromARGB(255, 235, 227, 208);
  final Color grayColor = const Color.fromARGB(255, 121, 121, 121);
  final Color blueColor = const Color.fromARGB(255, 52, 95, 178);
  final Color redColor = const Color.fromARGB(255, 178, 52, 52);

  @override
  Widget build(BuildContext context) {
    // Display all invitations
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
        children: invitationController.invitations
            .where((element) => element.userId == userId)
            .map((Invitations invitationsInfo) {
          return InvitationItem(invitationsInfo.classId);
        }).toList(),
      );
    });
  }

  Widget InvitationItem(String classId) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(10, 0, 20, 0),
          child: Image.asset(
            "assets/images/${classController.getCurrentClassIcon(classId).toLowerCase()}_black.png",
            width: 35,
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              classController.getCurrentClassName(classId),
              style: GoogleFonts.openSans(
                  fontSize: 14, color: whiteColor, fontWeight: FontWeight.w600),
            ),
            Text(
              classController.getCurrentClassShortId(classId),
              style: GoogleFonts.openSans(fontSize: 14, color: grayColor),
            ),
          ],
        ),
        Expanded(child: Container()),
        // Join a class
        GestureDetector(
          onTap: () {
            classUsersController.addUserToClass(
                context, classId, userId, invitationController);
          },
          child: CustomRoundedIcon(
            icon: Icon(
              FontAwesomeIcons.check,
              color: whiteColor,
              size: 12,
            ),
            colorOfBorder: blueColor,
            clickedPiece: false,
          ),
        ),
        // Reject invitation
        Padding(
          padding: const EdgeInsets.fromLTRB(15, 0, 10, 0),
          child: GestureDetector(
            onTap: () {
              showDialogWithoutContent(context, "Reject invitation?", "Reject",
                  () {
                invitationController.deleteInvitation(context, userId, classId);
                Navigator.pop(context);
              }, redColor);
            },
            child: CustomRoundedIcon(
              icon: Icon(
                FontAwesomeIcons.x,
                color: whiteColor,
                size: 12,
              ),
              colorOfBorder: redColor,
              clickedPiece: false,
            ),
          ),
        ),
      ],
    );
  }
}
