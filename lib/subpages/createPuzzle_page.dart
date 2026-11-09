// ignore_for_file: file_names, non_constant_identifier_names, use_build_context_synchronously

// file: createPuzzle_page.dart
//
// author: Peter Huňady (xhunadp00)
//
// date: 2024

import 'package:chess/boardController/board.dart';
import 'package:chess/navigationAndToasts.dart';
import 'package:chess/customWidgets/customButton_widget.dart';
import 'package:chess/customWidgets/customChessBoard_widget.dart';
import 'package:chess/customWidgets/customClassNavbar_widget.dart';
import 'package:chess/customWidgets/customTextField_widget.dart';
import 'package:chess/subpages/classHome_page.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

// Subpage to create a starting position of the puzzle
class CreatePuzzlePage extends StatefulWidget {
  final String nameOfClass;
  final String iconOfClass;
  final String shortIdOfClass;
  final String classId;
  final String userId;
  final bool isTeacher;

  const CreatePuzzlePage(
      {super.key,
      required this.nameOfClass,
      required this.iconOfClass,
      required this.shortIdOfClass,
      required this.classId,
      required this.userId,
      required this.isTeacher});

  @override
  State<CreatePuzzlePage> createState() => _CreatePuzzlePageState();
}

class _CreatePuzzlePageState extends State<CreatePuzzlePage> {
  TextEditingController puzzleNameController = TextEditingController();

  Color whiteColor = const Color.fromARGB(255, 235, 227, 208);
  Color blueColor = const Color.fromARGB(255, 52, 95, 178);
  Color redColor = const Color.fromARGB(255, 178, 52, 52);
  Color grayColor = const Color.fromARGB(255, 121, 121, 121);

  List listOfPieceNames = [
    "king",
    "queen",
    "rook",
    "bishop",
    "knight",
    "pawn",
  ];

  String clickedPiece = "", colorOfClickedPiece = "";

  var board = Board();
  bool clickedX = false;

  @override
  void initState() {
    board.clearBoard();
    board.setupBoard();

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
                      // Name of puzzle input field
                      CustomTextField(
                        text: "*Enter Name",
                        labelText: "Puzzle name",
                        controller: puzzleNameController,
                        left: 10,
                        top: 45,
                        right: 10,
                        bottom: 10,
                        isPassword: false,
                        onChanged: (value) => (),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Straight line horizontal divider
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(right: 30),
                                child: Divider(
                                  color: grayColor,
                                  thickness: 1,
                                ),
                              ),
                            ),
                            Text(
                              "Setup starting position",
                              style: GoogleFonts.openSans(
                                  fontSize: 17, color: grayColor),
                            ),
                            // Straight line horizontal divider
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 30),
                                child: Divider(
                                  color: grayColor,
                                  thickness: 1,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Chess board widget
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
                        child: CustomChessBoard(
                          cols: 8,
                          rows: 8,
                          sizeOfRowsAndCols:
                              MediaQuery.sizeOf(context).width / 8,
                          board: board,
                          placingPieces: true,
                          clickedPiece: clickedPiece,
                          colorOfClickedPiece: colorOfClickedPiece,
                          onSquareTapped: handleSquareTapped,
                          onMove: () => (),
                        ),
                      ),
                      Row(
                        children: [
                          // Button - action to clear all pieces from the board
                          SizedBox(
                            width: MediaQuery.sizeOf(context).width / 2,
                            child: CustomButton(
                                paddingHorizontal: 10,
                                paddingVertical: 0,
                                backgroundColorOfBtn: Colors.transparent,
                                borderColorOfBtn: whiteColor,
                                textOfBtn: "Clear board",
                                function: () => setState(() {
                                      board.clearBoard();
                                    })),
                          ),
                          // Button - action to reset board
                          SizedBox(
                            width: MediaQuery.sizeOf(context).width / 2,
                            child: CustomButton(
                                paddingHorizontal: 10,
                                paddingVertical: 0,
                                backgroundColorOfBtn: Colors.transparent,
                                borderColorOfBtn: whiteColor,
                                textOfBtn: "Reset board",
                                function: () => setState(() {
                                      board.setupBoard();
                                    })),
                          ),
                        ],
                      ),
                      // Row with all black pieces
                      AllPiecesRow("black", false),
                      // Row with all white pieces
                      AllPiecesRow("white", false),
                      // Button to remove selected piece
                      AllPiecesRow("white", true),
                      // Navigate to create moves for puzzle
                      CustomButton(
                          paddingHorizontal: 10,
                          paddingVertical: 20,
                          backgroundColorOfBtn: blueColor,
                          borderColorOfBtn: Colors.transparent,
                          textOfBtn: "Continue",
                          function: () => board.validChessBoard(
                              context,
                              puzzleNameController.text.trim(),
                              widget.nameOfClass,
                              widget.iconOfClass,
                              widget.shortIdOfClass,
                              widget.classId,
                              widget.userId,
                              widget.isTeacher)),
                    ],
                  ),
                ),
              ),
              // const CustomFooter(),
            ],
          ),
        ),
      ),
    );
  }

  // Row with pieces
  Widget AllPiecesRow(String colorOfPiece, bool deletePiece) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
        child: !deletePiece
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  for (var i in listOfPieceNames) ...[
                    GestureDetector(
                        onTap: () {
                          setState(() {
                            clickedPiece = i;
                            clickedX = false;
                            if (colorOfPiece == "black") {
                              colorOfClickedPiece = "black";
                            } else if (colorOfPiece == "white") {
                              colorOfClickedPiece = "white";
                            }
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                            color: clickedPiece == i &&
                                    colorOfPiece == colorOfClickedPiece
                                ? grayColor
                                : Colors.transparent,
                          ),
                          child: Padding(
                              padding: const EdgeInsets.all(6.0),
                              child: Image.asset(
                                "assets/images/${i}_$colorOfPiece.png",
                                width: 30,
                              )),
                        )),
                  ],
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                      onTap: () {
                        setState(() {
                          clickedX = true;
                          clickedPiece = "x";
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                          color: clickedX ? grayColor : Colors.transparent,
                        ),
                        child: Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: Icon(
                              FontAwesomeIcons.x,
                              size: 30,
                              color: whiteColor,
                            )),
                      )),
                ],
              ));
  }

  // Show piece on the board after placing
  void handleSquareTapped(int row, int col) {
    setState(() {
      board.placePiece(clickedPiece, colorOfClickedPiece, row, col);
    });
  }
}
