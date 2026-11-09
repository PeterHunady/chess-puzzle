// ignore_for_file: file_names

// file: customDefaultNavbar_widget.dart
//
// author: Peter Huňady (xhunadp00)
//
// date: 2024

import 'package:flutter/material.dart';

// Navbar widget with ChessUp Icon
class CustomDefaultNavbar extends StatelessWidget {
  final VoidCallback function;
  final bool visible;

  const CustomDefaultNavbar({
    super.key,
    required this.function,
    required this.visible,
  });

  @override
  Widget build(BuildContext context) {
    return visible
        ? Row(
            children: [
              // BackButton for step back
              Expanded(
                flex: 1,
                child: BackButton(
                  color: const Color.fromARGB(255, 235, 227, 208),
                  onPressed: function,
                ),
              ),
              // Straight line horizontal divider
              const Expanded(
                flex: 2,
                child: Divider(
                  color: Color.fromARGB(255, 235, 227, 208),
                  thickness: 1,
                ),
              ),
              // Image of an icon
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 0),
                  child: Align(
                    alignment: Alignment.center,
                    child: Image.asset(
                      "assets/images/chessUpLogo.png",
                      width: 38,
                    ),
                  ),
                ),
              ),
              // Straight line horizontal divider
              const Expanded(
                flex: 3,
                child: Divider(
                  color: Color.fromARGB(255, 235, 227, 208),
                  thickness: 1,
                  endIndent: 8,
                ),
              ),
            ],
          )
        : Row(
            children: [
              // Straight line horizontal divider
              const Expanded(
                flex: 2,
                child: Divider(
                  color: Color.fromARGB(255, 235, 227, 208),
                  thickness: 1,
                ),
              ),
              // Image of an icon
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Align(
                    alignment: Alignment.center,
                    child: Image.asset(
                      "assets/images/chessUpLogo.png",
                      width: 38,
                    ),
                  ),
                ),
              ),
              // Straight line horizontal divider
              const Expanded(
                flex: 2,
                child: Divider(
                  color: Color.fromARGB(255, 235, 227, 208),
                  thickness: 1,
                ),
              ),
            ],
          );
  }
}
