import 'package:flutter/material.dart';
import 'package:peeklist/data/tasks.dart';

class BuildCompleted extends StatelessWidget {
  final String uid;

  const BuildCompleted({Key key, this.uid}):super(key:key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Completed"),
      ),
      body:CompletedTask(
        uid:"$uid"
      ).build(context),
      backgroundColor: Colors.grey[200],
    );
  }
}