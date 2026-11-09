// ignore_for_file: no_leading_underscores_for_local_identifiers

// file: board.dart
//
// author: Peter Huňady (xhunadp00)
//
// date: 2024

import 'package:chess/navigationAndToasts.dart';
import 'package:chess/pieces/bishop.dart';
import 'package:chess/pieces/king.dart';
import 'package:chess/pieces/knight.dart';
import 'package:chess/pieces/pawn.dart';
import 'package:chess/pieces/piece.dart';
import 'package:chess/pieces/queen.dart';
import 'package:chess/pieces/rook.dart';
import 'package:chess/subpages/createMoves_page.dart';
import 'package:flutter/material.dart';

class Board {
  List<List<Piece?>> grid = List.generate(8, (_) => List.filled(8, null));
  Piece? selectedPiece;
  int? selectedRow, selectedCol;
  List<List<int>> possibleMoves = [];
  List<String> kickedWhitePieces = [], kickedBlackPieces = [];
  List listOfMoves = [], listOfFenCodes = [];
  bool isWhitePlaying = true, promotingPawn = false;
  bool whiteWon = false,
      blackWon = false,
      draw = false,
      stalemate = false,
      correctMove = true;
  String moveNotation = "";
  int moves = 0;

  Pawn? enPassantEligiblePawn;

  // Get number of kings on chess board
  int kingCount(isWhitePlaying) {
    int king = 0;

    for (int i = 0; i < 8; i++) {
      for (int j = 0; j < 8; j++) {
        Piece? piece = grid[i][j];
        if (piece is King && piece.isWhite == isWhitePlaying) {
          king++;
        }
      }
    }
    return king;
  }

  // Clear all pieces from the board
  void clearBoard() {
    setInitValues();
    for (int i = 0; i < 8; i++) {
      for (int j = 0; j < 8; j++) {
        Piece? piece = grid[i][j];
        if (piece != null) {
          grid[i][j] = null;
        }
      }
    }
  }

  // Set basic start position of pieces on the board
  void setupBoard() {
    clearBoard();
    // // stalemate
    // grid[0][0] = King(0, 0, false);
    // grid[7][4] = King(7, 4, true);
    // grid[7][2] = Queen(7, 2, true);

    // // promoting

    // grid[0][0] = King(0, 0, false);
    // grid[7][4] = King(7, 4, true);
    // grid[1][4] = Pawn(1, 4, true);
    // grid[6][2] = Pawn(6, 2, false);

    // Black pieces

    // King
    grid[0][4] = King(0, 4, false);

    // Queen
    grid[0][3] = Queen(0, 3, false);

    // Bishops
    grid[0][2] = Bishop(0, 2, false);
    grid[0][5] = Bishop(0, 5, false);

    // Knights
    grid[0][1] = Knight(0, 1, false);
    grid[0][6] = Knight(0, 6, false);

    // Rooks
    grid[0][0] = Rook(0, 0, false);
    grid[0][7] = Rook(0, 7, false);

    // Pawns
    for (int i = 0; i < 8; i++) {
      grid[1][i] = Pawn(1, i, false);
    }

    // White pieces

    // King
    grid[7][4] = King(7, 4, true);

    // Queen
    grid[7][3] = Queen(7, 3, true);

    // Bishops
    grid[7][2] = Bishop(7, 2, true);
    grid[7][5] = Bishop(7, 5, true);

    // Knights
    grid[7][1] = Knight(7, 1, true);
    grid[7][6] = Knight(7, 6, true);

    // Rooks
    grid[7][0] = Rook(7, 0, true);
    grid[7][7] = Rook(7, 7, true);

    // Pawns
    for (int i = 0; i < 8; i++) {
      grid[6][i] = Pawn(6, i, true);
    }
  }

  // Set init values before playing
  void setInitValues() {
    possibleMoves = [];

    isWhitePlaying = true;
    blackWon = false;
    whiteWon = false;
    stalemate = false;
    draw = false;
    promotingPawn = false;
    selectedRow = null;
    selectedCol = null;
  }

