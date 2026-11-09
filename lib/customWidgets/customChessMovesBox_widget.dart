// ignore_for_file: library_private_types_in_public_api, file_names

// file: customChessMovesBox_widget.dart
//
// author: Peter Huňady (xhunadp00)
//
// date: 2024

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Box widget to show white and black moves
class CustomChessMovesBox extends StatefulWidget {
  final List listOfMoves;
  const CustomChessMovesBox({required this.listOfMoves, super.key});

  @override
  _CustomChessMovesBoxState createState() => _CustomChessMovesBoxState();
}

class _CustomChessMovesBoxState extends State<CustomChessMovesBox> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(width: 1, color: Colors.white),
          borderRadius: const BorderRadius.all(Radius.circular(5)),
        ),
        height: 180,
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Column(
              children: _appendMove(),
            ),
          ),
        ),
      ),
    );
  }

  // Append each move to the box
  List<Widget> _appendMove() {
    List<Widget> rows = [];
    for (int i = 0; i < widget.listOfMoves.length; i += 2) {
      rows.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // Append number of move
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                ((i ~/ 2) + 1).toString(),
                style: GoogleFonts.openSans(fontSize: 14, color: Colors.white),
              ),
            ),
            Expanded(
              // Append image of moved piece to the box
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: Image.asset(
                      getImageOfPiece(widget.listOfMoves[i], i),
                      width: 20,
                    ),
                  ),
                  // Append move code
                  Text(
                    widget.listOfMoves[i],
                    style:
                        GoogleFonts.openSans(fontSize: 14, color: Colors.white),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            if (i + 1 < widget.listOfMoves.length)
              Expanded(
                child: Row(
                  children: [
                    // Append black moves after white move
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Image.asset(
                        getImageOfPiece(widget.listOfMoves[i + 1], i + 1),
                        width: 20,
                      ),
                    ),
                    Text(
                      widget.listOfMoves[i + 1],
                      style: GoogleFonts.openSans(
                          fontSize: 14, color: Colors.white),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
          ],
        ),
      );
    }
    return rows;
  }

  String getImageOfPiece(String piece, int index) {
    String colorOfPiece = "black";
    if (index % 2 == 0) {
      colorOfPiece = "white";
    }

    switch (piece[0]) {
      case "O":
      case "K":
        return "assets/images/king_$colorOfPiece.png";
      case "Q":
        return "assets/images/queen_$colorOfPiece.png";
      case "R":
        return "assets/images/rook_$colorOfPiece.png";
      case "B":
        return "assets/images/bishop_$colorOfPiece.png";
      case "N":
        return "assets/images/knight_$colorOfPiece.png";
      default:
        return "assets/images/pawn_$colorOfPiece.png";
    }
  }
}
