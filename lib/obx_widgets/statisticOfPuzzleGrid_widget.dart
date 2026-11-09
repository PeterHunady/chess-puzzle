// ignore_for_file: file_names, non_constant_identifier_names

// file: statisticsOfPuzzleGrid_widget.dart
//
// author: Peter Huňady (xhunadp00)
//
// date: 2024

import 'package:chess/controller/classUser_controller.dart';
import 'package:chess/controller/class_controller.dart';
import 'package:chess/controller/userPuzzle_controller.dart';
import 'package:chess/controller/user_controller.dart';
import 'package:chess/models/classUser_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

// List of statistics of each puzzle in the class
class StatisticsOfPuzzleGrid extends StatelessWidget {
  final BuildContext context;
  final String classId;
  final String puzzleId;
  final UserPuzzleController userPuzzleController;
  final ClassController classController;
  final ClassUsersController classUsersController;
  final UserController userController;

  const StatisticsOfPuzzleGrid(
      {super.key,
      required this.context,
      required this.puzzleId,
      required this.classId,
      required this.userPuzzleController,
      required this.classController,
      required this.classUsersController,
      required this.userController});

  final Color whiteColor = const Color.fromARGB(255, 235, 227, 208);
  final Color grayColor = const Color.fromARGB(255, 121, 121, 121);
  final Color blueColor = const Color.fromARGB(255, 52, 95, 178);
  final Color redColor = const Color.fromARGB(255, 178, 52, 52);

  @override
  Widget build(BuildContext context) {
    // Display statistics of puzzles
    return Obx(() {
      return GridView.count(
        crossAxisCount: 1,
        childAspectRatio: 8,
        scrollDirection: Axis.vertical,
        padding: const EdgeInsets.all(0),
        mainAxisSpacing: 5,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisSpacing: 0,
        shrinkWrap: true,
        children: classUsersController.classUsers
            .where((element) => element.classId == classId)
            .map((ClassUsers classUsersInfo) {
          return StatisticsItem(classUsersInfo.userId);
        }).toList(),
      );
    });
  }

  // One item (statistic of puzzle) in list
  Widget StatisticsItem(String userId) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 3,
              child: Text(
                userController.getCurrentUserName(userId),
                style: GoogleFonts.openSans(
                    fontSize: 14,
                    color: whiteColor,
                    fontWeight: FontWeight.w400),
                textAlign: TextAlign.left,
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                userPuzzleController.getSolved(puzzleId, userId) ? "Yes" : "No",
                style: GoogleFonts.openSans(
                    fontSize: 14,
                    color: whiteColor,
                    fontWeight: FontWeight.w400),
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                userPuzzleController
                    .getAttemptsOfUserPuzzle(puzzleId, userId)
                    .toString(),
                style: GoogleFonts.openSans(
                    fontSize: 14,
                    color: whiteColor,
                    fontWeight: FontWeight.w400),
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                userPuzzleController.getTimeOfUser(puzzleId, userId),
                style: GoogleFonts.openSans(
                    fontSize: 14,
                    color: whiteColor,
                    fontWeight: FontWeight.w400),
                textAlign: TextAlign.right,
              ),
            ),
          ],
        ),
        const Expanded(
          child: Divider(
            color: Color.fromARGB(255, 235, 227, 208),
            thickness: 1,
          ),
        ),
      ],
    );
  }
}
