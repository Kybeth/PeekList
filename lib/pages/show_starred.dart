import 'package:flutter/material.dart';
import 'package:peeklist/data/tasks.dart';

class BuildStarred extends StatelessWidget {
  final String uid;

  const BuildStarred({Key key, this.uid}):super(key:key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColorLight,
        title: Text("Star"),
      ),
      body:Showstar(
        uid:"$uid"
      ).build(context),
    );
  }
}