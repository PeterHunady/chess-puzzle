// ignore_for_file: file_names, non_constant_identifier_names

// file: memberPuzzleGrid_widget.dart
//
// author: Peter Huňady (xhunadp00)
//
// date: 2024

import 'package:chess/controller/class_controller.dart';
import 'package:chess/controller/puzzle_controller.dart';
import 'package:chess/controller/userPuzzle_controller.dart';
import 'package:chess/customWidgets/customPuzzlePreviewCard_widget.dart';
import 'package:chess/models/puzzle_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

// List of statistics of every puzzle of the selected student
class MemberPuzzleGrid extends StatelessWidget {
  final ClassController classController;
  final UserPuzzleController userPuzzleController;
  final PuzzleController puzzleController;
  final String classId;
  final String userId;
  final int numberOfPuzzlesToShow;

  const MemberPuzzleGrid(
      {super.key,
      required this.classController,
      required this.userPuzzleController,
      required this.puzzleController,
      required this.classId,
      required this.userId,
      required this.numberOfPuzzlesToShow});

  final Color whiteColor = const Color.fromARGB(255, 235, 227, 208);
  final Color grayColor = const Color.fromARGB(255, 121, 121, 121);

  @override
  Widget build(BuildContext context) {
    final UserPuzzleController userPuzzleController =
        Get.put(UserPuzzleController());

    return Obx(() {
      // Display statistics of every puzzle of the selected student
      return GridView.count(
        crossAxisCount: 1,
        childAspectRatio: 1.5,
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        padding: const EdgeInsets.only(top: 0),
        mainAxisSpacing: 0,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisSpacing: 0,
        children: puzzleController.puzzles
            .where((element) => element.classId == classId)
            .take(numberOfPuzzlesToShow)
            .map((Puzzles puzzleInfo) {
          return CustomPuzzlePreviewCard(
            puzzleTitle: puzzleInfo.puzzleName,
            imageUrl: puzzleInfo.imageUrl,
            solvedByUser: userPuzzleController.getSolved(puzzleInfo.id, userId),
            solvedBy: userPuzzleController.getSolved(puzzleInfo.id, userId)
                ? "Yes"
                : "No",
            averageTime:
                userPuzzleController.getTimeOfUser(puzzleInfo.id, userId),
            averageAttempts: userPuzzleController
                .getAttemptsOfUserPuzzle(puzzleInfo.id, userId)
                .toString(),
            function: () => (),
            text1Box: "Solved",
            text2Box: "Time",
            text3Box: "Attempts",
          );
        }).toList(),
      );
    });
  }
}
