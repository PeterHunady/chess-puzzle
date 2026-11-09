// ignore_for_file: file_names

// file: customButtonWithIcon_widget.dart
//
// author: Peter Huňady (xhunadp00)
//
// date: 2024

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Button with icon widget
class CustomButtonWithIcon extends StatelessWidget {
  final String text;
  final IconData icon;
  final double size;
  final double rightPadding;
  final VoidCallback function;

  const CustomButtonWithIcon({
    super.key,
    required this.text,
    required this.icon,
    required this.size,
    required this.rightPadding,
    required this.function,
  });

  @override
  Widget build(BuildContext context) {
    Color whiteColor = const Color.fromARGB(255, 235, 227, 208);

    return GestureDetector(
      onTap: function,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(color: whiteColor, width: 1),
          borderRadius: const BorderRadius.all(Radius.circular(5)),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          child: Row(
            children: [
              Padding(
                padding: EdgeInsets.only(right: rightPadding),
                child: Text(
                  text,
                  style: GoogleFonts.openSans(
                    color: const Color.fromARGB(255, 235, 227, 208),
                    fontSize: size,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              Icon(icon, color: whiteColor, size: size + 2)
            ],
          ),
        ),
      ),
    );
  }
}
