// ignore_for_file: non_constant_identifier_names, file_names

// file: navigationAndToasts.dart
//
// author: Peter Huňady (xhunadp00)
//
// date: 2024

import 'package:chess/customWidgets/customButton_widget.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

// Navigate to screen with option to step back
void navigateScreen(BuildContext context, Widget page) {
  Navigator.of(context).push(MaterialPageRoute(builder: (_) => page));
}

// Navigate to screen witthout option to step back
void navigateScreenWithoutBackNavigation(BuildContext context, Widget page) {
  Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => page), (Route<dynamic> route) => false);
}

// Show dialog with custom content
void showCustomDialog(BuildContext context, String title, Column column) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
          backgroundColor: Colors.black,
          surfaceTintColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
            side: const BorderSide(
              color: Color.fromARGB(255, 235, 227, 208),
              width: 1.5,
            ),
          ),
          title: title == ""
              ? Container()
              : Text(
                  title,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.openSans(
                      color: const Color.fromARGB(255, 235, 227, 208),
                      fontWeight: FontWeight.w400),
                ),
          contentPadding: const EdgeInsets.fromLTRB(10, 30, 10, 20),
          content: Container(child: column));
    },
  );
}

// Show toast custom message
void showToast(String text) {
  Fluttertoast.showToast(
      msg: text,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      webPosition: "center",
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.white,
      textColor: Colors.black,
      fontSize: 16.0);
}

// Show dialog without custom content
void showDialogWithoutContent(BuildContext context, String title,
    String textOfButton, VoidCallback function, Color color) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
          backgroundColor: Colors.black,
          surfaceTintColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
            side: const BorderSide(
              color: Color.fromARGB(255, 235, 227, 208),
              width: 1.5,
            ),
          ),
          title: title == ""
              ? Container()
              : Text(
                  title,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.openSans(
                      color: const Color.fromARGB(255, 235, 227, 208),
                      fontWeight: FontWeight.w400),
                ),
          contentPadding: const EdgeInsets.fromLTRB(10, 30, 10, 20),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Button - action with custom function
              CustomButton(
                  paddingHorizontal: 10,
                  paddingVertical: 20,
                  backgroundColorOfBtn: color,
                  borderColorOfBtn: Colors.transparent,
                  textOfBtn: textOfButton,
                  function: function)
            ],
          ));
    },
  );
}
