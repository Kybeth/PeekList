
import 'package:flutter/material.dart';
import 'package:peeklist/widgets/header.dart';

class CreateTask extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Add a task"),
      ),
      body: new Column(
        children: <Widget>[
          TextField(
            autofocus: true,
            decoration: InputDecoration(
                hintText: "Task Name",
                prefixIcon: Icon(Icons.person)
            ),
          ),
          TextField(
            decoration: InputDecoration(
                hintText: "Note",
                prefixIcon: Icon(Icons.note)
            ),
          ),
        ],
      ),
    );
  }
}
