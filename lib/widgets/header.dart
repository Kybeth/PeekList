import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

AppBar header(context, { bool isAppTitle = false, String titleText, removeBackButton = false }) {
  return AppBar(
    automaticallyImplyLeading: removeBackButton ? false : true,
    title: Text(
      isAppTitle ?  "Link Social" : titleText,
      style: GoogleFonts.raleway(
        textStyle: TextStyle(
          color: Colors.black,
          fontSize: isAppTitle ? 50.0 : 22.0,
        )
      ),
//      style: TextStyle(
//        color: Colors.white,
//        fontFamily: isAppTitle ? "Signatra" : "",
//        fontSize: isAppTitle ? 50.0 : 22.0,
//      )
    ),
    centerTitle: true,
    backgroundColor: Theme.of(context).primaryColorLight,
  );
}