  // Check if chess board is valid (no checkmates, no draw...)
  void validChessBoard(
      BuildContext context,
      String nameOfPuzzle,
      String nameOfClass,
      String iconOfClass,
      String shortIdOfClass,
      String classId,
      String userId,
      bool isTeacher) {
    if (kingCount(isWhitePlaying) != 1 || kingCount(!isWhitePlaying) != 1) {
      showToast("Invalid number of kings on the board!");
      return;
    }

    if (isKingInCheckmate(isWhitePlaying) ||
        isKingInCheckmate(!isWhitePlaying)) {
      showToast("Checkmate! No possible moves.");
      return;
    }

    if (isKingInCheckForGrid(grid, !isWhitePlaying)) {
      showToast("Black king can't be in check!");
      return;
    }

    if (isStaleMate(grid, isWhitePlaying)) {
      showToast("Stalemate! No possible moves.");
      return;
    }

    if (checkIfPawnIsPromoting() != 0) {
      showToast("Pawn can't be at the promotion position!");
      return;
    }

    if (checkForDraw() != 0) {
      showToast("Draw! No possible moves to checkmate opponent.");
      return;
    }

    if (nameOfPuzzle.trim() == "") {
      showToast("Enter the name of the puzzle!");
      return;
    }

    // Get FEN code of starting position
    String fen = generateFEN();

    navigateScreenWithoutBackNavigation(
        context,
        CreateMovesPage(
          board: this,
          nameOfClass: nameOfClass,
          iconOfClass: iconOfClass,
          shortIdOfClass: shortIdOfClass,
          classId: classId,
          startingPosition: fen,
          nameOfPuzzle: nameOfPuzzle,
          userId: userId,
          isTeacher: isTeacher,
        ));
  }

  // Function to place pieces when creating starting position
  void placePiece(
      String clickedPiece, String colorOfClickedPiece, int row, int col) {
    bool whitePiece = colorOfClickedPiece == "white";

    switch (clickedPiece) {
      case "king":
        grid[row][col] = King(row, col, whitePiece);
        break;
      case "queen":
        grid[row][col] = Queen(row, col, whitePiece);
        break;
      case "rook":
        grid[row][col] = Rook(row, col, whitePiece);
        break;
      case "bishop":
        grid[row][col] = Bishop(row, col, whitePiece);
        break;
      case "knight":
        grid[row][col] = Knight(row, col, whitePiece);
        break;
      case "pawn":
        grid[row][col] = Pawn(row, col, whitePiece);
        break;
      case "x":
        grid[row][col] = null;
        break;
    }
  }

  // Check if piece was clicked
  bool pieceIsClicked(int row, int col) {
    selectedPiece = grid[row][col];

    if (selectedPiece != null) {
      if ((selectedPiece!.isWhite && isWhitePlaying) ||
          (!selectedPiece!.isWhite && !isWhitePlaying)) {
        selectedRow = row;
        selectedCol = col;
        return true;
      }
      return false;
    } else {
      return false;
    }
  }

  // Show all possible moves for the selected piece
  void possibleMovesOnSquares(int row, int col) {
    selectedPiece = grid[row][col];

    if ((selectedPiece!.isWhite && isWhitePlaying) ||
        (!selectedPiece!.isWhite && !isWhitePlaying)) {
      if (selectedPiece is King) {
        possibleMoves = (selectedPiece as King).possibleMoves(grid);
        possibleMoves = filterKingMoves(possibleMoves);
        addCastlingMoves(selectedPiece as King);
      } else if (selectedPiece is Pawn) {
        possibleMoves = (selectedPiece as Pawn)
            .possibleMoves(grid, enPassantEligiblePawn: enPassantEligiblePawn);
        possibleMoves = filterPinnedMoves(selectedPiece!, possibleMoves);
      } else {
        possibleMoves = selectedPiece!.possibleMoves(grid);
        possibleMoves = filterPinnedMoves(selectedPiece!, possibleMoves);
      }
    }
  }

  // Check if it is possible move
  bool isPossibleMove(int row, int col) {
    for (var move in possibleMoves) {
      if (move[0] == row && move[1] == col) {
        return true;
      }
    }
    return false;
  }

