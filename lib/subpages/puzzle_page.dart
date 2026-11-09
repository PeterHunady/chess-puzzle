// ignore_for_file: file_names, non_constant_identifier_names

// file: puzzle_page.dart
//
// author: Peter Huňady (xhunadp00)
//
// date: 2024

import 'package:chess/controller/classUser_controller.dart';
import 'package:chess/controller/class_controller.dart';
import 'package:chess/controller/puzzle_controller.dart';
import 'package:chess/controller/userPuzzle_controller.dart';
import 'package:chess/controller/user_controller.dart';
import 'package:chess/customWidgets/customButton_widget.dart';
import 'package:chess/customWidgets/customClassNavbar_widget.dart';
import 'package:chess/customWidgets/customFooter_widget.dart';
import 'package:chess/customWidgets/customPuzzlePreviewCard_widget.dart';
import 'package:chess/navigationAndToasts.dart';
import 'package:chess/obx_widgets/statisticOfPuzzleGrid_widget.dart';
import 'package:chess/subpages/classHome_page.dart';
import 'package:chess/subpages/playChessPuzzle_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

// Subpage to show puzzle statistics and statistics for each student.
class PuzzlePage extends StatefulWidget {
  final String userId;
  final String classId;
  final String puzzleName;
  final String imageUrl;
  final String id;
  final bool isTeacher;
  const PuzzlePage(
      {super.key,
      required this.userId,
      required this.classId,
      required this.puzzleName,
      required this.imageUrl,
      required this.id,
      required this.isTeacher});

  @override
  State<PuzzlePage> createState() => _PuzzlePageState();
}

class _PuzzlePageState extends State<PuzzlePage> {
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
                      // Widget with a preview image of the puzzle and its statistics.
                      CustomPuzzlePreviewCard(
                          puzzleTitle: widget.puzzleName,
                          imageUrl: widget.imageUrl,
                          solvedByUser: userPuzzleController.getSolved(
                              widget.id, widget.userId),
                          solvedBy:
                              "${userPuzzleController.getNumberOfSolved(widget.id)}/${classUserController.getNumberOfUsers(widget.classId)}",
                          averageTime:
                              userPuzzleController.getAverageTime(widget.id),
                          averageAttempts: userPuzzleController
                              .getAverageAttempts(widget.id)
                              .toString(),
                          function: () => ()),
                      // Button - navigate to play chess puzzle sub page
                      CustomButton(
                          paddingHorizontal: 10,
                          paddingVertical: 20,
                          backgroundColorOfBtn: blueColor,
                          borderColorOfBtn: Colors.transparent,
                          textOfBtn: "Play",
                          function: () => navigateScreenWithoutBackNavigation(
                              context,
                              PlayChessPuzzlePage(
                                nameOfClass: classController
                                    .getCurrentClassName(widget.classId),
                                iconOfClass: classController
                                    .getCurrentClassIcon(widget.classId),
                                shortIdOfClass: classController
                                    .getCurrentClassShortId(widget.classId),
                                classId: widget.classId,
                                puzzleId: widget.id,
                                userId: widget.userId,
                                puzzleName: widget.puzzleName,
                                imageUrl: widget.imageUrl,
                                isTeacher: widget.isTeacher,
                              ))),
                      // Button - action to delete puzzle, only visible for teachers
                      Visibility(
                        visible: widget.isTeacher,
                        child: CustomButton(
                            paddingHorizontal: 10,
                            paddingVertical: 0,
                            backgroundColorOfBtn: redColor,
                            borderColorOfBtn: Colors.transparent,
                            textOfBtn: "Delete",
                            function: () => showDialogWithoutContent(
                                context,
                                "Are you sure you want to delete this puzzle?",
                                "Delete",
                                () => setState(() {
                                      puzzleController.deletePuzzle(
                                          context,
                                          widget.id,
                                          widget.userId,
                                          widget.isTeacher);
                                    }),
                                redColor)),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 10, right: 10, top: 40),
                        child: Stats(),
                      ),
                      // Table of statistics of each student
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 20),
                        child: StatisticsOfPuzzleGrid(
                            context: context,
                            puzzleId: widget.id,
                            classId: widget.classId,
                            userPuzzleController: userPuzzleController,
                            classController: classController,
                            classUsersController: classUserController,
                            userController: userController),
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

  // Name of columns in table of students
  Widget Stats() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          flex: 3,
          child: Text(
            "Name",
            style: GoogleFonts.openSans(
                fontSize: 14, color: grayColor, fontWeight: FontWeight.w400),
            textAlign: TextAlign.left,
          ),
        ),
        Expanded(
          flex: 2,
          child: Text(
            "Solved",
            style: GoogleFonts.openSans(
                fontSize: 14, color: grayColor, fontWeight: FontWeight.w400),
            textAlign: TextAlign.center,
          ),
        ),
        Expanded(
          flex: 2,
          child: Text(
            "Attempts",
            style: GoogleFonts.openSans(
                fontSize: 14, color: grayColor, fontWeight: FontWeight.w400),
            textAlign: TextAlign.center,
          ),
        ),
        Expanded(
          flex: 2,
          child: Text(
            "Time",
            style: GoogleFonts.openSans(
                fontSize: 14, color: grayColor, fontWeight: FontWeight.w400),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }
}
