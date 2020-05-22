import 'package:flutter/material.dart';
import 'package:peeklist/utils/auth.dart';
import 'package:peeklist/data/tasks.dart';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';
import 'package:peeklist/models/user.dart';
import 'package:peeklist/utils/user.dart';
import 'package:peeklist/widgets/progress.dart';

class EditTask extends StatelessWidget {
  final String uid;

  const EditTask({Key key, this.uid}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Color(0xFFFFFFFF),
      appBar: new AppBar(
        title: new Text("Edit Task"),
        backgroundColor: Theme.of(context).primaryColorLight,
      ),
      body: new Column(
        children: <Widget>[
          TextField(
            autofocus: true,
            decoration: InputDecoration(
              hintText: "Task Name",
              prefixIcon: Icon(Icons.person),
              enabledBorder: new UnderlineInputBorder(
                borderSide: BorderSide(color: Theme.of(context).primaryColor),
              ),
              focusedBorder: new UnderlineInputBorder(
                borderSide:
                    BorderSide(color: Theme.of(context).accentColor, width: 3),
              ),
            ),
          ),
          TextField(
            decoration: InputDecoration(
              hintText: "Note",
              prefixIcon: Icon(Icons.note),
              enabledBorder: new UnderlineInputBorder(
                borderSide: BorderSide(color: Theme.of(context).primaryColor),
              ),
              focusedBorder: new UnderlineInputBorder(
                borderSide:
                    BorderSide(color: Theme.of(context).accentColor, width: 3),
              ),
            ),
          ),
          TextField(
            decoration: InputDecoration(
              hintText: "Due Date",
              prefixIcon: Icon(Icons.timer),
              enabledBorder: new UnderlineInputBorder(
                borderSide: BorderSide(color: Theme.of(context).primaryColor),
              ),
              focusedBorder: new UnderlineInputBorder(
                borderSide:
                    BorderSide(color: Theme.of(context).accentColor, width: 3),
              ),
            ),
            readOnly: true,
          ),
          Row(
            children: <Widget>[
              Spacer(),
              Text(
                'Choose a list  ',
                style: TextStyle(fontSize: 16),
              ),
              //buildList(uid),
              Spacer(),
            ],
          ), Row(children: <Widget>[
            Spacer(),]),
          Row(children: <Widget>[
            Spacer(),
            Text(
              'This is a private task   ',
              style: TextStyle(fontSize: 16),
            ),Spacer(),
          ]),
          Row(children: <Widget>[
            Spacer(),
            FlatButton(
              onPressed: () {},
              color: Colors.cyan,
              child: Text("done"),
            ),
            Spacer(),
          ]),
        ],
      ),
    );
  }
}
