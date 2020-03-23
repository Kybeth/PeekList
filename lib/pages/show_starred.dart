import 'package:flutter/material.dart';
import 'package:peeklist/data/tasks.dart';

class BuildStarred extends StatelessWidget {
  final String uid;

  const BuildStarred({Key key, this.uid}):super(key:key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("starred"),
      ),
      body:Showstar(
        uid:"$uid"
      ).build(context),
    );
  }
}