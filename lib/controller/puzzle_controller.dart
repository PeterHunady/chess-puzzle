// ignore_for_file: file_names, no_leading_underscores_for_local_identifiers, use_build_context_synchronously

// file: puzzle_controller.dart
//
// author: Peter Huňady (xhunadp00)
//
// date: 2024

import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:chess/navigationAndToasts.dart';
import 'package:chess/controller/classUser_controller.dart';
import 'package:chess/controller/userPuzzle_controller.dart';
import 'package:chess/models/puzzle_model.dart';
import 'package:chess/models/userPuzzle_model.dart';
import 'package:chess/subpages/classHome_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';

// Controller for puzzles
class PuzzleController extends GetxController {
  final puzzleDatabase = FirebaseFirestore.instance.collection('puzzles');
  final puzzles = <Puzzles>[].obs;

  // Function to fetch all data as a stream.
  Stream<List<Puzzles>> getAllPuzzles() {
    return puzzleDatabase.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => Puzzles.fromSnapshot(doc)).toList()
        ..sort((a, b) => b.id.compareTo(a.id));
    });
  }

  @override
  void onInit() {
    puzzles.bindStream(getAllPuzzles());
    super.onInit();
  }

  // Create a new puzzle
  Future<void> createPuzzle(
      String puzzleName,
      String classId,
      String startingPosition,
      String imageUrl,
      List puzzleMoves,
      List puzzleNotation) async {
    try {
      final documentUuid = DateTime.now().millisecondsSinceEpoch.toString();
      Puzzles puzzle = Puzzles(
          id: documentUuid,
          puzzleName: puzzleName,
          classId: classId,
          startingPosition: startingPosition,
          imageUrl: imageUrl,
          puzzleMoves: puzzleMoves,
          puzzleMoveNotation: puzzleNotation);

      await puzzleDatabase.doc(documentUuid).set(puzzle.toMap());
    } on FirebaseException {
      showToast("Error while creating class!");
    }
  }

  // Save starting position of the puzzle to database
  Future<void> captureAndSave(
      String puzzleName,
      String classId,
      String startingPosition,
      List puzzleMoves,
      GlobalKey _widgetKey,
      List puzzleNotation) async {
    try {
      RenderRepaintBoundary boundary = _widgetKey.currentContext!
          .findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 1.0);
      ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List pngBytes = byteData!.buffer.asUint8List();

      final directory = await getTemporaryDirectory();

      final file = File(
          '${directory.path}/${DateTime.now().millisecondsSinceEpoch.toString()}.png');

      await file.writeAsBytes(pngBytes);

      FirebaseStorage storage = FirebaseStorage.instance;
      TaskSnapshot uploadTask = await storage
          .ref('${DateTime.now().millisecondsSinceEpoch.toString()}.png')
          .putFile(file);

      String? imageUrl = await uploadTask.ref.getDownloadURL();

      createPuzzle(puzzleName, classId, startingPosition, imageUrl, puzzleMoves,
          puzzleNotation);
    } catch (e) {
      showToast("Something went wrong!");
    }
  }

  // Get FEN code of correct moves of the puzzle
  List getPuzzleCorrectMoves(String puzzleId) {
    try {
      return puzzles
          .where(
            (element) => element.id == puzzleId,
          )
          .first
          .puzzleMoves;
    } catch (e) {
      showToast("Error fetching correct moves.");
      return [];
    }
  }

  // Get all correct moves of the puzzle in algebraic notation
  List getPuzzleCorrectMoveNotation(String puzzleId) {
    try {
      return puzzles
          .where(
            (element) => element.id == puzzleId,
          )
          .first
          .puzzleMoveNotation;
    } catch (e) {
      showToast("Error fetching correct moves notation.");
      return [];
    }
  }

  // Get starting position of the puzzle
  String getStartingPosition(String puzzleId) {
    try {
      return puzzles
          .where(
            (element) => element.id == puzzleId,
          )
          .first
          .startingPosition;
    } catch (e) {
      showToast("Error fetching starting postion.");
      return "";
    }
  }

  // Get number of all puzzles in the class
  int numberOfPuzzlesOfClass(String classId) {
    try {
      return puzzles.where((element) => element.classId == classId).length;
    } on FirebaseException {
      showToast("Error!");
      return 0;
    }
  }

  // Get average attempts of solving puzzle for whole class
  String getAverageAttemptsForClass(String classId) {
    UserPuzzleController userPuzzleController = Get.put(UserPuzzleController());

    List<Puzzles> filteredPuzzles =
        puzzles.where((puzzle) => puzzle.classId == classId).toList();

    if (filteredPuzzles.isEmpty) return "0.00";

    int totalAttempts = 0;
    int puzzleCount = 0;

    for (var puzzle in filteredPuzzles) {
      List<UserPuzzles> puzzleStats = userPuzzleController.userPuzzles
          .where((userPuzzle) => userPuzzle.puzzleId == puzzle.id)
          .toList();

      if (puzzleStats.isNotEmpty) {
        for (var stat in puzzleStats) {
          totalAttempts += stat.attempts;
        }
        puzzleCount += puzzleStats.length;
      }
    }

    if (puzzleCount == 0) return "0.00";

    double avgAttempts = totalAttempts / puzzleCount;

    return avgAttempts.toStringAsFixed(2);
  }

  // Get average attempts of solving puzzle for user
  String getAverageAttemptsForUser(String classId, String userId) {
    UserPuzzleController userPuzzleController = Get.put(UserPuzzleController());

    List<Puzzles> filteredPuzzles =
        puzzles.where((puzzle) => puzzle.classId == classId).toList();

    if (filteredPuzzles.isEmpty) return "0.00";

    int totalAttempts = 0;
    int puzzleCount = 0;

    for (var puzzle in filteredPuzzles) {
      List<UserPuzzles> puzzleStats = userPuzzleController.userPuzzles
          .where((userPuzzle) =>
              userPuzzle.puzzleId == puzzle.id && userPuzzle.userId == userId)
          .toList();

      if (puzzleStats.isNotEmpty) {
        for (var stat in puzzleStats) {
          totalAttempts += stat.attempts;
        }
        puzzleCount += puzzleStats.length;
      }
    }

    if (puzzleCount == 0) return "0.00";

    double avgAttempts = totalAttempts / puzzleCount;

    return avgAttempts.toStringAsFixed(2);
  }

  // Get average time of solving puzzle for whole class
  String getAverageTimeForClass(String classId) {
    UserPuzzleController userPuzzleController = Get.put(UserPuzzleController());

    List<Puzzles> filteredPuzzles =
        puzzles.where((puzzle) => puzzle.classId == classId).toList();

    if (filteredPuzzles.isEmpty) return "00:00";

    int totalSeconds = 0;
    int puzzleCount = 0;

    for (var puzzle in filteredPuzzles) {
      List<UserPuzzles> puzzleStats = userPuzzleController.userPuzzles
          .where((userPuzzle) => userPuzzle.puzzleId == puzzle.id)
          .toList();

      if (puzzleStats.isNotEmpty) {
        for (var stat in puzzleStats) {
          List<String> timeParts = stat.time.split(":");
          int minutes = int.parse(timeParts[0]);
          int seconds = int.parse(timeParts[1]);

          totalSeconds += (minutes * 60) + seconds;
        }
        puzzleCount += puzzleStats.length;
      }
    }

    if (puzzleCount == 0) return "00:00";

    double avgSeconds = totalSeconds / puzzleCount;

    int avgMinutes = avgSeconds.floor() ~/ 60;
    int avgRemainingSeconds = avgSeconds.floor() % 60;

    String avgTime =
        "${avgMinutes.toString().padLeft(2, '0')}:${avgRemainingSeconds.toString().padLeft(2, '0')}";

    return avgTime;
  }

  // Get average time of solving puzzle for user
  String getAverageTimeForUser(String classId, String userId) {
    UserPuzzleController userPuzzleController = Get.put(UserPuzzleController());

    List<Puzzles> filteredPuzzles =
        puzzles.where((puzzle) => puzzle.classId == classId).toList();

    if (filteredPuzzles.isEmpty) return "00:00";

    int totalSeconds = 0;
    int puzzleCount = 0;

    for (var puzzle in filteredPuzzles) {
      List<UserPuzzles> puzzleStats = userPuzzleController.userPuzzles
          .where((userPuzzle) =>
              userPuzzle.puzzleId == puzzle.id && userPuzzle.userId == userId)
          .toList();

      if (puzzleStats.isNotEmpty) {
        for (var stat in puzzleStats) {
          List<String> timeParts = stat.time.split(":");
          int minutes = int.parse(timeParts[0]);
          int seconds = int.parse(timeParts[1]);

          totalSeconds += (minutes * 60) + seconds;
        }
        puzzleCount += puzzleStats.length;
      }
    }

    if (puzzleCount == 0) return "00:00";

    double avgSeconds = totalSeconds / puzzleCount;

    int avgMinutes = avgSeconds.floor() ~/ 60;
    int avgRemainingSeconds = avgSeconds.floor() % 60;

    String avgTime =
        "${avgMinutes.toString().padLeft(2, '0')}:${avgRemainingSeconds.toString().padLeft(2, '0')}";

    return avgTime;
  }

  // Get average completed puzzles for whole class
  String getAverageCompletedForClass(String classId) {
    UserPuzzleController userPuzzleController = Get.put(UserPuzzleController());
    ClassUsersController classUserController = Get.put(ClassUsersController());

    List<Puzzles> filteredPuzzles =
        puzzles.where((puzzle) => puzzle.classId == classId).toList();

    if (filteredPuzzles.isEmpty) {
      return "0/${classUserController.getNumberOfUsers(classId)}";
    }

    int totalCompleted = 0;

    for (var puzzle in filteredPuzzles) {
      List<UserPuzzles> puzzleStats = userPuzzleController.userPuzzles
          .where((userPuzzle) => userPuzzle.puzzleId == puzzle.id)
          .toList();

      if (puzzleStats.isNotEmpty) {
        for (var stat in puzzleStats) {
          if (stat.solved) {
            totalCompleted++;
          }
        }
      }
    }

    if (totalCompleted == 0) return "0/${numberOfPuzzlesOfClass(classId)}";

    double avgCompleted = totalCompleted / filteredPuzzles.length;

    return "${avgCompleted.toStringAsFixed(1)}/${classUserController.getNumberOfUsers(classId)}";
  }

  // Get average completed puzzles for user
  String getAverageCompletedForUser(String classId, String userId) {
    UserPuzzleController userPuzzleController = Get.put(UserPuzzleController());

    List<Puzzles> filteredPuzzles =
        puzzles.where((puzzle) => puzzle.classId == classId).toList();

    if (filteredPuzzles.isEmpty) return "0/${numberOfPuzzlesOfClass(classId)}";

    int totalCompleted = 0;

    for (var puzzle in filteredPuzzles) {
      List<UserPuzzles> puzzleStats = userPuzzleController.userPuzzles
          .where((userPuzzle) =>
              userPuzzle.puzzleId == puzzle.id && userPuzzle.userId == userId)
          .toList();

      if (puzzleStats.isNotEmpty) {
        for (var stat in puzzleStats) {
          if (stat.solved) {
            totalCompleted++;
          }
        }
      }
    }

    if (totalCompleted == 0) return "0/${numberOfPuzzlesOfClass(classId)}";

    double avgCompleted = totalCompleted.toDouble();

    return "${avgCompleted.toStringAsFixed(0)}/${filteredPuzzles.length}";
  }

  // Delete puzzle from database
  Future<void> deletePuzzle(BuildContext context, String puzzleId,
      String userId, bool isTeacher) async {
    try {
      UserPuzzleController userPuzzleController =
          Get.put(UserPuzzleController());

      var puzzle = puzzles.where((element) => element.id == puzzleId).first.id;

      await puzzleDatabase.doc(puzzle).delete();
      userPuzzleController.removeStatisticsOfPuzzle(context, puzzleId);

      Navigator.pop(context);
      navigateScreenWithoutBackNavigation(
          context,
          ClassHomePage(
            userId: userId,
            isTeacher: isTeacher,
          ));
    } on FirebaseException {
      showToast("Error while creating statistic of user!");
    }
  }

  // Get number of solved puzzles for user
  String getCompletedPuzzlesForUserInClass(String userId, String classId) {
    UserPuzzleController userPuzzleController = Get.put(UserPuzzleController());

    List<Puzzles> filteredPuzzles =
        puzzles.where((puzzle) => puzzle.classId == classId).toList();

    if (filteredPuzzles.isEmpty) {
      return "0/${filteredPuzzles.length}";
    }

    int completedCount = 0;

    for (var puzzle in filteredPuzzles) {
      List<UserPuzzles> userPuzzleStats = userPuzzleController.userPuzzles
          .where((userPuzzle) =>
              userPuzzle.puzzleId == puzzle.id &&
              userPuzzle.userId == userId &&
              userPuzzle.solved)
          .toList();

      completedCount += userPuzzleStats.length;
    }

    return "$completedCount/${filteredPuzzles.length}";
  }
}
