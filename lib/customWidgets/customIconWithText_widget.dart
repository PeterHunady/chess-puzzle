// ignore_for_file: file_names

// file: customIconWithText_widget.dart
//
// author: Peter Huňady (xhunadp00)
//
// date: 2024

import 'package:chess/customWidgets/customRoundedIcon_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';

// Icon widget in circle with text next to it
class CustomRoundedIconWithText extends StatelessWidget {
  final String text;
  final String smallText;
  final Icon mainIcon;
  final double sizeOfText;
  final double sizeOfIcon;
  final Icon firstIcon;
  final Color firstIconBorderColor;
  final Icon? secondIcon;
  final Color? secondIconBorderColor;
  final VoidCallback function1;
  final VoidCallback function2;

  const CustomRoundedIconWithText(
      {super.key,
      required this.text,
      required this.smallText,
      required this.mainIcon,
      required this.sizeOfText,
      required this.sizeOfIcon,
      required this.firstIcon,
      required this.firstIconBorderColor,
      required this.secondIcon,
      required this.secondIconBorderColor,
      required this.function1,
      required this.function2});

  @override
  Widget build(BuildContext context) {
    Color whiteColor = const Color.fromARGB(255, 235, 227, 208);
    Color grayColor = const Color.fromARGB(255, 121, 121, 121);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: CustomRoundedIcon(
                icon: mainIcon, colorOfBorder: whiteColor, clickedPiece: false),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                text,
                style: GoogleFonts.openSans(
                  color: whiteColor,
                  fontSize: sizeOfText,
                  fontWeight: FontWeight.w400,
                ),
              ),
              Text(
                smallText,
                style: GoogleFonts.openSans(
                  color: grayColor,
                  fontSize: sizeOfText - 6,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
          Expanded(child: Container()),
          GestureDetector(
            onTap: function1,
            child: CustomRoundedIcon(
              icon: firstIcon,
              colorOfBorder: firstIconBorderColor,
              clickedPiece: false,
            ),
          ),
          if (secondIcon != null) ...[
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: GestureDetector(
                onTap: function2,
                child: CustomRoundedIcon(
                  icon: secondIcon!,
                  colorOfBorder: secondIconBorderColor!,
                  clickedPiece: false,
                ),
              ),
            ),
          ]
        ],
      ),
    );
  }
}
