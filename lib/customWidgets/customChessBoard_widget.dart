// ignore_for_file: file_names

// file: customChessBoard_widget.dart
//
// author: Peter Huňady (xhunadp00)
//
// date: 2024

import 'package:chess/boardController/board.dart';
import 'package:flutter/material.dart';

// Chess board widget
class CustomChessBoard extends StatefulWidget {
  final int cols, rows;
  final double sizeOfRowsAndCols;
  final Board board;
  final bool placingPieces;
  final String clickedPiece, colorOfClickedPiece;
  final Function(int, int) onSquareTapped;
  final VoidCallback onMove;

  const CustomChessBoard(
      {required this.cols,
      required this.rows,
      required this.sizeOfRowsAndCols,
      required this.board,
      required this.placingPieces,
      required this.clickedPiece,
      required this.colorOfClickedPiece,
      required this.onSquareTapped,
      required this.onMove,
      super.key});

  @override
  State<CustomChessBoard> createState() => _CustomChessBoardState();
}

class _CustomChessBoardState extends State<CustomChessBoard> {
  late int cols, rows;
  late double sizeOfRowsAndCols;
  late Board board;
  late bool placingPieces;
  late String clickedPiece, colorOfClickedPiece;
  // Visibility of dialog
  bool _isPromotionDialogShown = false;

  @override
  void initState() {
    cols = widget.cols;
    rows = widget.rows;
    sizeOfRowsAndCols = widget.sizeOfRowsAndCols;
    board = widget.board;
    placingPieces = widget.placingPieces;
    clickedPiece = widget.clickedPiece;
    colorOfClickedPiece = widget.colorOfClickedPiece;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Only show the promotion dialog when a pawn is promoting and no dialog is already shown.
    if (board.promotingPawn && !_isPromotionDialogShown) {
      _isPromotionDialogShown = true; // Set dialog as shown
      showPawnPromotionDialog();
    }

    return SizedBox(
      width: cols * sizeOfRowsAndCols,
      height: rows * sizeOfRowsAndCols,
      child: GridView.count(
        primary: false,
        crossAxisCount: 8,
        children: <Widget>[
          for (int i = 0; i < rows; i++) ...[
            for (int j = 0; j < cols; j++) ...[
              GestureDetector(
                onTap: () {
                  setState(() {
                    // Playing puzzle
                    if (!board.stalemate &&
                        !board.blackWon &&
                        !board.whiteWon &&
                        !board.draw &&
                        !placingPieces) {
                      if (board.pieceIsClicked(i, j)) {
                        board.possibleMovesOnSquares(i, j);
                      } else {
                        board.movePiece(i, j);
                        widget.onMove();
                        board.possibleMoves = [];
                        board.selectedRow = null;
                        board.selectedCol = null;
                      }
                    }

                    // Placing pieces on the chess board
                    if (placingPieces) {
                      board.possibleMoves = [];
                      widget.onSquareTapped(i, j);
                    }
                  });
                },
                child: Container(
                  width: sizeOfRowsAndCols,
                  height: sizeOfRowsAndCols,
                  decoration: BoxDecoration(
                    border: Border.all(width: 0.1, color: Colors.black),
                    color: !placingPieces &&
                            board.selectedRow == i &&
                            board.selectedCol == j
                        ? const Color.fromARGB(255, 184, 141, 75)
                        : (board.isPossibleMove(i, j) &&
                                board.grid[i][j] != null &&
                                board.grid[i][j]!.isWhite !=
                                    board.isWhitePlaying)
                            ? const Color.fromARGB(200, 178, 34, 34)
                            : board.isPossibleMove(i, j)
                                ? const Color.fromARGB(197, 62, 142, 62)
                                : (i + j) % 2 == 0
                                    ? Colors.grey
                                    : const Color.fromARGB(255, 40, 40, 40),
                  ),
                  child: board.grid[i][j]?.build(),
                ),
              ),
            ]
          ]
        ],
      ),
    );
  }

  // Show dialog, if pawn is promoting
  void showPawnPromotionDialog() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: const Color.fromARGB(200, 0, 0, 0),
            title: const Text(
              "Choose a new piece.",
              textAlign: TextAlign.center,
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.w400),
            ),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Show all pieces
                for (var piece in ["Queen", "Knight", "Rook", "Bishop"])
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      child: Container(
                        decoration:
                            const BoxDecoration(color: Colors.transparent),
                        child: Image.asset(
                          board.isWhitePlaying
                              ? "assets/images/${piece.toLowerCase()}_white.png"
                              : "assets/images/${piece.toLowerCase()}_black.png",
                          width: 40,
                        ),
                      ),
                      onTap: () {
                        setState(() {
                          // Promote pawn
                          board.promotePawn(piece);
                          // Cancel promoting dialog
                          _isPromotionDialogShown = false;
                          Navigator.pop(context);
                          widget.onMove();
                        });
                      },
                    ),
                  ),
              ],
            ),
          );
        },
      );
    });
  }
}