  // Game over after checkmate
  void checkForCheckmate() {
    bool isOpponentInCheckmate = isKingInCheckmate(!isWhitePlaying);

    if (isOpponentInCheckmate) {
      if (isWhitePlaying) {
        whiteWon = true;
      } else {
        blackWon = true;
      }
    }
  }

  // Check, if king is in a checkmate
  bool isKingInCheckmate(bool isWhiteKing) {
    int kingRow = -1;
    int kingCol = -1;

    for (int i = 0; i < 8; i++) {
      for (int j = 0; j < 8; j++) {
        Piece? piece = grid[i][j];
        if (piece != null && piece is King && piece.isWhite == isWhiteKing) {
          kingRow = i;
          kingCol = j;
          break;
        }
      }
      if (kingRow != -1) break;
    }

    if (kingRow == -1 || kingCol == -1) {
      return false;
    }

    if (!isKingInCheckForGrid(grid, isWhiteKing)) {
      return false;
    }

    List<List<int>> kingMoves = grid[kingRow][kingCol]!.possibleMoves(grid);

    for (var move in kingMoves) {
      List<List<Piece?>> tempGrid = List.generate(8, (i) => List.from(grid[i]));

      tempGrid[kingRow][kingCol] = null;
      tempGrid[move[0]][move[1]] = grid[kingRow][kingCol];

      if (!isKingInCheckForGrid(tempGrid, isWhiteKing)) {
        return false;
      }
    }

    for (int i = 0; i < 8; i++) {
      for (int j = 0; j < 8; j++) {
        Piece? piece = grid[i][j];
        if (piece != null && piece.isWhite == isWhiteKing) {
          List<List<int>> pieceMoves = piece.possibleMoves(grid);

          for (var move in pieceMoves) {
            List<List<Piece?>> tempGrid =
                List.generate(8, (i) => List.from(grid[i]));

            tempGrid[i][j] = null;
            tempGrid[move[0]][move[1]] = piece;

            if (!isKingInCheckForGrid(tempGrid, isWhiteKing)) {
              return false;
            }
          }
        }
      }
    }

    return true;
  }

  // Filter pinned moves from possible moves for selected piece
  List<List<int>> filterPinnedMoves(Piece piece, List<List<int>> moves) {
    List<List<int>> validMoves = [];

    for (var move in moves) {
      if (!isPinned(piece, move[0], move[1])) {
        validMoves.add(move);
      }
    }

    return validMoves;
  }

  // Filter king moves to ensure they do not result in check after the move
  List<List<int>> filterKingMoves(List<List<int>> moves) {
    List<List<int>> validMoves = [];

    for (var move in moves) {
      List<List<Piece?>> tempGrid = List.generate(8, (i) => List.from(grid[i]));

      tempGrid[selectedRow!][selectedCol!] = null;
      tempGrid[move[0]][move[1]] = selectedPiece;

      if (!isKingInCheckForGrid(tempGrid, selectedPiece!.isWhite)) {
        validMoves.add(move);
      }
    }

    return validMoves;
  }

  // Check if king is in a check
  bool isKingInCheckForGrid(List<List<Piece?>> grid, bool isWhiteKing) {
    int kingRow = -1;
    int kingCol = -1;

    for (int i = 0; i < 8; i++) {
      for (int j = 0; j < 8; j++) {
        Piece? piece = grid[i][j];
        if (piece != null && piece is King && piece.isWhite == isWhiteKing) {
          kingRow = i;
          kingCol = j;
          break;
        }
      }
    }

    for (int i = 0; i < 8; i++) {
      for (int j = 0; j < 8; j++) {
        Piece? opponentPiece = grid[i][j];
        if (opponentPiece != null && opponentPiece.isWhite != isWhiteKing) {
          List<List<int>> opponentMoves = opponentPiece.possibleMoves(grid);

          for (var move in opponentMoves) {
            if (move[0] == kingRow && move[1] == kingCol) {
              return true;
            }
          }
        }
      }
    }

    return false;
  }

  // Check if piece is pinned and can't be moved
  bool isPinned(Piece piece, int row, int col) {
    List<List<Piece?>> tempGrid = List.generate(8, (i) => List.from(grid[i]));

    tempGrid[piece.currentRowPosition][piece.currentColPosition] = null;
    tempGrid[row][col] = piece;

    return isKingInCheckForGrid(tempGrid, piece.isWhite);
  }

