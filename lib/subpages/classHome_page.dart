// ignore_for_file: file_names, non_constant_identifier_names, use_build_context_synchronously

// file: classHome_page.dart
//
// author: Peter Huňady (xhunadp00)
//
// date: 2024

import 'package:chess/controller/classUser_controller.dart';
import 'package:chess/controller/class_controller.dart';
import 'package:chess/controller/invitation_controller.dart';
import 'package:chess/controller/pendingInvitations_controller.dart';
import 'package:chess/controller/puzzle_controller.dart';
import 'package:chess/controller/userPuzzle_controller.dart';
import 'package:chess/controller/user_controller.dart';
import 'package:chess/customWidgets/customButtonWithIcon_widget.dart';
import 'package:chess/customWidgets/customButton_widget.dart';
import 'package:chess/customWidgets/customClassNavbar_widget.dart';
import 'package:chess/customWidgets/customFooter_widget.dart';
import 'package:chess/customWidgets/customTextField_widget.dart';
import 'package:chess/navigationAndToasts.dart';
import 'package:chess/obx_widgets/pendingInvitations_widget.dart';
import 'package:chess/obx_widgets/puzzleGrid_widget.dart';
import 'package:chess/subpages/allPuzzles_page.dart';
import 'package:chess/subpages/classStatistics_page.dart';
import 'package:chess/subpages/createPuzzle_page.dart';
import 'package:chess/subpages/members_page.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ClassHomePage extends StatefulWidget {
  final String userId;
  final bool isTeacher;
  const ClassHomePage(
      {super.key, required this.userId, required this.isTeacher});

  @override
  State<ClassHomePage> createState() => _ClassHomePageState();
}

class _ClassHomePageState extends State<ClassHomePage> {
  Color whiteColor = const Color.fromARGB(255, 235, 227, 208);
  Color blueColor = const Color.fromARGB(255, 52, 95, 178);
  Color redColor = const Color.fromARGB(255, 178, 52, 52);
  final Color grayColor = const Color.fromARGB(255, 121, 121, 121);

  late String nameOfClass = "", shortIdOfClass = "", iconOfClass = "King";
  String classId = "";

  final ClassUsersController classUserController =
      Get.put(ClassUsersController());
  final ClassController classController = Get.put(ClassController());
  final PuzzleController puzzleController = Get.put(PuzzleController());
  final UserPuzzleController userPuzzleController =
      Get.put(UserPuzzleController());
  final InvitationsController invitationController =
      Get.put(InvitationsController());
  final PendingInvitationsController pendingInvitationController =
      Get.put(PendingInvitationsController());
  final UserController userController = Get.put(UserController());

  late bool isTeacher = false;

  // Load name, icon and short id of last opened class
  Future getClass() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    classId = preferences.getString('classId') ?? '';

