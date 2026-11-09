// file: king.dart
//
// author: Peter Huňady (xhunadp00)
//
// date: 2024

import 'package:chess/pieces/piece.dart';
import 'package:flutter/material.dart';

// King class, which inherits the parent class pieces
class King extends Piece {
  King(super.currentRowPosition, super.currentColPosition, super.isWhite);

  // Load an image of white or black king
  @override
  Widget build() {
    return Center(
      child: Image.asset(
        isWhite
            ? "assets/images/king_white.png"
            : "assets/images/king_black.png",
        width: 35,
        height: 35,
      ),
    );
  }

  // FEN code of the king
  @override
  String getFENChar() {
    return isWhite ? 'K' : 'k';
  }

  // Possible moves of the king
  @override
  List<List<int>> possibleMoves(List<List<Piece?>> grid) {
    List<List<int>> moves = [];

    if (currentRowPosition + 1 < 8) {
      if (grid[currentRowPosition + 1][currentColPosition]?.isWhite !=
          isWhite) {
        moves.add([currentRowPosition + 1, currentColPosition]);
      }
    }
    if (currentRowPosition - 1 >= 0) {
      if (grid[currentRowPosition - 1][currentColPosition]?.isWhite !=
          isWhite) {
        moves.add([currentRowPosition - 1, currentColPosition]);
      }
    }
    if (currentColPosition + 1 < 8) {
      if (grid[currentRowPosition][currentColPosition + 1]?.isWhite !=
          isWhite) {
        moves.add([currentRowPosition, currentColPosition + 1]);
      }
    }
    if (currentColPosition - 1 >= 0) {
      if (grid[currentRowPosition][currentColPosition - 1]?.isWhite !=
          isWhite) {
        moves.add([currentRowPosition, currentColPosition - 1]);
      }
    }
    if (currentRowPosition + 1 < 8 && currentColPosition - 1 >= 0) {
      if (grid[currentRowPosition + 1][currentColPosition - 1]?.isWhite !=
          isWhite) {
        moves.add([currentRowPosition + 1, currentColPosition - 1]);
      }
    }
    if (currentRowPosition + 1 < 8 && currentColPosition + 1 < 8) {
      if (grid[currentRowPosition + 1][currentColPosition + 1]?.isWhite !=
          isWhite) {
        moves.add([currentRowPosition + 1, currentColPosition + 1]);
      }
    }
    if (currentRowPosition - 1 >= 0 && currentColPosition - 1 >= 0) {
      if (grid[currentRowPosition - 1][currentColPosition - 1]?.isWhite !=
          isWhite) {
        moves.add([currentRowPosition - 1, currentColPosition - 1]);
      }
    }
    if (currentRowPosition - 1 >= 0 && currentColPosition + 1 < 8) {
      if (grid[currentRowPosition - 1][currentColPosition + 1]?.isWhite !=
          isWhite) {
        moves.add([currentRowPosition - 1, currentColPosition + 1]);
      }
    }

    return moves;
  }
}
