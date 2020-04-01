import 'package:flutter/material.dart';
import 'package:peeklist/data/tasks.dart';
import 'package:peeklist/pages/create_task.dart';

class tasklistpage extends StatelessWidget {
  final String listname;
  final String uid;
  tasklistpage({Key key, this.listname, this.uid}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(this.listname),
      ),
      body: Showlist(
        uid:"$uid",
        list: "$listname",
      ).build(context),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed('/createtask', arguments: listname);
        },
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
