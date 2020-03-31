import 'package:flutter/material.dart';
import 'package:peeklist/data/tasks.dart';

class BuildPlanned extends StatelessWidget {
  final String uid;

  const BuildPlanned({Key key, this.uid}):super(key:key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("tasks past due date and time"),
      ),
      body:IncompleteTask(
        uid:"$uid"
      ).build(context),
    );
  }
}