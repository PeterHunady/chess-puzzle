// ignore_for_file: file_names, non_constant_identifier_names

// file: createPuzzle_page.dart
//
// author: Peter Huňady (xhunadp00)
//
// date: 2024

import 'package:chess/controller/class_controller.dart';
import 'package:chess/customWidgets/customButton_widget.dart';
import 'package:chess/customWidgets/customDefaultNavbar_widget.dart';
import 'package:chess/customWidgets/customFooter_widget.dart';
import 'package:chess/customWidgets/customRoundedIcon_widget.dart';
import 'package:chess/customWidgets/customTextField_widget.dart';
import 'package:chess/navigationAndToasts.dart';
import 'package:chess/subpages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

// Subpage to create a new class
class CreateClassPage extends StatefulWidget {
  final String userId;
  const CreateClassPage({super.key, required this.userId});

  @override
  State<CreateClassPage> createState() => _CreateClassPageState();
}

class _CreateClassPageState extends State<CreateClassPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  Color whiteColor = const Color.fromARGB(255, 235, 227, 208);
  Color blueColor = const Color.fromARGB(255, 52, 95, 178);
  Color grayColor = const Color.fromARGB(255, 121, 121, 121);

  List listOfPieceNames = ["King", "Queen", "Rook", "Bishop", "Knight", "Pawn"];
  String clickedPiece = "";
  final ClassController chessClass = ClassController();

  @override
  void initState() {
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
                  function: () {
                    navigateScreenWithoutBackNavigation(
                        context, const HomePage());
                  },
                  visible: true,
                ),
                Expanded(child: Container()),
                // Title
                Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                    child: Text(
                      "Create Class",
                      style: GoogleFonts.cormorant(
                        fontSize: 48,
                        color: const Color.fromARGB(255, 235, 227, 208),
                      ),
                    )),
                // Name of the class input field
                CustomTextField(
                  text: "*Enter Name",
                  labelText: "Road to GM",
                  controller: nameController,
                  left: 10,
                  top: 10,
                  right: 10,
                  bottom: 10,
                  isPassword: false,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    padding: const EdgeInsets.only(left: 10, bottom: 15),
                    child: Text(
                      "Choose icon",
                      style: GoogleFonts.openSans(color: grayColor),
                    ),
                  ),
                ),
                // Row with icons of all pieces
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(child: Container()),
                    for (var i in listOfPieceNames) ...[
                      GestureDetector(
                          onTap: () {
                            setState(() {
                              clickedPiece = i;
                            });
                          },
                          child: CustomRoundedIcon(
                            icon: CustomRoundedIconPiece(i),
                            colorOfBorder: whiteColor,
                            clickedPiece: clickedPiece == i,
                          )),
                      Expanded(child: Container())
                    ]
                  ],
                ),
                // Button - action to create a new class
                CustomButton(
                    paddingHorizontal: 20,
                    paddingVertical: 30,
                    backgroundColorOfBtn: blueColor,
                    borderColorOfBtn: Colors.transparent,
                    textOfBtn: "Create Chess Class",
                    function: () => chessClass.createClass(context,
                        nameController.text, clickedPiece, widget.userId)),
                Expanded(child: Container()),
                CustomFooter(
                  userId: widget.userId,
                )
              ],
            ),
          ),
        ));
  }

  // List of all icons
  Icon CustomRoundedIconPiece(String iconPieceName) {
    if (iconPieceName == "King") {
      return Icon(FontAwesomeIcons.chessKing, size: 16, color: whiteColor);
    } else if (iconPieceName == "Queen") {
      return Icon(FontAwesomeIcons.chessQueen, size: 16, color: whiteColor);
    } else if (iconPieceName == "Rook") {
      return Icon(FontAwesomeIcons.chessRook, size: 16, color: whiteColor);
    } else if (iconPieceName == "Bishop") {
      return Icon(FontAwesomeIcons.chessBishop, size: 16, color: whiteColor);
    } else if (iconPieceName == "Knight") {
      return Icon(FontAwesomeIcons.chessKnight, size: 16, color: whiteColor);
    } else {
      return Icon(FontAwesomeIcons.chessPawn, size: 16, color: whiteColor);
    }
  }
}
