// ignore_for_file: non_constant_identifier_names

// file: menu_page.dart
//
// author: Peter Huňady (xhunadp00)
//
// date: 2024

import 'package:chess/controller/classUser_controller.dart';
import 'package:chess/controller/class_controller.dart';
import 'package:chess/controller/invitation_controller.dart';
import 'package:chess/controller/user_controller.dart';
import 'package:chess/customWidgets/customButton_widget.dart';
import 'package:chess/customWidgets/customDefaultNavbar_widget.dart';
import 'package:chess/customWidgets/customFooter_widget.dart';
import 'package:chess/customWidgets/customTextField_widget.dart';
import 'package:chess/navigationAndToasts.dart';
import 'package:chess/obx_widgets/userClassesGrid_widget.dart';
import 'package:chess/subpages/invitations_page.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Subpage of main menu
class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  Color whiteColor = const Color.fromARGB(255, 235, 227, 208);
  Color blueColor = const Color.fromARGB(255, 52, 95, 178);
  Color redColor = const Color.fromARGB(255, 178, 52, 52);

  String? classId;
  String userId = "", nameOfUser = "", userShortId = "";

  final UserController userController = Get.put(UserController());
  final ClassController classController = Get.put(ClassController());
  final ClassUsersController classUsersController =
      Get.put(ClassUsersController());
  final InvitationsController invitationController =
      Get.put(InvitationsController());

  // Load user informations
  Future getUser() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    setState(() {
      userId = preferences.getString('userId') ?? '';
      userShortId = userController.getCurrentUserShortId(userId);
      nameOfUser = userController.getCurrentUserName(userId);
    });
  }

  @override
  void initState() {
    getUser();
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
              CustomDefaultNavbar(
                function: () {},
                visible: false,
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      TextSection(nameOfUser, 18, 20),
                      TextSection(userShortId, 14, 0),
                      const SizedBox(height: 10),
                      // Button - navigate to invitations page
                      MenuItem(
                          "Invitations",
                          whiteColor,
                          FontAwesomeIcons.envelope,
                          () => navigateScreen(
                              context,
                              InvitationsPage(
                                userId: userId,
                              )),
                          true),
                      // Show dialog with input fields to change password
                      MenuItem(
                          "Change Password",
                          whiteColor,
                          FontAwesomeIcons.lock,
                          () => showCustomDialog(
                                context,
                                "Change Password",
                                updatePasswordDialogColumn(),
                              ),
                          false),
                      // Log out from account
                      MenuItem(
                          "Log Out",
                          whiteColor,
                          FontAwesomeIcons.rightFromBracket,
                          () => showDialogWithoutContent(
                              context,
                              "Are you sure you want to log out?",
                              "Log out",
                              () => userController.logOut(context),
                              redColor),
                          false),
                      // Delete account
                      MenuItem(
                          "Delete Profile",
                          redColor,
                          FontAwesomeIcons.trashCan,
                          () => showDialogWithoutContent(
                              context,
                              "Are you sure you want to delete your profile?",
                              "Delete",
                              () =>
                                  userController.deleteProfile(context, userId),
                              redColor),
                          false),
                      TextSection("My Classes:", 20, 40),
                      // Display all classes the user is in
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: UserClassesGrid(
                            userId: userId,
                            getCurrentUserId: userId,
                            classController: classController,
                            classUsersController: classUsersController),
                      ),
                    ],
                  ),
                ),
              ),
              CustomFooter(
                userId: userId,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Name, shortId and My Classes text
  Widget TextSection(String text, double sizeOfText, double topPadding) {
    return Padding(
      padding: EdgeInsets.only(left: 20, top: topPadding),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          text,
          style: GoogleFonts.openSans(
              fontSize: sizeOfText,
              color: whiteColor,
              fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  // Reusable widget with menu items (invitations, change password, log out, delete profile)
  Widget MenuItem(String text, Color color, IconData icon,
      VoidCallback function, bool isInvite) {
    return GestureDetector(
      onTap: function,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 13, 20, 13),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 15),
              child: Icon(
                icon,
                color: color,
                size: 22,
              ),
            ),
            Text(
              text,
              style: GoogleFonts.openSans(
                  color: whiteColor, fontSize: 16, fontWeight: FontWeight.w500),
            ),
            if (invitationController.numberOfInvitationsOfUser(userId) > 0 &&
                isInvite) ...[
              Expanded(child: Container()),
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                    color: redColor, borderRadius: BorderRadius.circular(50)),
                child: Center(
                  child: Text(
                    invitationController
                        .numberOfInvitationsOfUser(userId)
                        .toString(),
                    style: GoogleFonts.openSans(
                        fontSize: 12,
                        color: whiteColor,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              )
            ]
          ],
        ),
      ),
    );
  }

  // Dialog with password input fields to change password
  Column updatePasswordDialogColumn() {
    TextEditingController passwordController = TextEditingController();
    TextEditingController confirmPasswordController = TextEditingController();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomTextField(
          text: "Enter Password",
          labelText: "**********",
          controller: passwordController,
          left: 10,
          top: 10,
          right: 10,
          bottom: 10,
          isPassword: true,
        ),
        CustomTextField(
          text: "Confirm Password",
          labelText: "**********",
          controller: confirmPasswordController,
          left: 10,
          top: 10,
          right: 10,
          bottom: 10,
          isPassword: true,
        ),
        CustomButton(
            paddingHorizontal: 10,
            paddingVertical: 20,
            backgroundColorOfBtn: blueColor,
            borderColorOfBtn: Colors.transparent,
            textOfBtn: "Update",
            function: () => userController.changePassword(
                context,
                passwordController.text,
                confirmPasswordController.text,
                userId))
      ],
    );
  }
}
