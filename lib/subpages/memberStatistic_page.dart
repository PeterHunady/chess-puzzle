// ignore_for_file: file_names, non_constant_identifier_names

// file: memberStatistics_page.dart
//
// author: Peter Huňady (xhunadp00)
//
// date: 2024

import 'package:chess/controller/classUser_controller.dart';
import 'package:chess/controller/class_controller.dart';
import 'package:chess/controller/puzzle_controller.dart';
import 'package:chess/controller/userPuzzle_controller.dart';
import 'package:chess/controller/user_controller.dart';
import 'package:chess/customWidgets/customBoxWithText_widget.dart';
import 'package:chess/customWidgets/customClassNavbar_widget.dart';
import 'package:chess/customWidgets/customFooter_widget.dart';
import 'package:chess/navigationAndToasts.dart';
import 'package:chess/obx_widgets/memberPuzzleGrid_widget.dart';
import 'package:chess/subpages/members_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

// Subpage showing statistics of student in the class
class MemberStatisticsPage extends StatefulWidget {
  final String currentUserId;
  final String userId;
  final String classId;
  final bool isTeacher;
  const MemberStatisticsPage(
      {super.key,
      required this.currentUserId,
      required this.userId,
      required this.classId,
      required this.isTeacher});

  @override
  State<MemberStatisticsPage> createState() => _MemberStatisticsPageState();
}

class _MemberStatisticsPageState extends State<MemberStatisticsPage> {
  Color whiteColor = const Color.fromARGB(255, 235, 227, 208);
  Color blueColor = const Color.fromARGB(255, 52, 95, 178);
  Color redColor = const Color.fromARGB(255, 178, 52, 52);
  Color grayColor = const Color.fromARGB(255, 121, 121, 121);

  final ClassController classController = Get.put(ClassController());
  final ClassUsersController classUserController =
      Get.put(ClassUsersController());
  final UserController userController = Get.put(UserController());
  final PuzzleController puzzleController = Get.put(PuzzleController());
  final UserPuzzleController userPuzzleController =
      Get.put(UserPuzzleController());

  @override
  void initState() {
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
                child: Column(children: [
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
                          MembersPage(
                              userId: widget.currentUserId,
                              classId: widget.classId,
                              isTeacher: widget.isTeacher));
                    },
                  ),
                  Expanded(
                      child: SingleChildScrollView(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Name of the selected user
                          Padding(
                              padding: const EdgeInsets.only(
                                  left: 10, top: 20, bottom: 10),
                              child: Center(
                                child: Text(
                                    userController
                                        .getCurrentUserName(widget.userId),
                                    style: GoogleFonts.openSans(
                                        fontSize: 26,
                                        color: whiteColor,
                                        fontWeight: FontWeight.w400)),
                              )),
                          // Role of the selected student
                          Padding(
                              padding: const EdgeInsets.only(
                                  left: 10, top: 0, bottom: 10),
                              child: Center(
                                child: Text(
                                    classUserController.getCurrentUserRole(
                                            widget.userId, widget.classId)
                                        ? "Teacher"
                                        : "Student",
                                    style: GoogleFonts.openSans(
                                        fontSize: 20,
                                        color: whiteColor,
                                        fontWeight: FontWeight.w400)),
                              )),
                          // Summary of all puzzles of the selected student
                          Padding(
                              padding: const EdgeInsets.only(
                                  left: 10, top: 20, bottom: 10),
                              child: Text("Member Statistics",
                                  style: GoogleFonts.openSans(
                                      fontSize: 20,
                                      color: whiteColor,
                                      fontWeight: FontWeight.w400))),
                          Row(children: [
                            SizedBox(
                                width: MediaQuery.sizeOf(context).width / 2,
                                child: CustomBoxWithText(
                                    topText: "Completed",
                                    bottomText: puzzleController
                                        .getCompletedPuzzlesForUserInClass(
                                            widget.userId, widget.classId))),
                            SizedBox(
                                width: MediaQuery.sizeOf(context).width / 2,
                                child: CustomBoxWithText(
                                  topText: "Average time",
                                  bottomText:
                                      puzzleController.getAverageTimeForUser(
                                          widget.classId, widget.userId),
                                ))
                          ]),
                          CustomBoxWithText(
                              topText: "Average attempts",
                              bottomText:
                                  puzzleController.getAverageAttemptsForUser(
                                      widget.classId, widget.userId)),
                          Padding(
                            padding: const EdgeInsets.only(left: 10, top: 20),
                            child: Text("Puzzles",
                                style: GoogleFonts.openSans(
                                    fontSize: 20,
                                    color: whiteColor,
                                    fontWeight: FontWeight.w400)),
                          ),
                          // Statistics of every puzzle of the selected student
                          MemberPuzzleGrid(
                              classController: classController,
                              userPuzzleController: userPuzzleController,
                              puzzleController: puzzleController,
                              classId: widget.classId,
                              userId: widget.userId,
                              numberOfPuzzlesToShow: 1000)
                        ]),
                  )),
                  CustomFooter(
                    userId: widget.userId,
                  )
                ]))));
  }
}
