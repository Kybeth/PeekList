import 'package:flutter/material.dart';
import 'package:peeklist/data/tasks.dart';

class BuildCompleted extends StatelessWidget {
  final String uid;

  const BuildCompleted({Key key, this.uid}):super(key:key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColorLight,
        title: Text("Done"),
      ),
      body:CompletedTask(
        uid:"$uid"
      ).build(context),

    );
  }
}