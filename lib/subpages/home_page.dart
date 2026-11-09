// ignore_for_file: file_names, non_constant_identifier_names

// file: home_page.dart
//
// author: Peter Huňady (xhunadp00)
//
// date: 2024

import 'package:chess/controller/classUser_controller.dart';
import 'package:chess/controller/class_controller.dart';
import 'package:chess/controller/invitation_controller.dart';
import 'package:chess/controller/pendingInvitations_controller.dart';
import 'package:chess/controller/puzzle_controller.dart';
import 'package:chess/controller/userPuzzle_controller.dart';
import 'package:chess/controller/user_controller.dart';
import 'package:chess/customWidgets/customButton_widget.dart';
import 'package:chess/customWidgets/customDefaultNavbar_widget.dart';
import 'package:chess/customWidgets/customFooter_widget.dart';
import 'package:chess/customWidgets/customTextField_widget.dart';
import 'package:chess/navigationAndToasts.dart';
import 'package:chess/subpages/createClass_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Color whiteColor = const Color.fromARGB(255, 235, 227, 208);
  Color blueColor = const Color.fromARGB(255, 52, 95, 178);

  final ClassUsersController classUsersController =
      Get.put(ClassUsersController());
  final ClassController classController = Get.put(ClassController());
  final UserController userController = Get.put(UserController());
  final PuzzleController puzzleController = Get.put(PuzzleController());
  final UserPuzzleController userPuzzleController =
      Get.put(UserPuzzleController());
  final InvitationsController invitationsController =
      Get.put(InvitationsController());
  final PendingInvitationsController pendingInvitationsController =
      Get.put(PendingInvitationsController());

  late String userId = "";

  // Load user from memory to sign him in
  Future getUser() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    setState(() {
      userId = preferences.getString('userId') ?? '';
    });
  }

  @override
  void initState() {
    getUser();
    super.initState();
  }

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
                  function: () {},
                  visible: false,
                ),
                Expanded(child: Container()),
                // Navigate to the subpage for creating a new screen
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 70),
                    child: CustomContainer(
                        "Create Class",
                        20,
                        10,
                        GoogleFonts.openSans(fontSize: 18, color: whiteColor),
                        () => navigateScreen(
                            context,
                            CreateClassPage(
                              userId: userId,
                            ))),
                  ),
                ),
                // Main title
                Padding(
                  padding: const EdgeInsets.fromLTRB(50, 0, 50, 0),
                  child: CustomContainer(
                      "Welcome to ChessUp",
                      0,
                      25,
                      GoogleFonts.cormorant(
                        fontSize: 48,
                        color: whiteColor,
                      ),
                      () => ()),
                ),
                // Button - action to join a class with class short id
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 70),
                    child: CustomContainer(
                        "Join Class",
                        20,
                        10,
                        GoogleFonts.openSans(fontSize: 18, color: whiteColor),
                        () => showCustomDialog(
                            context, "", joinClassDialogColumn())),
                  ),
                ),
                Expanded(child: Container()),
                Expanded(child: Container()),
                CustomFooter(
                  userId: userId,
                )
              ],
            ),
          ),
        ));
  }

  // Custom boxes with text
  Widget CustomContainer(String text, double horizontalPadding,
      double verticalPadding, TextStyle font, VoidCallback function) {
    return GestureDetector(
      onTap: function,
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(color: whiteColor, width: 1),
            borderRadius: const BorderRadius.all(Radius.circular(4))),
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: horizontalPadding, vertical: verticalPadding),
          child: Text(
            textAlign: TextAlign.center,
            text,
            style: font,
          ),
        ),
      ),
    );
  }

  // Dialog with input fields
  Column joinClassDialogColumn() {
    TextEditingController nameController = TextEditingController();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Class short id input field
        CustomTextField(
          text: "Enter Class ID",
          labelText: "#xxxxxx",
          controller: nameController,
          left: 10,
          top: 10,
          right: 10,
          bottom: 10,
          isPassword: false,
        ),
        // Button - action to join a class
        CustomButton(
            paddingHorizontal: 10,
            paddingVertical: 20,
            backgroundColorOfBtn: blueColor,
            borderColorOfBtn: Colors.transparent,
            textOfBtn: "Join",
            function: () {
              pendingInvitationsController.createPendingInvitation(
                  context, userId, nameController.text, classUsersController);
            })
      ],
    );
  }
}
