
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:peeklist/widgets/header.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:peeklist/utils/auth.dart';
import 'package:peeklist/data/tasks.dart';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';

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
            onPressed: () async{
              Tasks ntask=new Tasks (
                  name: _taskname.text,
                  uid: await AuthService().userID(),
                  comment: _tasknote.text,
                list: 'inbox',
                iscompleted: false,
                isstarred: false
              );

              ntask.addtask();
              Navigator.of(context).pop();
            },
            child: Text('add'),
          )
        ],
      ),
    );
  }
}

//Future _addtask(String taskname,String tasknote,String list)async {
//  var mylist="inbox";
//  var uid = await AuthService().userID();
//  if(list==null || list.length==0){
//    mylist=list;
//  }
//  await Firestore.instance
//  .collection('tasks')
//    .add(<String, dynamic>{
//    'uid': uid,
//    'name': taskname,
//    'comment': tasknote,
//    'list' : mylist,
//    'time': Timestamp.now(),
//    'iscompleted':false,
//    });
//}