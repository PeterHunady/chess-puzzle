// ignore_for_file: file_names, non_constant_identifier_names

// file: userClassesGrid_widget.dart
//
// author: Peter Huňady (xhunadp00)
//
// date: 2024

import 'package:chess/controller/classUser_controller.dart';
import 'package:chess/controller/class_controller.dart';
import 'package:chess/models/class_model.dart';
import 'package:chess/navigationAndToasts.dart';
import 'package:chess/subpages/classHome_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

// List of all classes of user
class UserClassesGrid extends StatelessWidget {
  final String userId;
  final String getCurrentUserId;
  final ClassController classController;
  final ClassUsersController classUsersController;

  const UserClassesGrid({
    super.key,
    required this.userId,
    required this.getCurrentUserId,
    required this.classController,
    required this.classUsersController,
  });

  final Color whiteColor = const Color.fromARGB(255, 235, 227, 208);

  // Display each class of user
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return GridView.count(
        crossAxisCount: 1,
        childAspectRatio: 8,
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        padding: const EdgeInsets.all(0),
        mainAxisSpacing: 0,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisSpacing: 0,
        children: classController.classes
            .where((element) => classUsersController.classUsers.any(
                (classUser) =>
                    classUser.classId == element.id &&
                    classUser.userId == getCurrentUserId))
            .map((Classes classInfo) {
          return ClassItem(
            classInfo.name,
            classInfo.iconName,
            classInfo.id,
            () => navigateScreen(
                context,
                ClassHomePage(
                  userId: userId,
                  isTeacher: classUsersController.getCurrentUserRole(
                      userId, classInfo.id),
                )),
          );
        }).toList(),
      );
    });
  }

  // One item (class) in list
  Widget ClassItem(
      String text, String iconName, String id, VoidCallback function) {
    return GestureDetector(
      onTap: () async {
        SharedPreferences preferences = await SharedPreferences.getInstance();
        preferences.setString('classId', id);

        function();
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 13, 20, 13),
        child: Row(
          children: [
            // Icon of the class
            Padding(
              padding: const EdgeInsets.only(right: 15),
              child: Image.asset(
                "assets/images/${iconName.toLowerCase()}_black.png",
                width: 25,
              ),
            ),
            Text(
              text,
              style: GoogleFonts.openSans(
                  color: whiteColor, fontSize: 16, fontWeight: FontWeight.w600),
            )
          ],
        ),
      ),
    );
  }
}
