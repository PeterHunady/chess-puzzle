// ignore_for_file: file_names

// file: customPuzzlePreviewCard_widget.dart
//
// author: Peter Huňady (xkaletk00)
//
// date: 2024

import 'package:chess/customWidgets/customBoxWithText_widget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

// Puzzle card with statistics on the right side.
class CustomPuzzlePreviewCard extends StatelessWidget {
  final String puzzleTitle;
  final String imageUrl;
  final String solvedBy;
  final String averageTime;
  final String averageAttempts;
  final bool solvedByUser;
  final VoidCallback function;
  final String text1Box;
  final String text2Box;
  final String text3Box;

  const CustomPuzzlePreviewCard({
    super.key,
    required this.puzzleTitle,
    required this.imageUrl,
    required this.solvedBy,
    required this.averageTime,
    required this.averageAttempts,
    required this.solvedByUser,
    required this.function,
    this.text1Box = "Solved by",
    this.text2Box = "Average time",
    this.text3Box = "Average attempts",
  });

  @override
  Widget build(BuildContext context) {
    Color whiteColor = const Color.fromARGB(255, 235, 227, 208);

    return GestureDetector(
      onTap: function,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              puzzleTitle,
              style: GoogleFonts.openSans(
                color: whiteColor,
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
            Row(
              children: [
                // Image from database of puzzle preview
                Expanded(
                  child: Stack(alignment: Alignment.center, children: [
                    SizedBox(
                      child: Image.network(
                        imageUrl,
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                    // If solved, show check icon
                    solvedByUser
                        ? const Icon(
                            FontAwesomeIcons.check,
                            color: Colors.green,
                            size: 80,
                          )
                        : Container(),
                  ]),
                ),
                const SizedBox(width: 10),
                Expanded(
                  // Boxes for statistics (solved by, average time, average attempts)
                  child: IntrinsicWidth(
                    child: Column(
                      children: [
                        CustomBoxWithText(
                            topText: text1Box, bottomText: solvedBy),
                        CustomBoxWithText(
                            topText: text2Box, bottomText: averageTime),
                        CustomBoxWithText(
                            topText: text3Box, bottomText: averageAttempts),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
