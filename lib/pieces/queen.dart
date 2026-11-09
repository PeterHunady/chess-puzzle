// file: queen.dart
//
// author: Peter Huňady (xhunadp00)
//
// date: 2024

import 'package:chess/pieces/piece.dart';
import 'package:flutter/material.dart';

// Queen class, which inherits the parent class pieces
class Queen extends Piece {
  Queen(super.currentRowPosition, super.currentColPosition, super.isWhite);

  // Load an image of white or black queen
  @override
  Widget build() {
    return Center(
      child: Image.asset(
        isWhite
            ? "assets/images/queen_white.png"
            : "assets/images/queen_black.png",
        width: 35,
        height: 35,
      ),
    );
  }

  // FEN code of the queen
  @override
  String getFENChar() {
    return isWhite ? 'Q' : 'q';
  }

  // Possible moves of the queen
  @override
  List<List<int>> possibleMoves(List<List<Piece?>> grid) {
    List<List<int>> moves = [];

    for (int i = currentRowPosition + 1; i < 8; i++) {
      Piece? piece = grid[i][currentColPosition];
      if (piece == null) {
        moves.add([i, currentColPosition]);
      } else {
        if (piece.isWhite != isWhite) {
          moves.add([i, currentColPosition]);
        }
        break;
      }
    }

    for (int i = currentRowPosition - 1; i >= 0; i--) {
      Piece? piece = grid[i][currentColPosition];
      if (piece == null) {
        moves.add([i, currentColPosition]);
      } else {
        if (piece.isWhite != isWhite) {
          moves.add([i, currentColPosition]);
        }
        break;
      }
    }

    for (int i = currentColPosition + 1; i < 8; i++) {
      Piece? piece = grid[currentRowPosition][i];
      if (piece == null) {
        moves.add([currentRowPosition, i]);
      } else {
        if (piece.isWhite != isWhite) {
          moves.add([currentRowPosition, i]);
        }
        break;
      }
    }

    for (int i = currentColPosition - 1; i >= 0; i--) {
      Piece? piece = grid[currentRowPosition][i];
      if (piece == null) {
        moves.add([currentRowPosition, i]);
      } else {
        if (piece.isWhite != isWhite) {
          moves.add([currentRowPosition, i]);
        }
        break;
      }
    }

    int row = currentRowPosition;
    int col = currentColPosition;
    while (row + 1 < 8 && col + 1 < 8) {
      row++;
      col++;
      Piece? piece = grid[row][col];
      if (piece == null) {
        moves.add([row, col]);
      } else {
        if (piece.isWhite != isWhite) {
          moves.add([row, col]);
        }
        break;
      }
    }

    row = currentRowPosition;
    col = currentColPosition;
    while (row + 1 < 8 && col - 1 >= 0) {
      row++;
      col--;
      Piece? piece = grid[row][col];
      if (piece == null) {
        moves.add([row, col]);
      } else {
        if (piece.isWhite != isWhite) {
          moves.add([row, col]);
        }
        break;
      }
    }

    row = currentRowPosition;
    col = currentColPosition;
    while (row - 1 >= 0 && col + 1 < 8) {
      row--;
      col++;
      Piece? piece = grid[row][col];
      if (piece == null) {
        moves.add([row, col]);
      } else {
        if (piece.isWhite != isWhite) {
          moves.add([row, col]);
        }
        break;
      }
    }

    row = currentRowPosition;
    col = currentColPosition;
    while (row - 1 >= 0 && col - 1 >= 0) {
      row--;
      col--;
      Piece? piece = grid[row][col];
      if (piece == null) {
        moves.add([row, col]);
      } else {
        if (piece.isWhite != isWhite) {
          moves.add([row, col]);
        }
        break;
      }
    }

    return moves;
  }
}
