// ignore_for_file: file_names, use_build_context_synchronously

// file: signIn_page.dart
//
// author: Peter Huňady (xhunadp00)
//
// date: 2024

import 'package:chess/controller/user_controller.dart';
import 'package:chess/customWidgets/customButton_widget.dart';
import 'package:chess/navigationAndToasts.dart';
import 'package:chess/customWidgets/customDefaultNavbar_widget.dart';
import 'package:chess/subpages/signUp_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../customWidgets/customTextField_widget.dart';

// Subpage for sign in
class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final UserController user = UserController();

  Color whiteColor = const Color.fromARGB(255, 235, 227, 208);
  Color blueColor = const Color.fromARGB(255, 52, 95, 178);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      left: false,
      right: false,
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            color: Colors.black,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomDefaultNavbar(
                function: () {},
                visible: false,
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 50),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 30),
                            child: Text(
                              "ChessUp",
                              style: GoogleFonts.cormorant(
                                fontSize: 58,
                                color: const Color.fromARGB(255, 235, 227, 208),
                              ),
                            ),
                          ),
                          // Email input field
                          CustomTextField(
                            text: "Enter Email",
                            labelText: "example@gmail.com",
                            controller: emailController,
                            left: 10,
                            top: 10,
                            right: 10,
                            bottom: 10,
                            isPassword: false,
                          ),
                          // Password input field
                          CustomTextField(
                            text: "Enter Password",
                            labelText: "**********",
                            controller: passwordController,
                            left: 10,
                            top: 10,
                            right: 10,
                            bottom: 25,
                            isPassword: true,
                          ),
                          // Button - action to sign in
                          CustomButton(
                            paddingHorizontal: 10,
                            paddingVertical: 7,
                            backgroundColorOfBtn: blueColor,
                            borderColorOfBtn: Colors.transparent,
                            textOfBtn: "Log in",
                            function: () async => await user.logInUser(context,
                                emailController.text, passwordController.text),
                          ),
                          // Button - navigation to sign up subpage
                          CustomButton(
                            paddingHorizontal: 10,
                            paddingVertical: 7,
                            backgroundColorOfBtn: Colors.transparent,
                            borderColorOfBtn: whiteColor,
                            textOfBtn: "Sign up",
                            function: () =>
                                navigateScreen(context, const SignUpPage()),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
