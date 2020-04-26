import 'package:flutter/material.dart';
import 'package:peeklist/data/tasks.dart';

class BuildToday extends StatelessWidget {
  final String uid;

  const BuildToday({Key key, this.uid}):super(key:key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColorLight,
        title: Text("Today"),
      ),
      body:TodayTask(
        uid:"$uid"
      ).build(context),
    );
  }
}