    setState(() {
      nameOfClass = classController.getCurrentClassName(classId);
      iconOfClass = classController.getCurrentClassIcon(classId);
      shortIdOfClass = classController.getCurrentClassShortId(classId);
      isTeacher =
          classUserController.getCurrentUserRole(widget.userId, classId);
    });
  }

  @override
  void initState() {
    getClass();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: true,
      left: false,
      right: false,
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            color: Colors.black,
          ),
          child: Column(
            children: [
              // Navbar widget with class icon, short id and name
              CustomClassNavbar(
                nameOfClass: nameOfClass,
                iconPieceName: iconOfClass,
                idOfClass: shortIdOfClass,
                visible: false,
                function: () {
                  navigateScreenWithoutBackNavigation(
                      context,
                      ClassHomePage(
                          userId: widget.userId, isTeacher: widget.isTeacher));
                },
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Visibility(
                        visible: isTeacher,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(10, 30, 10, 0),
                          child: Row(
                            children: [
                              Text(
                                "Pending invitations",
                                style: GoogleFonts.openSans(
                                  color: whiteColor,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              Expanded(child: Container()),
                              // Dialog to send an invitation to user
                              CustomButtonWithIcon(
                                  text: "Send Invitation",
                                  icon: Icons.arrow_forward,
                                  size: 14,
                                  rightPadding: 10,
                                  function: () => showCustomDialog(context, "",
                                      sendInvitationDialogColumn()))
                            ],
                          ),
                        ),
                      ),
                      // Visible if some users want to join your class and you are the teacher
                      Visibility(
                        visible: isTeacher,
                        child: Obx(() {
                          if (pendingInvitationController
                                  .numberOfPendingInvitationsOfClass(classId) >
                              0) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 20),
                              child: PendingInvitationsGrid(
                                context: context,
                                classId: classId,
                                pendingInvitationController:
                                    pendingInvitationController,
                                classController: classController,
                                classUsersController: classUserController,
                                userController: userController,
                              ),
                            );
                          } else {
                            return Padding(
                              padding: const EdgeInsets.only(top: 20),
                              child: Align(
                                alignment: Alignment.center,
                                child: Text(
                                  "No pending invitations",
                                  style: GoogleFonts.openSans(
                                      fontSize: 16,
                                      color: grayColor,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            );
                          }
                        }),
                      ),

                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 40, 10, 0),
                        child: Row(
                          children: [
                            // Navigate to statistics subpage of class
                            CustomButtonWithIcon(
                              text: "Statistics",
                              icon: FontAwesomeIcons.chartSimple,
                              size: 20,
                              rightPadding: 40,
                              function: () => navigateScreen(
                                  context,
                                  ClassStatisticsPage(
                                    userId: widget.userId,
                                    classId: classId,
                                    isTeacher: isTeacher,
                                  )),
                            ),
                            Expanded(child: Container()),
                            // Navigate to members subpage of class
                            CustomButtonWithIcon(
                                text: "Members",
                                icon: FontAwesomeIcons.user,
                                size: 20,
                                rightPadding: 40,
                                function: () => navigateScreen(
                                    context,
                                    MembersPage(
                                      userId: widget.userId,
                                      classId: classId,
                                      isTeacher: isTeacher,
                                    ))),
                          ],
                        ),
                      ),
                      // Create a new puzzle if you are the teacher.
                      Visibility(
                        visible: isTeacher,
                        child: CustomButton(
                          paddingHorizontal: 10,
                          paddingVertical: 20,
                          backgroundColorOfBtn: blueColor,
                          borderColorOfBtn: Colors.transparent,
                          textOfBtn: "Create puzzle",
                          function: () => navigateScreen(
                              context,
                              CreatePuzzlePage(
                                nameOfClass: nameOfClass,
                                classId: classId,
                                shortIdOfClass: shortIdOfClass,
                                iconOfClass: iconOfClass,
                                userId: widget.userId,
                                isTeacher: widget.isTeacher,
                              )),
                        ),
                      ),
                      // Navigate to screen of all puzzles in the class
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
                        child: Row(
                          children: [
                            Text(
                              "Newest puzzles",
                              style: GoogleFonts.openSans(
                                color: const Color.fromARGB(255, 235, 227, 208),
                                fontSize: 18,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            Expanded(child: Container()),
                            GestureDetector(
                              onTap: () {
                                navigateScreen(
                                    context,
                                    AllPuzzlesPage(
                                        userId: widget.userId,
                                        classId: classId,
                                        isTeacher: widget.isTeacher));
                              },
                              child: Text(
                                "See all",
                                style: GoogleFonts.openSans(
                                  color: blueColor,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Show the most recent created puzzles
                      Obx(() {
                        if (puzzleController.numberOfPuzzlesOfClass(classId) >
                            0) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: PuzzlesGrid(
                              currentClassId: classId,
                              classController: classController,
                              puzzleController: puzzleController,
                              classId: classId,
                              nameOfClass: nameOfClass,
                              shortIdOfClass: shortIdOfClass,
                              iconOfClass: iconOfClass,
                              userId: widget.userId,
                              userPuzzleController: userPuzzleController,
                              numberOfPuzzlesToShow: 3,
                            ),
                          );
                        } else {
                          return Padding(
                            padding: const EdgeInsets.only(top: 20.0),
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                "There are no puzzles in the class yet",
                                style: GoogleFonts.openSans(
                                    fontSize: 16,
                                    color: grayColor,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          );
                        }
                      })
                    ],
                  ),
                ),
              ),
              CustomFooter(
                userId: widget.userId,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Dialog to send an invitation to user
  Column sendInvitationDialogColumn() {
    TextEditingController nameTextController = TextEditingController();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // User short id input field
        CustomTextField(
          text: "Enter User ID",
          labelText: "#xxxxxx",
          controller: nameTextController,
          left: 10,
          top: 10,
          right: 10,
          bottom: 10,
          isPassword: false,
        ),
        // Button - action to send invitation
        CustomButton(
            paddingHorizontal: 10,
            paddingVertical: 20,
            backgroundColorOfBtn: blueColor,
            borderColorOfBtn: Colors.transparent,
            textOfBtn: "Send",
            function: () {
              invitationController.createInvitation(context,
                  nameTextController.text, classId, classUserController);
            })
      ],
    );
  }
}
