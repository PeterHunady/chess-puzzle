// file: knight.dart
//
// author: Peter Huňady (xhunadp00)
//
// date: 2024

import 'package:chess/pieces/piece.dart';
import 'package:flutter/material.dart';

// Knight class, which inherits the parent class pieces
class Knight extends Piece {
  Knight(super.currentRowPosition, super.currentColPosition, super.isWhite);

  // Load an image of white or black knight
  @override
  Widget build() {
    return Center(
      child: Image.asset(
        isWhite
            ? "assets/images/knight_white.png"
            : "assets/images/knight_black.png",
        width: 35,
        height: 35,
      ),
    );
  }

  // FEN code of the knight
  @override
  String getFENChar() {
    return isWhite ? 'N' : 'n';
  }

  // Possible moves of the knight
  @override
  List<List<int>> possibleMoves(List<List<Piece?>> grid) {
    List<List<int>> moves = [];

    if (currentRowPosition + 2 < 8 && currentColPosition + 1 < 8) {
      if (grid[currentRowPosition + 2][currentColPosition + 1]?.isWhite !=
          isWhite) {
        moves.add([currentRowPosition + 2, currentColPosition + 1]);
      }
    }

    if (currentRowPosition + 2 < 8 && currentColPosition - 1 >= 0) {
      if (grid[currentRowPosition + 2][currentColPosition - 1]?.isWhite !=
          isWhite) {
        moves.add([currentRowPosition + 2, currentColPosition - 1]);
      }
    }

    if (currentRowPosition - 2 >= 0 && currentColPosition + 1 < 8) {
      if (grid[currentRowPosition - 2][currentColPosition + 1]?.isWhite !=
          isWhite) {
        moves.add([currentRowPosition - 2, currentColPosition + 1]);
      }
    }

    if (currentRowPosition - 2 >= 0 && currentColPosition - 1 >= 0) {
      if (grid[currentRowPosition - 2][currentColPosition - 1]?.isWhite !=
          isWhite) {
        moves.add([currentRowPosition - 2, currentColPosition - 1]);
      }
    }

    if (currentRowPosition + 1 < 8 && currentColPosition + 2 < 8) {
      if (grid[currentRowPosition + 1][currentColPosition + 2]?.isWhite !=
          isWhite) {
        moves.add([currentRowPosition + 1, currentColPosition + 2]);
      }
    }

    if (currentRowPosition + 1 < 8 && currentColPosition - 2 >= 0) {
      if (grid[currentRowPosition + 1][currentColPosition - 2]?.isWhite !=
          isWhite) {
        moves.add([currentRowPosition + 1, currentColPosition - 2]);
      }
    }

    if (currentRowPosition - 1 >= 0 && currentColPosition + 2 < 8) {
      if (grid[currentRowPosition - 1][currentColPosition + 2]?.isWhite !=
          isWhite) {
        moves.add([currentRowPosition - 1, currentColPosition + 2]);
      }
    }

    if (currentRowPosition - 1 >= 0 && currentColPosition - 2 >= 0) {
      if (grid[currentRowPosition - 1][currentColPosition - 2]?.isWhite !=
          isWhite) {
        moves.add([currentRowPosition - 1, currentColPosition - 2]);
      }
    }

    return moves;
  }
}