  // Add castling to possible moves (if it is possible)
  void addCastlingMoves(King king) {
    if (king.isWhite && !isWhitePlaying || !king.isWhite && isWhitePlaying) {
      return;
    }

    if (king.currentColPosition == 4) {
      if (king.isWhite) {
        if (grid[7][7] is Rook &&
            (grid[7][7] as Rook).isWhite &&
            !(grid[7][7] as Rook).hasMoved &&
            !king.hasMoved &&
            grid[7][5] == null &&
            grid[7][6] == null &&
            !isKingInCheckForGrid(grid, true)) {
          if (!isKingInCheckForGrid(tempGrid(7, 5), true) &&
              !isKingInCheckForGrid(tempGrid(7, 6), true)) {
            possibleMoves.add([7, 6]);
          }
        }

        if (grid[7][0] is Rook &&
            (grid[7][0] as Rook).isWhite &&
            !(grid[7][0] as Rook).hasMoved &&
            !king.hasMoved &&
            grid[7][1] == null &&
            grid[7][2] == null &&
            grid[7][3] == null &&
            !isKingInCheckForGrid(grid, true)) {
          if (!isKingInCheckForGrid(tempGrid(7, 2), true) &&
              !isKingInCheckForGrid(tempGrid(7, 3), true)) {
            possibleMoves.add([7, 2]);
          }
        }
      } else {
        if (grid[0][7] is Rook &&
            !(grid[0][7] as Rook).hasMoved &&
            !king.hasMoved &&
            grid[0][5] == null &&
            grid[0][6] == null &&
            !isKingInCheckForGrid(grid, false)) {
          if (!isKingInCheckForGrid(tempGrid(0, 5), false) &&
              !isKingInCheckForGrid(tempGrid(0, 6), false)) {
            possibleMoves.add([0, 6]);
          }
        }

        if (grid[0][0] is Rook &&
            !(grid[0][0] as Rook).hasMoved &&
            !king.hasMoved &&
            grid[0][1] == null &&
            grid[0][2] == null &&
            grid[0][3] == null &&
            !isKingInCheckForGrid(grid, false)) {
          if (!isKingInCheckForGrid(tempGrid(0, 2), false) &&
              !isKingInCheckForGrid(tempGrid(0, 3), false)) {
            possibleMoves.add([0, 2]);
          }
        }
      }
    }
  }

  // Create temporary grid of chessboard
  List<List<Piece?>> tempGrid(int row, int col) {
    List<List<Piece?>> tempGrid = List.generate(8, (i) => List.from(grid[i]));
    tempGrid[selectedRow!][selectedCol!] = null;
    tempGrid[row][col] = selectedPiece;
    return tempGrid;
  }

  // Generate FEN code of pieces on the board
  String generateFEN() {
    String fen = '';

    for (int row = 0; row < 8; row++) {
      int emptyCount = 0;
      for (int col = 0; col < 8; col++) {
        Piece? piece = grid[row][col];
        if (piece == null) {
          emptyCount++;
        } else {
          if (emptyCount > 0) {
            fen += emptyCount.toString();
            emptyCount = 0;
          }
          fen += piece.getFENChar();
        }
      }
      if (emptyCount > 0) {
        fen += emptyCount.toString();
      }
      if (row < 7) {
        fen += '/';
      }
    }

    fen += isWhitePlaying ? ' w ' : ' b ';

    String castling = '';

    if (grid[7][7] != null &&
        grid[7][4] != null &&
        !grid[7][7]!.hasMoved &&
        !grid[7][4]!.hasMoved) castling += 'K';
    if (grid[7][0] != null &&
        grid[7][4] != null &&
        !grid[7][0]!.hasMoved &&
        !grid[7][4]!.hasMoved) castling += 'Q';
    if (grid[0][7] != null &&
        grid[0][4] != null &&
        !grid[0][7]!.hasMoved &&
        !grid[0][4]!.hasMoved) castling += 'k';
    if (grid[0][0] != null &&
        grid[0][4] != null &&
        !grid[0][0]!.hasMoved &&
        !grid[0][4]!.hasMoved) castling += 'q';
    if (castling.isEmpty) castling = '-';
    fen += '$castling ';

    if (enPassantEligiblePawn != null) {
      int row = enPassantEligiblePawn!.isWhite
          ? enPassantEligiblePawn!.currentRowPosition - 1
          : enPassantEligiblePawn!.currentRowPosition + 1;
      fen +=
          String.fromCharCode(97 + enPassantEligiblePawn!.currentColPosition) +
              (row + 1).toString();
    } else {
      fen += '-';
    }

    fen += ' 0 ';

    int fullMoveNumber = 1;
    fen += fullMoveNumber.toString();

    return fen;
  }

