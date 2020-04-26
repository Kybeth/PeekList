import 'package:flutter/material.dart';
import 'package:peeklist/data/tasks.dart';

class Buildall extends StatelessWidget {
  final String uid;

  const Buildall({Key key, this.uid}):super(key:key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColorLight,
        title: Text("All"),
      ),
      body:IncompleteTask(uid: uid,).build(context),
    );
  }
}