// ignore_for_file: use_build_context_synchronously

// file: user_controller.dart
//
// author: Peter Huňady (xhunadp00)
//
// date: 2024

import 'package:chess/controller/userPuzzle_controller.dart';
import 'package:chess/models/user_model.dart';
import 'package:chess/navigationAndToasts.dart';
import 'package:chess/subpages/home_page.dart';
import 'package:chess/subpages/signIn_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Controller for users
class UserController extends GetxController {
  final userDatabase = FirebaseFirestore.instance.collection('users');

  final users = <Users>[].obs;

  // Function to fetch all data as a stream.
  Stream<List<Users>> getAllUsers() {
    return userDatabase.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Users.fromSnapshot(doc);
      }).toList()
        ..sort((a, b) => a.name.compareTo(b.name));
    });
  }

  @override
  void onInit() {
    users.bindStream(getAllUsers());
    super.onInit();
  }

  // Get name of the currently signed in user
  String getCurrentUserName(String userId) {
    try {
      return users
          .where(
            (element) => element.id == userId,
          )
          .first
          .name;
    } catch (e) {
      showToast("Error fetching user name!");
      return "";
    }
  }

  // Get short ID of the currently signed in user
  String getCurrentUserShortId(String userId) {
    try {
      return users
          .where(
            (element) => element.id == userId,
          )
          .first
          .userId;
    } catch (e) {
      showToast("Error fetching short id of user!");
      return "";
    }
  }

  // Change password of the currently signed in user
  Future<void> changePassword(BuildContext context, String newPassword,
      String confirmPassword, String id) async {
    if (id == "") {
      showToast("Unknown id of user!");
      return;
    }

    if (newPassword.trim().length < 8) {
      showToast("Password must be at least 8 characters long!");
      return;
    } else if (newPassword.trim() != confirmPassword.trim()) {
      showToast("Password doesn't match!");
      return;
    }

    DocumentSnapshot userDoc = await userDatabase.doc(id).get();

    if (!userDoc.exists) {
      showToast("Something went wrong!");
      return;
    }

    String email = userDoc.get('email');
    String password = userDoc.get('password');

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email.trim(), password: password.trim());

      User? user = FirebaseAuth.instance.currentUser;
      await user?.updatePassword(newPassword.trim());
      await userDatabase.doc(id).update({'password': newPassword.trim()});

      Navigator.pop(context);
      showToast("Password has been successfully changed.");
    } on FirebaseAuthException {
      showToast("Unknown error while changing password!");
    }
  }

  // Sign up user
  Future<void> signUpUser(BuildContext context, String name, String email,
      String password, String confirmPassword) async {
    try {
      final documentUuid = userDatabase.doc().id;

      // Check input validity
      if (name.trim().length < 3) {
        showToast("Invalid name!");
        return;
      } else if (email.trim().length < 6 ||
          !email.trim().contains("@") ||
          !email.trim().contains(".")) {
        showToast("Invalid email!");
        return;
      } else if (password.trim().length < 8) {
        showToast("Password must be at least 8 characters long!");
        return;
      } else if (password.trim() != confirmPassword.trim()) {
        showToast("Password doesn't match!");
        return;
      }

      // Create new account
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: email.trim(), password: password.trim())
          .then((value) async {
        try {
          Users user = Users(
              id: documentUuid,
              name: name,
              email: email,
              password: password,
              userId: "#${documentUuid.substring(0, 6)}");
          await userDatabase.doc(documentUuid).set(user.toMap());

          SharedPreferences preferences = await SharedPreferences.getInstance();
          preferences.setString('userId', documentUuid);
          preferences.setString(
              'userShortId', "#${documentUuid.substring(0, 6)}");
          preferences.setString('userName', name);

          navigateScreenWithoutBackNavigation(context, const HomePage());
        } on FirebaseException {
          showToast("Error while signing up!");
        }
      });
    } on FirebaseAuthException {
      showToast("Error while signing up!");
    }
  }

  // Sign in user
  Future<void> logInUser(
    BuildContext context,
    String email,
    String password,
  ) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email.trim(), password: password)
          .then((value) async {
        QuerySnapshot querySnapshot =
            await userDatabase.where('email', isEqualTo: email.trim()).get();

        if (querySnapshot.docs.isNotEmpty) {
          DocumentSnapshot userDoc = querySnapshot.docs.first;
          String userId = userDoc.id;

          SharedPreferences preferences = await SharedPreferences.getInstance();
          preferences.setString('userId', userId);

          navigateScreenWithoutBackNavigation(context, const HomePage());
        } else {
          showToast("Something went wrong!");
        }
      });
    } on FirebaseAuthException {
      showToast("Incorrect email or password.");
    }
  }

  // Sign out user
  Future<void> logOut(BuildContext context) async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      preferences.remove('userId');
      preferences.remove('classId');

      await FirebaseAuth.instance.signOut();
      navigateScreenWithoutBackNavigation(context, const SignInPage());
    } on FirebaseAuthException {
      showToast("Unknown error while logging out!");
    }
  }

  // Delete account from database
  Future<void> deleteProfile(BuildContext context, String id) async {
    if (id == "") {
      showToast("Unknown error while deleting profile!");
      return;
    }

    DocumentSnapshot userDoc = await userDatabase.doc(id).get();

    if (!userDoc.exists) {
      showToast("Something went wrong!");
      return;
    }

    String email = userDoc.get('email');
    String password = userDoc.get('password');

    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password.trim());
      UserPuzzleController userPuzzleController =
          Get.put(UserPuzzleController());
      await userPuzzleController.removeUserFromStatistics(context, id);
      await userDatabase.doc(id).delete();

      await FirebaseAuth.instance.currentUser?.delete();
      navigateScreenWithoutBackNavigation(context, const SignInPage());

      showToast("Profile deleted successfully.");
    } on FirebaseAuthException {
      showToast("Unknown error while deleting profile!");
    }
  }

  // Get ID of user from short ID
  String getIdOfUsersFromShortId(String shortIdOfUser) {
    try {
      String userId = "";

      if (shortIdOfUser.length != 7 && shortIdOfUser.length != 6) {
        showToast("Invalid length of user ID!");
        return "";
      }

      if (!shortIdOfUser.contains("#")) {
        shortIdOfUser = "#$shortIdOfUser";

        userId =
            users.where((element) => element.userId == shortIdOfUser).first.id;
      } else {
        userId =
            users.where((element) => element.userId == shortIdOfUser).first.id;
      }

      return userId;
    } catch (e) {
      showToast("User ID not found!");
      return "";
    }
  }
}