  // Initialiaze and place pieces from FEN code
  void initializeBoardFromFEN(String fen) {
    clearBoard();
    List<String> fenParts = fen.split(' ');

    String boardSetup = fenParts[0];
    List<String> rows = boardSetup.split('/');

    for (int row = 0; row < 8; row++) {
      String rowData = rows[row];
      int col = 0;

      for (int i = 0; i < rowData.length; i++) {
        String char = rowData[i];

        if (int.tryParse(char) != null) {
          int emptySquares = int.parse(char);
          col += emptySquares;
        } else {
          bool isWhite = char.toUpperCase() == char;
          Piece piece;

          switch (char.toLowerCase()) {
            case 'p':
              piece = Pawn(row, col, isWhite);
              break;
            case 'r':
              piece = Rook(row, col, isWhite);
              break;
            case 'n':
              piece = Knight(row, col, isWhite);
              break;
            case 'b':
              piece = Bishop(row, col, isWhite);
              break;
            case 'q':
              piece = Queen(row, col, isWhite);
              break;
            case 'k':
              piece = King(row, col, isWhite);
              break;
            default:
              throw Exception('Unknown piece type: $char');
          }

          grid[row][col] = piece;
          col++;
        }
      }
    }

    String activeColor = fenParts[1];
    isWhitePlaying = activeColor == 'w';
  }

  // Get algebraic notation of move
  String getMoveNotation(int startRow, int startCol, int endRow, int endCol,
      Piece? piece, Piece? targetPiece) {
    String moveNotation = '';

    String destination = '${String.fromCharCode(97 + endCol)}${8 - endRow}';

    if (piece is King) {
      if (startCol == 4 && endCol == 6) {
        return 'O-O';
      }
      if (startCol == 4 && endCol == 2) {
        return 'O-O-O';
      }
    }

    if (targetPiece != null) {
      if (piece is Pawn) {
        moveNotation += '${String.fromCharCode(97 + startCol)}x$destination';
      } else {
        moveNotation += '${piece?.getFENChar().toUpperCase()}x$destination';
      }
    } else {
      if (piece is Pawn) {
        moveNotation += destination;
      } else {
        moveNotation += '${piece?.getFENChar().toUpperCase()}$destination';
      }
    }

    if (isKingInCheckForGrid(grid, !piece!.isWhite)) {
      if (isKingInCheckmate(isWhitePlaying)) {
        moveNotation += '#';
      } else {
        moveNotation += '+';
      }
    }

    return moveNotation;
  }

