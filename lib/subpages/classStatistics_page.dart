// ignore_for_file: file_names, non_constant_identifier_names

// file: classStatistics_page.dart
//
// author: Peter Huňady (xhunadp00)
//
// date: 2024

import 'package:chess/controller/classUser_controller.dart';
import 'package:chess/controller/class_controller.dart';
import 'package:chess/controller/puzzle_controller.dart';
import 'package:chess/controller/user_controller.dart';
import 'package:chess/customWidgets/customBoxWithText_widget.dart';
import 'package:chess/customWidgets/customClassNavbar_widget.dart';
import 'package:chess/customWidgets/customFooter_widget.dart';
import 'package:chess/navigationAndToasts.dart';
import 'package:chess/obx_widgets/statisticsGrid_widget.dart';
import 'package:chess/subpages/classHome_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

// Subpage of class stastistics
class ClassStatisticsPage extends StatefulWidget {
  final String userId;
  final String classId;
  final bool isTeacher;
  const ClassStatisticsPage(
      {super.key,
      required this.userId,
      required this.classId,
      required this.isTeacher});

  @override
  State<ClassStatisticsPage> createState() => _ClassStatisticsPageState();
}

class _ClassStatisticsPageState extends State<ClassStatisticsPage> {
  Color whiteColor = const Color.fromARGB(255, 235, 227, 208);
  Color blueColor = const Color.fromARGB(255, 52, 95, 178);
  Color redColor = const Color.fromARGB(255, 178, 52, 52);
  Color grayColor = const Color.fromARGB(255, 121, 121, 121);

  final ClassController classController = Get.put(ClassController());
  final ClassUsersController classUserController =
      Get.put(ClassUsersController());
  final UserController userController = Get.put(UserController());
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
                          ClassHomePage(
                              userId: widget.userId,
                              isTeacher: widget.isTeacher));
                    },
                  ),
                  Expanded(
                      child: SingleChildScrollView(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                        Padding(
                            padding: const EdgeInsets.only(
                                left: 10, top: 20, bottom: 10),
                            child: Text("Puzzle Statistics",
                                style: GoogleFonts.openSans(
                                    fontSize: 20,
                                    color: whiteColor,
                                    fontWeight: FontWeight.w400))),
                        // Puzzle statistics of class
                        Row(children: [
                          SizedBox(
                              width: MediaQuery.sizeOf(context).width / 2,
                              child: CustomBoxWithText(
                                  topText: "Average completed",
                                  bottomText: puzzleController
                                      .getAverageCompletedForClass(
                                          widget.classId))),
                          SizedBox(
                              width: MediaQuery.sizeOf(context).width / 2,
                              child: CustomBoxWithText(
                                topText: "Average time",
                                bottomText: puzzleController
                                    .getAverageTimeForClass(widget.classId),
                              ))
                        ]),
                        Row(children: [
                          SizedBox(
                              width: MediaQuery.sizeOf(context).width / 2,
                              child: CustomBoxWithText(
                                  topText: "Average attempts",
                                  bottomText: puzzleController
                                      .getAverageAttemptsForClass(
                                          widget.classId))),
                          SizedBox(
                              width: MediaQuery.sizeOf(context).width / 2,
                              child: CustomBoxWithText(
                                  topText: "Puzzles created",
                                  bottomText: puzzleController
                                      .numberOfPuzzlesOfClass(widget.classId)
                                      .toString()))
                        ]),

                        Padding(
                            padding: const EdgeInsets.only(
                                left: 10, top: 30, bottom: 20),
                            child: Text(
                              "Users Statistics",
                              style: GoogleFonts.openSans(
                                  fontSize: 20,
                                  color: whiteColor,
                                  fontWeight: FontWeight.w400),
                            )),
                        // Column names of the table
                        Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Stats()),
                        // Statistics of each student in the class
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 20),
                          child: StatisticsGrid(
                              context: context,
                              classId: widget.classId,
                              puzzleController: puzzleController,
                              classController: classController,
                              classUsersController: classUserController,
                              userController: userController),
                        )
                      ]))),
                  CustomFooter(
                    userId: widget.userId,
                  )
                ]))));
  }

  // Column names of the table
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
            "Avg. tries",
            style: GoogleFonts.openSans(
                fontSize: 14, color: grayColor, fontWeight: FontWeight.w400),
            textAlign: TextAlign.center,
          ),
        ),
        Expanded(
          flex: 2,
          child: Text(
            "Avg. time",
            style: GoogleFonts.openSans(
                fontSize: 14, color: grayColor, fontWeight: FontWeight.w400),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }
}
