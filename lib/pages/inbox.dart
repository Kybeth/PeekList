import 'package:flutter/material.dart';
import 'package:peeklist/data/tasks.dart';

class BuildInbox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("inbox"),
      ),
      body:Showlist().build(context),
    );
  }
}