  // Move piece to a clicked box
  void movePiece(int endRow, int endCol) {
    if (selectedRow != null && selectedCol != null) {
      Piece? piece = grid[selectedRow!][selectedCol!];
      Piece? targetPiece = grid[endRow][endCol];

      if (piece != null &&
          ((piece.isWhite && isWhitePlaying) ||
              (!piece.isWhite && !isWhitePlaying)) &&
          isPossibleMove(endRow, endCol)) {
        // En passant move
        if (piece is Pawn && targetPiece == null && selectedCol != endCol) {
          int captureRow = piece.isWhite ? endRow + 1 : endRow - 1;
          grid[captureRow][endCol] = null;
        }

        if (piece is Pawn && (endRow - selectedRow!).abs() == 2) {
          enPassantEligiblePawn = piece;
        } else {
          enPassantEligiblePawn = null;
        }

        // Check for castling
        if (piece is King &&
            grid[7][7] is Rook &&
            (grid[7][7] as Rook).isWhite &&
            !(grid[7][7] as Rook).hasMoved &&
            !piece.hasMoved &&
            grid[7][5] == null &&
            grid[7][6] == null &&
            !isKingInCheckForGrid(grid, true) &&
            piece.currentColPosition + 2 == endCol &&
            piece.isWhite) {
          grid[7][7] = null;
          grid[7][5] = Rook(7, 5, true);
          grid[7][5]!.hasMoved = true;
        }

        if (piece is King &&
            grid[7][0] is Rook &&
            (grid[7][0] as Rook).isWhite &&
            !(grid[7][0] as Rook).hasMoved &&
            !piece.hasMoved &&
            grid[7][1] == null &&
            grid[7][2] == null &&
            grid[7][3] == null &&
            !isKingInCheckForGrid(grid, true) &&
            piece.currentColPosition - 2 == endCol &&
            piece.isWhite) {
          grid[7][0] = null;
          grid[7][3] = Rook(7, 3, true);
          grid[7][3]!.hasMoved = true;
        }

        if (piece is King &&
            grid[0][7] is Rook &&
            !(grid[0][7] as Rook).hasMoved &&
            !piece.hasMoved &&
            grid[0][5] == null &&
            grid[0][6] == null &&
            !isKingInCheckForGrid(grid, false) &&
            piece.currentColPosition + 2 == endCol &&
            !piece.isWhite) {
          grid[0][7] = null;
          grid[0][5] = Rook(0, 5, false);
          grid[0][5]!.hasMoved = true;
        }

        if (piece is King &&
            grid[0][0] is Rook &&
            !(grid[0][0] as Rook).hasMoved &&
            !piece.hasMoved &&
            grid[0][1] == null &&
            grid[0][2] == null &&
            grid[0][3] == null &&
            !isKingInCheckForGrid(grid, false) &&
            piece.currentColPosition - 2 == endCol &&
            !piece.isWhite) {
          grid[0][0] = null;
          grid[0][3] = Rook(0, 3, false);
          grid[0][3]!.hasMoved = true;
        }

        // Store kicked pieces
        if (grid[endRow][endCol] != null) {
          if (!isWhitePlaying) {
            if (grid[endRow][endCol] is Pawn) {
              kickedWhitePieces.add("Pawn");
            } else if (grid[endRow][endCol] is Bishop) {
              kickedWhitePieces.add("Bishop");
            } else if (grid[endRow][endCol] is Knight) {
              kickedWhitePieces.add("Knight");
            } else if (grid[endRow][endCol] is Rook) {
              kickedWhitePieces.add("Rook");
            } else if (grid[endRow][endCol] is Queen) {
              kickedWhitePieces.add("Queen");
            }
          } else {
            if (grid[endRow][endCol] is Pawn) {
              kickedBlackPieces.add("Pawn");
            } else if (grid[endRow][endCol] is Bishop) {
              kickedBlackPieces.add("Bishop");
            } else if (grid[endRow][endCol] is Knight) {
              kickedBlackPieces.add("Knight");
            } else if (grid[endRow][endCol] is Rook) {
              kickedBlackPieces.add("Rook");
            } else if (grid[endRow][endCol] is Queen) {
              kickedBlackPieces.add("Queen");
            }
          }
        }

        // Move piece to a clicked box
        grid[endRow][endCol] = piece;
        grid[selectedRow!][selectedCol!] = null;
        piece.moveTo(endRow, endCol);

        moveNotation = getMoveNotation(
            selectedRow!, selectedCol!, endRow, endCol, piece, targetPiece);

        // Check for stalemate
        if (isStaleMate(grid, !piece.isWhite)) {
          stalemate = true;
        }

        // Check for draw
        if (checkForDraw() == 1) {
          draw = true;
        }

        if (piece is Pawn &&
            ((endRow == 0 && isWhitePlaying) ||
                (endRow == 7 && !isWhitePlaying))) {
          promotingPawn = true;

          return;
        } else {
          listOfMoves.add(moveNotation);

          checkForCheckmate();

          isWhitePlaying = !isWhitePlaying;
          selectedRow = null;
          selectedCol = null;

          listOfFenCodes.add(generateFEN());
          moves++;
        }
      }
    }
  }

