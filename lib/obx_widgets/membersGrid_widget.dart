// ignore_for_file: non_constant_identifier_names, file_names

// file: membersGrid_widget.dart
//
// author: Peter Huňady (xhunadp00)
//
// date: 2024

import 'package:chess/controller/classUser_controller.dart';
import 'package:chess/controller/class_controller.dart';
import 'package:chess/controller/user_controller.dart';
import 'package:chess/customWidgets/customIconWithText_widget.dart';
import 'package:chess/navigationAndToasts.dart';
import 'package:chess/subpages/memberStatistic_page.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:remove_diacritic/remove_diacritic.dart';

// List of all members in the class
class MembersGrid extends StatelessWidget {
  final BuildContext context;
  final String classId;
  final String currentUserId;
  final ClassController classController;
  final ClassUsersController classUsersController;
  final UserController userController;
  final String name;

  const MembersGrid({
    super.key,
    required this.context,
    required this.classId,
    required this.currentUserId,
    required this.classController,
    required this.classUsersController,
    required this.userController,
    required this.name,
  });

  final Color whiteColor = const Color.fromARGB(255, 235, 227, 208);
  final Color grayColor = const Color.fromARGB(255, 121, 121, 121);
  final Color blueColor = const Color.fromARGB(255, 52, 95, 178);
  final Color redColor = const Color.fromARGB(255, 178, 52, 52);

  @override
  Widget build(BuildContext context) {
    // Display all members in class
    return Obx(() {
      return GridView.count(
        crossAxisCount: 1,
        childAspectRatio: 8,
        scrollDirection: Axis.vertical,
        padding: const EdgeInsets.all(0),
        mainAxisSpacing: 10,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisSpacing: 0,
        shrinkWrap: true,
        children: classUsersController.classUsers
            .where((element) =>
                element.classId == classId &&
                userController.users.any((user) {
                  final normalizedSearch = removeDiacritics(name.toLowerCase());

                  final userLastName =
                      removeDiacritics(user.name.split(" ").last.toLowerCase());
                  final userName = removeDiacritics(user.name.toLowerCase());

                  return user.id == element.userId &&
                      (userLastName.startsWith(normalizedSearch) ||
                          userName.startsWith(normalizedSearch));
                }))
            .map((classUsersInfo) => MembersItem(
                userId: classUsersInfo.userId,
                isTeacher: classUsersInfo.isTeacher,
                isCurrentUserTeacher: classUsersController.getCurrentUserRole(
                    currentUserId, classId)))
            .toList(),
      );
    });
  }

  // One item (member) in list
  Widget MembersItem(
      {required String userId,
      required bool isTeacher,
      required bool isCurrentUserTeacher}) {
    return GestureDetector(
      onTap: () {
        navigateScreenWithoutBackNavigation(
            context,
            MemberStatisticsPage(
                currentUserId: currentUserId,
                userId: userId,
                classId: classId,
                isTeacher: isTeacher));
      },
      child: CustomRoundedIconWithText(
        text: userController.getCurrentUserName(userId),
        smallText: userController.getCurrentUserShortId(userId),
        mainIcon: Icon(
          isTeacher ? FontAwesomeIcons.crown : Icons.person_2_outlined,
          color: whiteColor,
          size: 25,
        ),
        sizeOfText: 18,
        sizeOfIcon: 14,
        firstIcon: isCurrentUserTeacher
            ? Icon(
                isTeacher
                    ? FontAwesomeIcons.angleDown
                    : FontAwesomeIcons.angleUp,
                color: whiteColor,
                size: userId != currentUserId ? 12 : 0,
              )
            : const Icon(
                Icons.abc,
                size: 0,
              ),
        firstIconBorderColor: isCurrentUserTeacher
            ? userId != currentUserId
                ? blueColor
                : Colors.transparent
            : Colors.transparent,
        secondIcon: isCurrentUserTeacher
            ? Icon(
                FontAwesomeIcons.x,
                color: whiteColor,
                size: userId != currentUserId ? 12 : 0,
              )
            : const Icon(
                Icons.abc,
                size: 0,
              ),
        secondIconBorderColor: isCurrentUserTeacher
            ? userId != currentUserId
                ? redColor
                : Colors.transparent
            : Colors.transparent,
        function1: () {
          // Promote/demote member to teacher/student
          if (userId != currentUserId && isCurrentUserTeacher) {
            classUsersController.changeUserRole(
                context, userId, classId, !isTeacher);
          }
        },
        // Remove user from class
        function2: () {
          if (userId != currentUserId && isCurrentUserTeacher) {
            showDialogWithoutContent(
              context,
              "Remove this user from class?",
              "Remove",
              () {
                classUsersController.removeUserFromClass(
                    context, userId, classId, !isTeacher);
              },
              redColor,
            );
          }
        },
      ),
    );
  }
}
