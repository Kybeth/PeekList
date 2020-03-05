import 'package:flutter/material.dart';
import 'package:peeklist/pages/create_account.dart';
import 'package:peeklist/pages/create_task.dart';

class TaskPage extends StatefulWidget {
  // final FirebaseUser user;

  // TaskPage({Key key, this.user}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: <Widget>[
          Container(
            child: Column(children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 25.0),
                child: Center(
                  child: Text(
                    "Task Page",
                    style: TextStyle(
                      fontSize: 25.0,
                    ),
                  ),
                ),
              ),
              Row(
              children: <Widget>[
              Icon(
                Icons.inbox,
                color: Colors.red,
                size: 30.0,
              ),
              RaisedButton(
                  child: Text('Inbox'),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => SecondRoute()));
                  }),
            ]),  ],)
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CreateTask()),
          );
        },
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

class SecondRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("inbox"),
      ),
      body: Center(
        child: RaisedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Go back!'),
        ),
      ),
    );
  }
}
