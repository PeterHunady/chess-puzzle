// file: piece.dart
//
// author: Peter Huňady (xhunadp00)
//
// date: 2024

import 'package:flutter/material.dart';

abstract class Piece {
  int currentRowPosition;
  int currentColPosition;
  bool isWhite;
  bool hasMoved;

  Piece(this.currentRowPosition, this.currentColPosition, this.isWhite,
      {this.hasMoved = false});

  Widget build() {
    throw UnimplementedError();
  }

  // Get FEN code of positions from chess board pieces
  String getFENChar();

  // List of all possible moves for the clicked piece
  List<List<int>> possibleMoves(List<List<Piece?>> grid);

  // Move a piece to new row and column
  void moveTo(int newRow, int newCol) {
    currentRowPosition = newRow;
    currentColPosition = newCol;
    hasMoved = true;
  }
}
