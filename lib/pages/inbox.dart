import 'package:flutter/material.dart';
import 'package:peeklist/data/tasks.dart';
import 'package:google_fonts/google_fonts.dart';

class Buildall extends StatelessWidget {
  final String uid;

  const Buildall({Key key, this.uid}):super(key:key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColorLight,
        title: Text(
          'All',
          style: GoogleFonts.raleway(
            textStyle: TextStyle(
                color: Colors.black,
                fontSize: 19.0,
                fontWeight: FontWeight.w500),
          ),
        ),
      ),
      body:IncompleteTask(uid: uid,).build(context),
    );
  }
}