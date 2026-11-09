// ignore_for_file: file_names, use_build_context_synchronously, avoid_types_as_parameter_names

// file: userPuzzle_controller.dart
//
// author: Peter Huňady (xhunadp00)
//
// date: 2024

import 'package:chess/models/userPuzzle_model.dart';
import 'package:chess/navigationAndToasts.dart';
import 'package:chess/subpages/puzzle_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Controller for user statistics of puzzle
class UserPuzzleController extends GetxController {
  final userPuzzleDatabase =
      FirebaseFirestore.instance.collection('userPuzzle');
  final userPuzzles = <UserPuzzles>[].obs;

  // Function to fetch all data as a stream.
  Stream<List<UserPuzzles>> getAllPuzzlesOfUsers() {
    return userPuzzleDatabase.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => UserPuzzles.fromSnapshot(doc)).toList();
    });
  }

  @override
  void onInit() {
    userPuzzles.bindStream(getAllPuzzlesOfUsers());
    super.onInit();
  }

  // After successfully or unseccessfully solved puzzle, create statistic of user
  Future<void> createStatisticOfUser(
      BuildContext context,
      String userId,
      String classId,
      String puzzleId,
      String time,
      String imageUrl,
      String puzzleName,
      int attempts,
      bool solved,
      bool isTeacher) async {
    try {
      // Generate new unique ID
      final documentUuid = userPuzzleDatabase.doc().id;

      // Find user statistic in database
      final existingAttempt = userPuzzles.firstWhere(
        (element) => element.userId == userId && element.puzzleId == puzzleId,
        orElse: () => UserPuzzles(
            id: "",
            userId: userId,
            puzzleId: puzzleId,
            time: time,
            attempts: attempts,
            solved: solved),
      );

      // If not found, write new data
      if (existingAttempt.id.isEmpty) {
        UserPuzzles userPuzzle = UserPuzzles(
            id: documentUuid,
            userId: userId,
            puzzleId: puzzleId,
            time: time,
            attempts: attempts + 1,
            solved: solved);

        await userPuzzleDatabase.doc(documentUuid).set(userPuzzle.toMap());
      }
      // If found, rewrite old data
      else {
        String idOfUserPuzzle = getIdOfUserPuzzle(puzzleId, userId);
        int attemptsOfUserPuzzle = getAttemptsOfUserPuzzle(puzzleId, userId);

        if (!getSolvedOfUserPuzzle(puzzleId, userId)) {
          await userPuzzleDatabase
              .doc(idOfUserPuzzle)
              .update({'attempts': attemptsOfUserPuzzle + attempts});
          await userPuzzleDatabase
              .doc(idOfUserPuzzle)
              .update({'solved': solved});
        }
      }

      navigateScreenWithoutBackNavigation(
          context,
          PuzzlePage(
              userId: userId,
              isTeacher: isTeacher,
              classId: classId,
              puzzleName: puzzleName,
              imageUrl: imageUrl,
              id: puzzleId));
    } on FirebaseException {
      showToast("Error while creating statistic of user!");
    }
  }

  // Function to get ID of the user
  String getIdOfUserPuzzle(String puzzleId, String userId) {
    try {
      return userPuzzles
          .where((element) =>
              element.puzzleId == puzzleId && element.userId == userId)
          .first
          .id;
    } catch (e) {
      showToast("Error.");
      return "";
    }
  }

  // Get attempts of user for the puzzle
  int getAttemptsOfUserPuzzle(String puzzleId, String userId) {
    try {
      var matches = userPuzzles.where((element) =>
          element.puzzleId == puzzleId && element.userId == userId);

      if (matches.isEmpty) {
        return 0;
      }

      return matches.first.attempts;
    } catch (e) {
      showToast("Error.");
      return 0;
    }
  }

  // Get if puzzle was solved by user
  bool getSolvedOfUserPuzzle(String puzzleId, String userId) {
    try {
      return userPuzzles
          .where((element) =>
              element.puzzleId == puzzleId && element.userId == userId)
          .first
          .solved;
    } catch (e) {
      showToast("Error.");
      return false;
    }
  }

  // Get the number of solved attempts for the puzzle.
  int getNumberOfSolved(String puzzleId) {
    try {
      return userPuzzles
          .where((element) => element.puzzleId == puzzleId && element.solved)
          .length;
    } catch (e) {
      showToast("Error.");
      return 0;
    }
  }

  // Get time of user for the puzzle
  String getTimeOfUser(String puzzleId, String userId) {
    try {
      var matches = userPuzzles.where((element) =>
          element.puzzleId == puzzleId && element.userId == userId);

      if (matches.isEmpty) {
        return "00:00";
      }

      return matches.first.time;
    } catch (e) {
      showToast("Error.");
      return "";
    }
  }

  // Get average time of all attempts for the puzzle
  String getAverageTime(String puzzleId) {
    try {
      List<UserPuzzles> puzzles =
          userPuzzles.where((element) => element.puzzleId == puzzleId).toList();

      if (puzzles.isEmpty) return "00:00";

      // Time format
      int totalSeconds = puzzles.fold(0, (sum, puzzle) {
        List<String> timeParts = puzzle.time.split(":");
        int minutes = int.parse(timeParts[0]);
        int seconds = int.parse(timeParts[1]);
        return sum + (minutes * 60) + seconds;
      });

      int avgSeconds = totalSeconds ~/ puzzles.length;

      int avgMinutes = avgSeconds ~/ 60;
      int avgRemainingSeconds = avgSeconds % 60;
      String avgTime =
          "${avgMinutes.toString().padLeft(2, '0')}:${avgRemainingSeconds.toString().padLeft(2, '0')}";

      return avgTime;
    } catch (e) {
      showToast("Error.");
      return "00:00";
    }
  }

  // Get average number of attempts of all attempts for thhe puzzle
  int getAverageAttempts(String puzzleId) {
    try {
      List<UserPuzzles> puzzles =
          userPuzzles.where((element) => element.puzzleId == puzzleId).toList();

      if (puzzles.isEmpty) return 0;

      int totalAttempts =
          puzzles.fold(0, (sum, puzzle) => sum + puzzle.attempts);

      int avgAttempts = totalAttempts ~/ puzzles.length;

      return avgAttempts;
    } catch (e) {
      showToast("Error");
      return 0;
    }
  }

  // Get if puzzle was successfully solved by user
  bool getSolved(String puzzleId, String userId) {
    try {
      var matches = userPuzzles.where((element) =>
          element.puzzleId == puzzleId && element.userId == userId);

      if (matches.isEmpty) {
        return false;
      }

      var idk = matches.first;
      return idk.solved;
    } catch (e) {
      showToast("Error");
      return false;
    }
  }

  // Remove user from statistics after deleting his account or removing from the class
  Future<void> removeUserFromStatistics(
      BuildContext context, String userId) async {
    try {
      var userStatistics =
          userPuzzles.where((element) => element.userId == userId);

      for (var userStat in userStatistics) {
        await userPuzzleDatabase.doc(userStat.id).delete();
      }
    } on FirebaseException {
      showToast("Error while creating statistic of user!");
    }
  }

  // Remove statistics of puzzle after deleting the puzzle
  Future<void> removeStatisticsOfPuzzle(
      BuildContext context, String puzzleId) async {
    try {
      var userStatistics =
          userPuzzles.where((element) => element.puzzleId == puzzleId);

      for (var userStat in userStatistics) {
        await userPuzzleDatabase.doc(userStat.id).delete();
      }
    } on FirebaseException {
      showToast("Error while creating statistic of user!");
    }
  }
}
