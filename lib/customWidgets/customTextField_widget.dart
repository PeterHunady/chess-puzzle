// ignore_for_file: file_names

// file: customTextField_widget.dart
//
// author: Peter Huňady (xhunadp00)
//
// date: 2024

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Text field for inputs widget
class CustomTextField extends StatelessWidget {
  final String text;
  final String labelText;
  final TextEditingController controller;
  final double left;
  final double top;
  final double right;
  final double bottom;
  final bool isPassword;
  final ValueChanged<String>? onChanged;

  const CustomTextField({
    super.key,
    required this.text,
    required this.labelText,
    required this.controller,
    required this.left,
    required this.top,
    required this.right,
    required this.bottom,
    this.isPassword = false,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(left, top, right, bottom),
      child: TextField(
        onChanged: onChanged,
        controller: controller,
        keyboardType: TextInputType.emailAddress,
        cursorColor: Colors.white,
        obscureText: isPassword,
        enableSuggestions: !isPassword,
        autocorrect: !isPassword,
        style: GoogleFonts.openSans(
          color: const Color.fromARGB(255, 235, 227, 208),
          fontSize: 16,
        ),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.fromLTRB(15, 18, 15, 18),
          labelText: text,
          labelStyle:
              const TextStyle(color: Color.fromARGB(255, 121, 121, 121)),
          hintText: labelText,
          hintStyle: const TextStyle(color: Color.fromARGB(255, 121, 121, 121)),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          enabledBorder: OutlineInputBorder(
            borderSide:
                const BorderSide(color: Color.fromARGB(255, 121, 121, 121)),
            borderRadius: BorderRadius.circular(6),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide:
                const BorderSide(color: Color.fromARGB(255, 235, 227, 208)),
            borderRadius: BorderRadius.circular(6),
          ),
        ),
      ),
    );
  }
}
