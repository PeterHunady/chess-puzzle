// file: pawn.dart
//
// author: Peter Huňady (xhunadp00)
//
// date: 2024

import 'package:chess/pieces/piece.dart';
import 'package:flutter/material.dart';

// Pawn class, which inherits the parent class pieces
class Pawn extends Piece {
  Pawn(super.currentRowPosition, super.currentColPosition, super.isWhite);

  // Load an image of white or black pawn
  @override
  Widget build() {
    return Center(
      child: Image.asset(
        isWhite
            ? "assets/images/pawn_white.png"
            : "assets/images/pawn_black.png",
        width: 35,
        height: 35,
      ),
    );
  }

  // FEN code of the pawn
  @override
  String getFENChar() {
    return isWhite ? 'P' : 'p';
  }

  // Possible moves of the pawn
  @override
  List<List<int>> possibleMoves(List<List<Piece?>> grid,
      {Pawn? enPassantEligiblePawn}) {
    List<List<int>> moves = [];
    int direction = isWhite ? -1 : 1;
    int steps = 1;

    if ((isWhite && currentRowPosition == 6) ||
        (!isWhite && currentRowPosition == 1)) {
      steps = 2;
    }

    for (var i = 1; i <= steps; i++) {
      int newRow = currentRowPosition + i * direction;
      if (newRow >= 0 && newRow < 8) {
        if (grid[newRow][currentColPosition] == null) {
          moves.add([newRow, currentColPosition]);
        } else {
          break;
        }
      }
    }

    if (currentColPosition > 0) {
      int newRow = currentRowPosition + direction;
      int newCol = currentColPosition - 1;
      if (newRow >= 0 &&
          newRow < 8 &&
          grid[newRow][newCol] != null &&
          grid[newRow][newCol]?.isWhite != isWhite) {
        moves.add([newRow, newCol]);
      }
    }

    if (currentColPosition < 7) {
      int newRow = currentRowPosition + direction;
      int newCol = currentColPosition + 1;
      if (newRow >= 0 &&
          newRow < 8 &&
          grid[newRow][newCol] != null &&
          grid[newRow][newCol]?.isWhite != isWhite) {
        moves.add([newRow, newCol]);
      }
    }

    // En passant moves
    if (enPassantEligiblePawn != null) {
      if (isWhite && currentRowPosition == 3) {
        if (enPassantEligiblePawn.currentRowPosition == 3 &&
            (enPassantEligiblePawn.currentColPosition ==
                    currentColPosition - 1 ||
                enPassantEligiblePawn.currentColPosition ==
                    currentColPosition + 1)) {
          moves.add([2, enPassantEligiblePawn.currentColPosition]);
        }
      }

      if (!isWhite && currentRowPosition == 4) {
        if (enPassantEligiblePawn.currentRowPosition == 4 &&
            (enPassantEligiblePawn.currentColPosition ==
                    currentColPosition - 1 ||
                enPassantEligiblePawn.currentColPosition ==
                    currentColPosition + 1)) {
          moves.add([5, enPassantEligiblePawn.currentColPosition]);
        }
      }
    }

    return moves;
  }
}
