// ignore_for_file: file_names

// file: customFooter_widget.dart
//
// author: Peter Huňady (xhunadp00)
//
// date: 2024

import 'package:chess/controller/classUser_controller.dart';
import 'package:chess/navigationAndToasts.dart';
import 'package:chess/subpages/home_page.dart';
import 'package:chess/subpages/menu_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

// Footer with item (home, class, menu) to navigate to another subpage
class CustomFooter extends StatelessWidget {
  final String userId;
  const CustomFooter({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    final ClassUsersController classUsersController =
        Get.put(ClassUsersController());
    return Column(
      children: [
        const Row(
          children: [
            Expanded(
              child: Divider(
                color: Color.fromARGB(255, 235, 227, 208),
                thickness: 1.5,
              ),
            ),
          ],
        ),
        // Items in footer
        Padding(
          padding: const EdgeInsets.fromLTRB(35, 5, 35, 0),
          child: Row(
            children: [
              footerItem(
                  "Home", () => navigateScreen(context, const HomePage())),
              Expanded(child: Container()),
              footerItem(
                  "Class",
                  () => classUsersController.navigateUserToClass(
                      context, userId, false)),
              Expanded(child: Container()),
              footerItem(
                  "Menu", () => navigateScreen(context, const MenuPage())),
            ],
          ),
        )
      ],
    );
  }

  // Navigate to another subpage
  Widget footerItem(
    String text,
    VoidCallback function,
  ) {
    return GestureDetector(
      onTap: function,
      child: Text(
        text,
        style: GoogleFonts.openSans(
            fontSize: 13,
            color: const Color.fromARGB(255, 235, 227, 208),
            fontWeight: FontWeight.w600),
      ),
    );
  }
}
