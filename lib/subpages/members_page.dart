// ignore_for_file: file_names, non_constant_identifier_names

// file: members_page.dart
//
// author: Peter Huňady (xhunadp00)
//
// date: 2024

import 'package:chess/controller/classUser_controller.dart';
import 'package:chess/controller/class_controller.dart';
import 'package:chess/controller/puzzle_controller.dart';
import 'package:chess/controller/userPuzzle_controller.dart';
import 'package:chess/controller/user_controller.dart';
import 'package:chess/customWidgets/customClassNavbar_widget.dart';
import 'package:chess/customWidgets/customFooter_widget.dart';
import 'package:chess/customWidgets/customTextField_widget.dart';
import 'package:chess/navigationAndToasts.dart';
import 'package:chess/obx_widgets/membersGrid_widget.dart';
import 'package:chess/subpages/classHome_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:remove_diacritic/remove_diacritic.dart';

// Subpage with list of all students in the class
class MembersPage extends StatefulWidget {
  final String userId;
  final String classId;
  final bool isTeacher;
  const MembersPage(
      {super.key,
      required this.userId,
      required this.classId,
      required this.isTeacher});

  @override
  State<MembersPage> createState() => _MembersPageState();
}

class _MembersPageState extends State<MembersPage> {
  Color whiteColor = const Color.fromARGB(255, 235, 227, 208);
  Color blueColor = const Color.fromARGB(255, 52, 95, 178);
  Color redColor = const Color.fromARGB(255, 178, 52, 52);
  Color grayColor = const Color.fromARGB(255, 121, 121, 121);

  final ClassController classController = Get.put(ClassController());
  final ClassUsersController classUserController =
      Get.put(ClassUsersController());
  final UserController userController = Get.put(UserController());
  final UserPuzzleController userPuzzleController =
      Get.put(UserPuzzleController());
  final PuzzleController puzzleController = Get.put(PuzzleController());

  final TextEditingController searchMemberTextController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  String name = "";

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
              // Navbar widget with class icon, short id and name
              CustomClassNavbar(
                nameOfClass:
                    classController.getCurrentClassName(widget.classId),
                idOfClass:
                    classController.getCurrentClassShortId(widget.classId),
                iconPieceName:
                    classController.getCurrentClassIcon(widget.classId),
                visible: true,
                function: () {
                  navigateScreenWithoutBackNavigation(
                      context,
                      ClassHomePage(
                          userId: widget.userId, isTeacher: widget.isTeacher));
                },
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 10, top: 20, bottom: 20),
                        child: Text(
                          "Members",
                          style: GoogleFonts.openSans(
                              fontSize: 20,
                              color: whiteColor,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                      // Search bar for searching an user in the class.
                      CustomTextField(
                        text: "Enter Name",
                        labelText: "User name",
                        controller: searchMemberTextController,
                        left: 10,
                        top: 20,
                        right: 10,
                        bottom: 20,
                        isPassword: false,
                        onChanged: (val) {
                          setState(() {
                            name = removeDiacritics(val);
                          });
                        },
                      ),
                      // List of all students in the class
                      MembersGrid(
                        context: context,
                        classId: widget.classId,
                        currentUserId: widget.userId,
                        classController: classController,
                        classUsersController: classUserController,
                        userController: userController,
                        name: name,
                      )
                    ],
                  ),
                ),
              ),
              CustomFooter(
                userId: widget.userId,
              )
            ],
          ),
        ),
      ),
    );
  }
}
