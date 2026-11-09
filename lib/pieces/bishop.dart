// file: bishop.dart
//
// author: Peter Huňady (xhunadp00)
//
// date: 2024

import 'package:chess/pieces/piece.dart';
import 'package:flutter/material.dart';

// Bishop class, which inherits the parent class pieces
class Bishop extends Piece {
  Bishop(super.currentRowPosition, super.currentColPosition, super.isWhite);

  // Load an image of white or black bishop
  @override
  Widget build() {
    return Center(
      child: Image.asset(
        isWhite
            ? "assets/images/bishop_white.png"
            : "assets/images/bishop_black.png",
        width: 35,
        height: 35,
      ),
    );
  }

  // FEN code of the bishop
  @override
  String getFENChar() {
    return isWhite ? 'B' : 'b';
  }

  // Possible moves of the bishop
  @override
  List<List<int>> possibleMoves(List<List<Piece?>> grid) {
    List<List<int>> moves = [];

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
