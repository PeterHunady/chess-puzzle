// ignore_for_file: file_names

// file: customClassNavbar_widget.dart
//
// author: Peter Huňady (xhunadp00)
//
// date: 2024

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Navbar widget with class icon and name
class CustomClassNavbar extends StatelessWidget {
  final String nameOfClass;
  final String idOfClass;
  final String iconPieceName;
  final bool visible;
  final VoidCallback function;

  const CustomClassNavbar({
    required this.nameOfClass,
    required this.idOfClass,
    required this.iconPieceName,
    required this.visible,
    required this.function,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    Color whiteColor = const Color.fromARGB(255, 235, 227, 208);
    Color grayColor = const Color.fromARGB(255, 121, 121, 121);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Backbutton to step back
        if (visible)
          Flexible(
            flex: 1,
            fit: FlexFit.loose,
            child: BackButton(
              color: whiteColor,
              onPressed: function,
            ),
          ),
        // Straight line horizontal divider
        Flexible(
          flex: visible ? 2 : 3,
          fit: FlexFit.loose,
          child: Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Divider(
              color: whiteColor,
              thickness: 1,
            ),
          ),
        ),
        // Icon, name and short id of class
        Flexible(
          flex: 3,
          fit: FlexFit.loose,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    border: Border.all(width: 1, color: whiteColor),
                    borderRadius: const BorderRadius.all(Radius.circular(50)),
                  ),
                  child: iconOfPiece(iconPieceName),
                ),
                const SizedBox(width: 8),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Name of the class
                      Text(
                        nameOfClass,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.openSans(
                          fontSize: 12,
                          color: whiteColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      // Short id of the class
                      Text(
                        idOfClass,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.openSans(
                          fontSize: 12,
                          color: grayColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        // Straight line horizontal divider
        Flexible(
          flex: 3,
          fit: FlexFit.loose,
          child: Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Divider(
              color: whiteColor,
              thickness: 1,
            ),
          ),
        ),
      ],
    );
  }

  // Load an image of icon of class
  Widget iconOfPiece(String iconPiece) {
    switch (iconPiece) {
      case "King":
        return Image.asset("assets/images/king_black.png", width: 20);
      case "Queen":
        return Image.asset("assets/images/queen_black.png", width: 20);
      case "Rook":
        return Image.asset("assets/images/rook_black.png", width: 20);
      case "Bishop":
        return Image.asset("assets/images/bishop_black.png", width: 20);
      case "Knight":
        return Image.asset("assets/images/knight_black.png", width: 20);
      default:
        return Image.asset("assets/images/pawn_black.png", width: 20);
    }
  }
}
