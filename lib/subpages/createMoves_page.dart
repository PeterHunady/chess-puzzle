// ignore_for_file: file_names, non_constant_identifier_names, unused_element, use_build_context_synchronously

// file: createMoves_page.dart
//
// author: Peter Huňady (xhunadp00)
//
// date: 2024

import 'package:chess/boardController/board.dart';
import 'package:chess/controller/puzzle_controller.dart';
import 'package:chess/customWidgets/customButton_widget.dart';
import 'package:chess/customWidgets/customChessBoard_widget.dart';
import 'package:chess/customWidgets/customChessMovesBox_widget.dart';
import 'package:chess/customWidgets/customClassNavbar_widget.dart';
import 'package:chess/navigationAndToasts.dart';
import 'package:chess/subpages/ClassHome_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

// Subpage to record moves for puzzle
class CreateMovesPage extends StatefulWidget {
  final Board board;
  final String nameOfClass;
  final String iconOfClass;
  final String shortIdOfClass;
  final String classId;
  final String startingPosition;
  final String nameOfPuzzle;
  final String userId;
  final bool isTeacher;

  const CreateMovesPage(
      {required this.board,
      required this.nameOfClass,
      required this.iconOfClass,
      required this.shortIdOfClass,
      required this.classId,
      required this.startingPosition,
      required this.nameOfPuzzle,
      required this.userId,
      required this.isTeacher,
      super.key});

  @override
  State<CreateMovesPage> createState() => _CreateMovesPageState();
}

class _CreateMovesPageState extends State<CreateMovesPage> {
  TextEditingController puzzleNameController = TextEditingController();
  final PuzzleController puzzleController = Get.put(PuzzleController());

  Color whiteColor = const Color.fromARGB(255, 235, 227, 208);
  Color blueColor = const Color.fromARGB(255, 52, 95, 178);
  Color redColor = const Color.fromARGB(255, 178, 52, 52);

  late String startingFenCode;
  final GlobalKey _widgetKey = GlobalKey();
  var board = Board();

  @override
  void initState() {
    board = widget.board;
    startingFenCode = board.generateFEN();

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
                nameOfClass: widget.nameOfClass,
                idOfClass: widget.shortIdOfClass,
                iconPieceName: widget.iconOfClass,
                visible: true,
                function: () {
                  navigateScreen(
                      context,
                      ClassHomePage(
                          userId: widget.userId, isTeacher: widget.isTeacher));
                },
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // Chess board widget
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 40, 10, 0),
                        child: RepaintBoundary(
                          key: _widgetKey,
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
                            onMove: () => setState(() {}),
                          ),
                        ),
                      ),
                      // Show text if someone is checkmated, or if it is a draw or stalemate.
                      Visibility(
                          visible: board.whiteWon ||
                              board.blackWon ||
                              board.draw ||
                              board.stalemate,
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 20),
                            child: Text(textOfGameOver(),
                                style: GoogleFonts.openSans(
                                    color: whiteColor, fontSize: 22)),
                          )),
                      // Button - action to step back
                      Row(children: [
                        SizedBox(
                          width: MediaQuery.sizeOf(context).width / 2,
                          child: CustomButton(
                              paddingHorizontal: 10,
                              paddingVertical: 0,
                              backgroundColorOfBtn: Colors.transparent,
                              borderColorOfBtn: whiteColor,
                              textOfBtn: "Step back",
                              function: () => setState(() {
                                    board.stepBackBoard(startingFenCode);
                                  })),
                        ),
                        // Button - action to step back
                        SizedBox(
                            width: MediaQuery.sizeOf(context).width / 2,
                            child: CustomButton(
                                paddingHorizontal: 10,
                                paddingVertical: 0,
                                backgroundColorOfBtn: Colors.transparent,
                                borderColorOfBtn: whiteColor,
                                textOfBtn: "Reset moves",
                                function: () => setState(() {
                                      board.resetBoardMoves(startingFenCode);
                                    })))
                      ]),
                      // Box with white and black moves
                      Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: CustomChessMovesBox(
                              listOfMoves: board.listOfMoves)),
                      // Button - action to create a new puzzle
                      CustomButton(
                          paddingHorizontal: 10,
                          paddingVertical: 20,
                          backgroundColorOfBtn: blueColor,
                          borderColorOfBtn: Colors.transparent,
                          textOfBtn: "Create Puzzle",
                          function: () => checkPuzzle())
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

  // Text, visible only after game over
  String textOfGameOver() {
    if (board.blackWon) {
      return "Black won by checkmate!";
    } else if (board.whiteWon) {
      return "White won by checkmate!";
    } else if (board.draw) {
      return "Draw!";
    } else if (board.stalemate) {
      return "Stalemate!";
    }
    return "";
  }

  // Check if the puzzle is correct, and if it is, create a new one
  void checkPuzzle() {
    if (board.listOfMoves.isEmpty) {
      showToast("You haven't recorded any steps!");
    } else {
      Navigator.pop(context);
      setState(() {
        board.initializeBoardFromFEN(startingFenCode);
      });

      // Save an image of starting position of puzzle to database
      Future.delayed(const Duration(milliseconds: 40), () {
        puzzleController.captureAndSave(
            widget.nameOfPuzzle,
            widget.classId,
            startingFenCode,
            board.listOfFenCodes,
            _widgetKey,
            board.listOfMoves);

        navigateScreenWithoutBackNavigation(
            context,
            ClassHomePage(
              userId: widget.userId,
              isTeacher: widget.isTeacher,
            ));
      });
    }
  }
}
