// ignore_for_file: file_names

// file: customRoundedIcon_widget.dart
//
// author: Peter Huňady (xhunadp00)
//
// date: 2024

import 'package:flutter/material.dart';

// Rounded icon widget
class CustomRoundedIcon extends StatelessWidget {
  final Icon icon;
  final Color colorOfBorder;
  final bool clickedPiece;

  const CustomRoundedIcon({
    super.key,
    required this.icon,
    required this.colorOfBorder,
    required this.clickedPiece,
  });

  @override
  Widget build(BuildContext context) {
    Color grayColor = const Color.fromARGB(255, 121, 121, 121);

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: clickedPiece ? grayColor : Colors.transparent,
        border: Border.all(width: 1, color: colorOfBorder),
        borderRadius: const BorderRadius.all(Radius.circular(50)),
      ),
      child: icon,
    );
  }
}
