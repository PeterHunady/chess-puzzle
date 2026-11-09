// ignore_for_file: file_names

// file: customButton_widget.dart
//
// author: Peter Huňady (xhunadp00)
//
// date: 2024

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Reusable button widget with custom padding, border and bakcground color
class CustomButton extends StatelessWidget {
  final double paddingHorizontal;
  final double paddingVertical;
  final Color backgroundColorOfBtn;
  final Color borderColorOfBtn;
  final String textOfBtn;
  final VoidCallback function;

  const CustomButton({
    super.key,
    required this.paddingHorizontal,
    required this.paddingVertical,
    required this.backgroundColorOfBtn,
    required this.borderColorOfBtn,
    required this.textOfBtn,
    required this.function,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: paddingHorizontal,
        vertical: paddingVertical,
      ),
      child: GestureDetector(
        onTap: function,
        child: Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: backgroundColorOfBtn,
            border: Border.all(color: borderColorOfBtn, width: 1),
            borderRadius: const BorderRadius.all(Radius.circular(5)),
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Text(
                textOfBtn,
                style: GoogleFonts.openSans(
                  color: const Color.fromARGB(255, 235, 227, 208),
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