  int checkIfPawnIsPromoting() {
    for (int i = 0; i < 8; i++) {
      Piece? piece = grid[0][i];
      Piece? blackPiece = grid[7][i];
      if (piece is Pawn || blackPiece is Pawn) {
        return 1;
      }
    }
    return 0;
  }

  int checkForDraw() {
    int whitePieces = 0;
    int blackPieces = 0;

    for (int i = 0; i < 8; i++) {
      for (int j = 0; j < 8; j++) {
        Piece? piece = grid[i][j];
        if (piece != null) {
          if (piece.isWhite) {
            whitePieces++;
          } else {
            blackPieces++;
          }
        }
      }
    }

    if (whitePieces == 1 && blackPieces == 1) {
      return 1;
    }

    if (whitePieces == 2 &&
        blackPieces == 1 &&
        grid.any((row) => row.any((p) => p is Bishop && p.isWhite))) {
      return 1;
    }

    if (whitePieces == 1 &&
        blackPieces == 2 &&
        grid.any((row) => row.any((p) => p is Bishop && !p.isWhite))) {
      return 1;
    }

    if (whitePieces == 2 &&
        blackPieces == 1 &&
        grid.any((row) => row.any((p) => p is Knight && p.isWhite))) {
      return 1;
    }

    if (whitePieces == 1 &&
        blackPieces == 2 &&
        grid.any((row) => row.any((p) => p is Knight && !p.isWhite))) {
      return 1;
    }

    if (whitePieces == 2 && blackPieces == 2) {
      bool whiteBishopOnDark = grid.any((row) => row.any((p) =>
          p is Bishop &&
          p.isWhite &&
          (row.indexOf(p) + grid.indexOf(row)) % 2 == 1));
      bool blackBishopOnDark = grid.any((row) => row.any((p) =>
          p is Bishop &&
          !p.isWhite &&
          (row.indexOf(p) + grid.indexOf(row)) % 2 == 1));
      bool whiteBishopOnLight = grid.any((row) => row.any((p) =>
          p is Bishop &&
          p.isWhite &&
          (row.indexOf(p) + grid.indexOf(row)) % 2 == 0));
      bool blackBishopOnLight = grid.any((row) => row.any((p) =>
          p is Bishop &&
          !p.isWhite &&
          (row.indexOf(p) + grid.indexOf(row)) % 2 == 0));

      if ((whiteBishopOnDark && blackBishopOnDark) ||
          (whiteBishopOnLight && blackBishopOnLight)) {
        return 1;
      }
    }

    return 0;
  }

  // Promote pawn to a clicked piece
  void promotePawn(String nameOfPiece) {
    int promoteRow = -1, promoteCol = -1;
    for (var i = 0; i < 8; i++) {
      for (var j = 0; j < 8; j++) {
        if (grid[i][j] is Pawn && (i == 0 || i == 7)) {
          promoteCol = j;
          promoteRow = i;
          promotingPawn = false;
        }
      }
    }

    if (promoteRow != -1 && promoteCol != -1) {
      if (nameOfPiece == "Queen") {
        if (isWhitePlaying) {
          grid[promoteRow][promoteCol] = null;
          grid[promoteRow][promoteCol] = Queen(promoteRow, promoteCol, true);
        } else {
          grid[promoteRow][promoteCol] = null;
          grid[promoteRow][promoteCol] = Queen(promoteRow, promoteCol, false);
        }
      } else if (nameOfPiece == "Knight") {
        if (isWhitePlaying) {
          grid[promoteRow][promoteCol] = null;
          grid[promoteRow][promoteCol] = Knight(promoteRow, promoteCol, true);
        } else {
          grid[promoteRow][promoteCol] = null;
          grid[promoteRow][promoteCol] = Knight(promoteRow, promoteCol, false);
        }
      } else if (nameOfPiece == "Rook") {
        if (isWhitePlaying) {
          grid[promoteRow][promoteCol] = null;
          grid[promoteRow][promoteCol] = Rook(promoteRow, promoteCol, true);
        } else {
          grid[promoteRow][promoteCol] = null;
          grid[promoteRow][promoteCol] = Rook(promoteRow, promoteCol, false);
        }
      } else if (nameOfPiece == "Bishop") {
        if (isWhitePlaying) {
          grid[promoteRow][promoteCol] = null;
          grid[promoteRow][promoteCol] = Bishop(promoteRow, promoteCol, true);
        } else {
          grid[promoteRow][promoteCol] = null;
          grid[promoteRow][promoteCol] = Bishop(promoteRow, promoteCol, false);
        }
      }
    }

    moveNotation += "=${nameOfPiece[0]}";
    listOfMoves.add(moveNotation);
    listOfFenCodes.add(generateFEN());

    moves++;
    isWhitePlaying = !isWhitePlaying;
  }

