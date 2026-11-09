// ignore_for_file: file_names, use_build_context_synchronously

// file: signUp_page.dart
//
// author: Peter Huňady (xhunadp00)
//
// date: 2024

import 'package:chess/controller/user_controller.dart';
import 'package:chess/customWidgets/customButton_widget.dart';
import 'package:chess/customWidgets/customDefaultNavbar_widget.dart';
import 'package:chess/customWidgets/customTextField_widget.dart';
import 'package:chess/navigationAndToasts.dart';
import 'package:chess/subpages/signIn_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Subpage for sign up
class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  final UserController user = UserController();

  Color whiteColor = const Color.fromARGB(255, 235, 227, 208);
  Color blueColor = const Color.fromARGB(255, 52, 95, 178);
  Color grayColor = const Color.fromARGB(255, 121, 121, 121);

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
            child: Center(
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
                        // Title
                        Padding(
                            padding: const EdgeInsets.fromLTRB(0, 30, 0, 30),
                            child: Text(
                              "Sign up",
                              style: GoogleFonts.cormorant(
                                  fontSize: 46,
                                  color:
                                      const Color.fromARGB(255, 235, 227, 208)),
                            )),
                        // Name input field
                        CustomTextField(
                          text: "*Enter Name",
                          labelText: "John Doe",
                          controller: nameController,
                          left: 10,
                          top: 10,
                          right: 10,
                          bottom: 10,
                          isPassword: false,
                        ),
                        // Email input field
                        CustomTextField(
                          text: "*Enter Email",
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
                          text: "*Enter Password",
                          labelText: "**********",
                          controller: passwordController,
                          left: 10,
                          top: 10,
                          right: 10,
                          bottom: 10,
                          isPassword: true,
                        ),
                        // Confirm password input field
                        CustomTextField(
                          text: "*Confirm Password",
                          labelText: "**********",
                          controller: confirmPasswordController,
                          left: 10,
                          top: 10,
                          right: 10,
                          bottom: 10,
                          isPassword: true,
                        ),
                        // Button - sign up action
                        CustomButton(
                            paddingHorizontal: 10,
                            paddingVertical: 7,
                            backgroundColorOfBtn: blueColor,
                            borderColorOfBtn: Colors.transparent,
                            textOfBtn: "Sign up",
                            function: () async => await user.signUpUser(
                                context,
                                nameController.text,
                                emailController.text,
                                passwordController.text,
                                confirmPasswordController.text)),
                        // Step back to sign in page
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Already have an account?",
                                  style: GoogleFonts.openSans(
                                      color: grayColor, fontSize: 13)),
                              GestureDetector(
                                onTap: () {
                                  navigateScreenWithoutBackNavigation(
                                      context, const SignInPage());
                                },
                                child: Text(
                                  " Log in",
                                  style: GoogleFonts.openSans(
                                      color: whiteColor,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 13),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  )),
                ],
              ),
            ),
          ),
        ));
  }
}
