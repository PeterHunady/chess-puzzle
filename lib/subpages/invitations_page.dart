// ignore_for_file: non_constant_identifier_names

// file: invitations_page.dart
//
// author: Peter Huňady (xhunadp00)
//
// date: 2024

import 'package:chess/controller/classUser_controller.dart';
import 'package:chess/controller/class_controller.dart';
import 'package:chess/controller/invitation_controller.dart';
import 'package:chess/controller/user_controller.dart';
import 'package:chess/customWidgets/customDefaultNavbar_widget.dart';
import 'package:chess/customWidgets/customFooter_widget.dart';
import 'package:chess/navigationAndToasts.dart';
import 'package:chess/obx_widgets/invitations_widget.dart';
import 'package:chess/subpages/menu_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

// Subpage of class invitations.
class InvitationsPage extends StatefulWidget {
  final String userId;
  const InvitationsPage({super.key, required this.userId});

  @override
  State<InvitationsPage> createState() => _InvitationsPageState();
}

class _InvitationsPageState extends State<InvitationsPage> {
  final UserController userController = Get.put(UserController());
  final ClassController classController = Get.put(ClassController());
  final ClassUsersController classUserController =
      Get.put(ClassUsersController());
  final InvitationsController invitationController =
      Get.put(InvitationsController());

  @override
  void initState() {
    super.initState();
  }

  final Color whiteColor = const Color.fromARGB(255, 235, 227, 208);
  final Color grayColor = const Color.fromARGB(255, 121, 121, 121);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: true,
      left: false,
      right: false,
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            color: Colors.black,
          ),
          child: Column(
            children: [
              CustomDefaultNavbar(
                  function: () {
                    navigateScreenWithoutBackNavigation(
                        context, const MenuPage());
                  },
                  visible: true),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Column(
                    children: [
                      if (invitationController
                              .numberOfInvitationsOfUser(widget.userId) !=
                          0) ...[
                        // Title
                        Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: Text(
                            "Invitations",
                            style: GoogleFonts.openSans(
                                fontSize: 24,
                                color: whiteColor,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        // List of all class invitations
                        Padding(
                          padding: const EdgeInsets.only(top: 30),
                          child: InvitationsGrid(
                            context: context,
                            userId: widget.userId,
                            invitationController: invitationController,
                            classController: classController,
                            classUsersController: classUserController,
                          ),
                        )
                      ] else ...[
                        Expanded(child: Container()),
                        // Visible if an user have no invitations
                        Text(
                          "You have no invitations!",
                          style: GoogleFonts.openSans(
                              fontSize: 24,
                              color: grayColor,
                              fontWeight: FontWeight.w600),
                        ),
                        Expanded(child: Container()),
                      ]
                    ],
                  ),
                ),
              ),
              CustomFooter(
                userId: widget.userId,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
