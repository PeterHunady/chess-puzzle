// ignore_for_file: file_names, non_constant_identifier_names

// file: puzzleGrid_widget.dart
//
// author: Peter Huňady (xhunadp00)
//
// date: 2024

import 'package:chess/controller/classUser_controller.dart';
import 'package:chess/controller/class_controller.dart';
import 'package:chess/controller/puzzle_controller.dart';
import 'package:chess/controller/userPuzzle_controller.dart';
import 'package:chess/customWidgets/customPuzzlePreviewCard_widget.dart';
import 'package:chess/models/puzzle_model.dart';
import 'package:chess/navigationAndToasts.dart';
import 'package:chess/subpages/puzzle_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

// List of all puzzles in the class
class PuzzlesGrid extends StatelessWidget {
  final String currentClassId;
  final ClassController classController;
  final UserPuzzleController userPuzzleController;
  final PuzzleController puzzleController;
  final String nameOfClass;
  final String iconOfClass;
  final String shortIdOfClass;
  final String classId;
  final String userId;
  final int numberOfPuzzlesToShow;

  const PuzzlesGrid(
      {super.key,
      required this.currentClassId,
      required this.classController,
      required this.userPuzzleController,
      required this.puzzleController,
      required this.nameOfClass,
      required this.iconOfClass,
      required this.shortIdOfClass,
      required this.classId,
      required this.userId,
      required this.numberOfPuzzlesToShow});

  final Color whiteColor = const Color.fromARGB(255, 235, 227, 208);
  final Color grayColor = const Color.fromARGB(255, 121, 121, 121);

  @override
  Widget build(BuildContext context) {
    final UserPuzzleController userPuzzleController =
        Get.put(UserPuzzleController());
    final ClassUsersController classUsersController =
        Get.put(ClassUsersController());

    // Display all puzzles
    return Obx(() {
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
            .where((element) => element.classId == currentClassId)
            .take(numberOfPuzzlesToShow)
            .map((Puzzles puzzleInfo) {
          return CustomPuzzlePreviewCard(
            puzzleTitle: puzzleInfo.puzzleName,
            imageUrl: puzzleInfo.imageUrl,
            solvedByUser: userPuzzleController.getSolved(puzzleInfo.id, userId),
            solvedBy:
                "${userPuzzleController.getNumberOfSolved(puzzleInfo.id)}/${classUsersController.getNumberOfUsers(classId)}",
            averageTime: userPuzzleController.getAverageTime(puzzleInfo.id),
            averageAttempts: userPuzzleController
                .getAverageAttempts(puzzleInfo.id)
                .toString(),
            // Navigate to puzzle page
            function: () => navigateScreen(
                context,
                PuzzlePage(
                    isTeacher: classUsersController.getCurrentUserRole(
                        userId, classId),
                    userId: userId,
                    classId: classId,
                    puzzleName: puzzleInfo.puzzleName,
                    imageUrl: puzzleInfo.imageUrl,
                    id: puzzleInfo.id)),
          );
        }).toList(),
      );
    });
  }
}
