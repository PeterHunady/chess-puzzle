// file: navigationAndToasts.dart
//
// author: Peter Huňady (xhunadp00)
//
// date: 2024

import 'package:chess/firebase_options.dart';
import 'package:chess/subpages/home_page.dart';
import 'package:chess/subpages/signIn_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize firebase options
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Load userId to stay signed in
  SharedPreferences preferences = await SharedPreferences.getInstance();
  var id = preferences.getString('userId');

  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "ChessUp",
      home: id == null ? const SignInPage() : const HomePage()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "ChessUp",
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // Navigate to sign in subpage
      home: const SignInPage(),
    );
  }
}
