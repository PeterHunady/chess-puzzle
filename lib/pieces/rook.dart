// ignore_for_file: overridden_fields

// file: rook.dart
//
// author: Peter Huňady (xhunadp00)
//
// date: 2024

import 'package:chess/pieces/piece.dart';
import 'package:flutter/material.dart';

// Rook class, which inherits the parent class pieces
class Rook extends Piece {
  @override
  bool hasMoved = false;
  Rook(super.currentRowPosition, super.currentColPosition, super.isWhite);

  // Load an image of white or black rook
  @override
  Widget build() {
    return Center(
      child: Image.asset(
        isWhite
            ? "assets/images/rook_white.png"
            : "assets/images/rook_black.png",
        width: 35,
        height: 35,
      ),
    );
  }

  // FEN code of the rook
  @override
  String getFENChar() {
    return isWhite ? 'R' : 'r';
  }

  // Possible moves of the rook
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

    return moves;
  }
}
