
import 'package:flutter/material.dart';
import 'package:peeklist/widgets/header.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CreateTask extends StatelessWidget {
  final _taskname=TextEditingController();
  final _tasknote=TextEditingController();

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
            controller: _taskname,
            decoration: InputDecoration(
                hintText: "Task Name",
                prefixIcon: Icon(Icons.person)
            ),
          ),
          TextField(
            controller: _tasknote,
            decoration: InputDecoration(
                hintText: "Note",
                prefixIcon: Icon(Icons.note)
            ),
          ),
          RaisedButton(
            onPressed: (){
              _addtask(_taskname.text,_tasknote.text,"inbox");
              Navigator.of(context).pop();
            },
            child: Text('add'),
          )
        ],
      ),
    );
  }
}

Future _addtask(String taskname,String tasknote,String list)async {
  var mylist="inbox";
  if(list==null || list.length==0){
    mylist=list;
  }
  await Firestore.instance
  .collection('tasks')
    .add(<String, dynamic>{
    'name': taskname,
    'comment': tasknote,
    'list' : mylist,
    'time': Timestamp.now(),
    'iscompleted':false,
    });
}