  // Check for stalemate
  bool isStaleMate(List<List<Piece?>> grid, bool isWhiteKing) {
    bool kingInCheck = isKingInCheckForGrid(grid, isWhiteKing);

    if (kingInCheck) {
      return false;
    }

    for (int i = 0; i < 8; i++) {
      for (int j = 0; j < 8; j++) {
        Piece? piece = grid[i][j];
        if (piece != null && piece.isWhite == isWhiteKing) {
          List<List<int>> moves = piece.possibleMoves(grid);

          for (var move in moves) {
            List<List<Piece?>> tempGrid =
                List.generate(8, (k) => List.from(grid[k]));

            tempGrid[i][j] = null;
            tempGrid[move[0]][move[1]] = piece;

            if (!isKingInCheckForGrid(tempGrid, isWhiteKing)) {
              return false;
            }
          }
        }
      }
    }

    return true;
  }

  // Check if move is correct
  void onMove(int moveCount, List listOfCorrectFenCodes,
      List listOfCorrectMoves, _timer) {
    if (listOfFenCodes.isNotEmpty && moveCount != moves && !isWhitePlaying) {
      if (listOfFenCodes.length - 1 != listOfCorrectFenCodes.length) {
        if (listOfMoves.last == listOfCorrectMoves[moves - 1] &&
            moves <= listOfCorrectFenCodes.length) {
          if (moves == listOfCorrectFenCodes.length) {
            listOfFenCodes.add(listOfCorrectFenCodes[moves - 1]);

            initializeBoardFromFEN(listOfCorrectFenCodes[moves - 1]);
          } else {
            listOfFenCodes.add(listOfCorrectFenCodes[moves]);
            listOfMoves.add(listOfCorrectMoves[moves]);
            initializeBoardFromFEN(listOfCorrectFenCodes[moves]);
          }
          correctMove = true;
        } else {
          correctMove = false;
          blackWon = true;

          _timer!.cancel();

          return;
        }

        moves++;
        moveCount = moves;

        if (moves >= listOfCorrectFenCodes.length) {
          whiteWon = true;
          _timer!.cancel();
          return;
        }
      }
    }
  }

  bool isCorrectMove() {
    return correctMove;
  }

  // Restart puzzle and initialize board from starting FEN code
  void restartPuzzle(String startingFenCode) {
    initializeBoardFromFEN(startingFenCode);
    listOfFenCodes = [];
    listOfMoves = [];
    moves = 0;
  }

  // Reset every recorded move
  void resetBoardMoves(String startingFenCode) {
    setInitValues();
    moves = 0;

    initializeBoardFromFEN(startingFenCode);
    listOfFenCodes = [];
    listOfMoves = [];
  }

  // Step back while recording moves
  void stepBackBoard(String startingFenCode) {
    if (listOfFenCodes.isNotEmpty) {
      setInitValues();
      listOfFenCodes.removeLast();
      if (listOfFenCodes.isNotEmpty) {
        initializeBoardFromFEN(listOfFenCodes.last);
      } else {
        initializeBoardFromFEN(startingFenCode);
      }

      listOfMoves.removeLast();
    } else {
      setInitValues();
      initializeBoardFromFEN(startingFenCode);
      moves = 0;
      listOfFenCodes = [];
      listOfMoves = [];
    }
  }
}
