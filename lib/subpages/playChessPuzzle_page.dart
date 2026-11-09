// ignore_for_file: file_names, non_constant_identifier_names

// file: playChessPuzzle.dart
//
// author: Peter Huňady (xhunadp00)
//
// date: 2024

import 'dart:async';
import 'package:chess/boardController/board.dart';
import 'package:chess/controller/puzzle_controller.dart';
import 'package:chess/controller/userPuzzle_controller.dart';
import 'package:chess/customWidgets/customButton_widget.dart';
import 'package:chess/customWidgets/customChessBoard_widget.dart';
import 'package:chess/customWidgets/customChessMovesBox_widget.dart';
import 'package:chess/customWidgets/customClassNavbar_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

// Subpage for playing puzzle
class PlayChessPuzzlePage extends StatefulWidget {
  final String nameOfClass;
  final String iconOfClass;
  final String shortIdOfClass;
  final String classId;
  final String puzzleId;
  final String userId;
  final String imageUrl;
  final String puzzleName;
  final bool isTeacher;

  const PlayChessPuzzlePage(
      {super.key,
      required this.nameOfClass,
      required this.iconOfClass,
      required this.shortIdOfClass,
      required this.classId,
      required this.puzzleId,
      required this.userId,
      required this.imageUrl,
      required this.puzzleName,
      required this.isTeacher});

  @override
  State<PlayChessPuzzlePage> createState() => _PlayChessPuzzlePageState();
}

class _PlayChessPuzzlePageState extends State<PlayChessPuzzlePage> {
  Color whiteColor = const Color.fromARGB(255, 235, 227, 208);
  Color blueColor = const Color.fromARGB(255, 52, 95, 178);
  Color redColor = const Color.fromARGB(255, 178, 52, 52);

  final PuzzleController puzzleController = Get.put(PuzzleController());
  final UserPuzzleController userPuzzleController =
      Get.put(UserPuzzleController());
  late String startingFenCode;
  var board = Board();

  // Timer and lists of correct moves
  List listOfCorrectFenCodes = [], listOfCorrectMoves = [];
  int moves = -1, attempts = 0, _secondsPassed = 0;
  bool correctMove = true;
  Timer? _timer;
  String time = "00:00";

  @override
  void initState() {
    // Initialize start position and correct moves
    startingFenCode = puzzleController.getStartingPosition(widget.puzzleId);
    board.initializeBoardFromFEN(startingFenCode);
    listOfCorrectMoves =
        puzzleController.getPuzzleCorrectMoveNotation(widget.puzzleId);
    listOfCorrectFenCodes =
        puzzleController.getPuzzleCorrectMoves(widget.puzzleId);
    _startTimer();

    super.initState();
  }

  @override
  void dispose() {
    // Cancel timer after moving to another subpage
    if (_timer!.isActive) {
      _timer!.cancel();
    }
    super.dispose();
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
                nameOfClass: widget.nameOfClass,
                idOfClass: widget.shortIdOfClass,
                iconPieceName: widget.iconOfClass,
                visible: false,
                function: () {},
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // Text with who's turn it is
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("White to move",
                                style: GoogleFonts.openSans(
                                    color: whiteColor, fontSize: 16)),
                            Text(time,
                                style: GoogleFonts.openSans(
                                    color: whiteColor, fontSize: 20))
                          ],
                        ),
                      ),
                      // Chess board widget
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                        child: CustomChessBoard(
                          cols: 8,
                          rows: 8,
                          sizeOfRowsAndCols:
                              MediaQuery.sizeOf(context).width / 8,
                          board: board,
                          placingPieces: false,
                          clickedPiece: "",
                          colorOfClickedPiece: "",
                          onSquareTapped: (i1, i2) => (),
                          onMove: () => setState(() {
                            board.onMove(moves, listOfCorrectFenCodes,
                                listOfCorrectMoves, _timer);
                            correctMove = board.isCorrectMove();
                          }),
                        ),
                      ),
                      // Visible after incorrect move
                      Visibility(
                          visible: !correctMove,
                          child: Row(
                            children: [
                              Container(
                                width: MediaQuery.sizeOf(context).width / 2,
                                padding: const EdgeInsets.only(left: 10),
                                child: Text("Incorrect move ❌",
                                    style: GoogleFonts.openSans(
                                        color: whiteColor, fontSize: 16)),
                              ),
                              SizedBox(
                                width: MediaQuery.sizeOf(context).width / 2,
                                child: CustomButton(
                                    paddingHorizontal: 10,
                                    paddingVertical: 7,
                                    backgroundColorOfBtn: Colors.transparent,
                                    borderColorOfBtn: whiteColor,
                                    textOfBtn: "Restart puzzle",
                                    function: () {
                                      setState(() {
                                        board.restartPuzzle(startingFenCode);
                                        correctMove = true;
                                        attempts++;
                                        _startTimer();
                                      });
                                    }),
                              )
                            ],
                          )),
                      // Visible after puzzle is succesfully completed
                      Visibility(
                          visible: board.whiteWon && correctMove,
                          child: Text(
                              "You have successfully completed this puzzle ✅",
                              style: GoogleFonts.openSans(
                                  color: whiteColor, fontSize: 16))),
                      // Box with white and black moves
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child:
                            CustomChessMovesBox(listOfMoves: board.listOfMoves),
                      ),
                      // Button - action to surrender if the puzzle was unsuccessfully solved
                      !board.whiteWon
                          ? CustomButton(
                              paddingHorizontal: 10,
                              paddingVertical: 20,
                              backgroundColorOfBtn: redColor,
                              borderColorOfBtn: Colors.transparent,
                              textOfBtn: "Surrender",
                              function: () =>
                                  userPuzzleController.createStatisticOfUser(
                                      context,
                                      widget.userId,
                                      widget.classId,
                                      widget.puzzleId,
                                      time,
                                      widget.imageUrl,
                                      widget.puzzleName,
                                      attempts + 1,
                                      false,
                                      widget.isTeacher))
                          // Button - navigate to class subpage after puzzle was successfully solved
                          : CustomButton(
                              paddingHorizontal: 10,
                              paddingVertical: 20,
                              backgroundColorOfBtn: blueColor,
                              borderColorOfBtn: Colors.transparent,
                              textOfBtn: "Home",
                              function: () =>
                                  userPuzzleController.createStatisticOfUser(
                                      context,
                                      widget.userId,
                                      widget.classId,
                                      widget.puzzleId,
                                      time,
                                      widget.imageUrl,
                                      widget.puzzleName,
                                      attempts,
                                      true,
                                      widget.isTeacher))
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Timer of solving puzzle
  void _startTimer() {
    userPuzzleController.getAverageTime(widget.puzzleId);

    if (_timer != null && _timer!.isActive) {
      _timer!.cancel();
    }

    time = "00:00";
    _secondsPassed = 0;

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _secondsPassed++;
        int minutes = _secondsPassed ~/ 60;
        int seconds = _secondsPassed % 60;
        time =
            "${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";
      });
    });
  }
}
