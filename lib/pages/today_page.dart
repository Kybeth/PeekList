import 'package:flutter/material.dart';
import 'package:peeklist/data/tasks.dart';
import 'package:google_fonts/google_fonts.dart';

class BuildToday extends StatelessWidget {
  final String uid;

  const BuildToday({Key key, this.uid}):super(key:key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColorLight,
        title: Text(
        'Today',
        style: GoogleFonts.raleway(
          textStyle: TextStyle(
          color: Colors.black,
          fontSize: 19.0,
          fontWeight: FontWeight.w500),
            ),
        ),
      ),
      body:TodayTask(
        uid:"$uid"
      ).build(context),
    );
  }
}