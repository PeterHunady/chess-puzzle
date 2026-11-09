// ignore_for_file: file_names, non_constant_identifier_names

// file: allPuzzles_page.dart
//
// author: Peter Huňady (xkaletk00)
//
// date: 2024

import 'package:chess/controller/classUser_controller.dart';
import 'package:chess/controller/class_controller.dart';
import 'package:chess/controller/puzzle_controller.dart';
import 'package:chess/controller/userPuzzle_controller.dart';
import 'package:chess/controller/user_controller.dart';
import 'package:chess/customWidgets/customClassNavbar_widget.dart';
import 'package:chess/customWidgets/customFooter_widget.dart';
import 'package:chess/navigationAndToasts.dart';
import 'package:chess/obx_widgets/puzzleGrid_widget.dart';
import 'package:chess/subpages/classHome_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

// Subpage of all created puzzles in class
class AllPuzzlesPage extends StatefulWidget {
  final String userId;
  final String classId;
  final bool isTeacher;
  const AllPuzzlesPage(
      {super.key,
      required this.userId,
      required this.classId,
      required this.isTeacher});

  @override
  State<AllPuzzlesPage> createState() => _AllPuzzlesPageState();
}

class _AllPuzzlesPageState extends State<AllPuzzlesPage> {
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
                      // List of all puzzles in the class
                      Obx(() {
                        if (puzzleController
                                .numberOfPuzzlesOfClass(widget.classId) >
                            0) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: PuzzlesGrid(
                              currentClassId: widget.classId,
                              classController: classController,
                              puzzleController: puzzleController,
                              classId: widget.classId,
                              nameOfClass: classController
                                  .getCurrentClassName(widget.classId),
                              shortIdOfClass: classController
                                  .getCurrentClassShortId(widget.classId),
                              iconOfClass: classController
                                  .getCurrentClassIcon(widget.classId),
                              userId: widget.userId,
                              userPuzzleController: userPuzzleController,
                              numberOfPuzzlesToShow: 1000,
                            ),
                          );
                        } else {
                          return Center(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 20.0),
                              child: Align(
                                alignment: Alignment.center,
                                child: Text(
                                  "There are no puzzles in the class yet",
                                  style: GoogleFonts.openSans(
                                      fontSize: 16,
                                      color: grayColor,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            ),
                          );
                        }
                      })
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
