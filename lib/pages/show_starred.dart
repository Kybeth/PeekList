import 'package:flutter/material.dart';
import 'package:peeklist/data/tasks.dart';
import 'package:google_fonts/google_fonts.dart';

class BuildStarred extends StatelessWidget {
  final String uid;

  const BuildStarred({Key key, this.uid}):super(key:key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColorLight,
        title: Text(
          'Star',
          style: GoogleFonts.raleway(
            textStyle: TextStyle(
                color: Colors.black,
                fontSize: 19.0,
                fontWeight: FontWeight.w500),
          ),
        ),
      ),
      body:Showstar(
        uid:"$uid"
      ).build(context),
    );
  }
}