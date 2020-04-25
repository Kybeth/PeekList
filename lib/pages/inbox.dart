import 'package:flutter/material.dart';
import 'package:peeklist/data/tasks.dart';

class BuildInbox extends StatelessWidget {
  final String uid;

  const BuildInbox({Key key, this.uid}):super(key:key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColorLight,
        title: Text("inbox"),
      ),
      body:Showlist(
        uid:"$uid",
        list: 'inbox',
      ).build(context),
      backgroundColor: Colors.grey[200],
    );
  }
}