import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:peeklist/models/todo.dart';
import 'package:peeklist/models/user.dart';
import 'package:peeklist/pages/root.dart';
import 'package:peeklist/utils/auth.dart';

class SocialHome extends StatefulWidget {
  SocialHome({Key key}) : super(key: key);

  @override
  _SocialHomeState createState() => _SocialHomeState();
}

List socialFeed = [
      Todo(
        name: "Social Post 1",
        isDone: false,
        description: "This is a test...",
        isSocial: true,
      ),
      Todo(
        name: "Social Post 2",
        isDone: false,
        description: "This is a test...",
        isSocial: true,
      ),
      Todo(
        name: "Social Post 3",
        isDone: false,
        description: "This is a test...",
        isSocial: true,
      ),
    ];

class _SocialHomeState extends State<SocialHome> {
  String uid;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserId();
    // uid = await authService.userID();
    // authService.isAuth.listen((state) => setState(() => _isAuth = state));
  }

  getUserId() async {
    uid = await authService.userID();
    print(uid);
  }

  ListTile makeListTile(Todo todo) => ListTile(
    contentPadding:
        EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
    leading: Container(
      padding: EdgeInsets.only(right: 12.0),
      decoration: new BoxDecoration(
          border: new Border(
              right: new BorderSide(width: 1.0, color: Colors.black87))),
      child: Icon(Icons.autorenew, color: Colors.black),
    ),
    title: Text(
      todo.name,
      style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
    ),
    // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

    subtitle: Row(
      children: <Widget>[
        Expanded(
            flex: 1,
            child: Container(
              // tag: 'hero',
              child: Checkbox(value: todo.isDone)
            )),
        Expanded(
          flex: 4,
          child: Padding(
              padding: EdgeInsets.only(left: 10.0),
              child: Text(todo.description,
                  style: TextStyle(color: Colors.black))),
        )
      ],
    ),
    trailing:
        Icon(Icons.keyboard_arrow_right, color: Colors.black, size: 30.0),
    onTap: () {},
  );

  Card makeCard(Todo todo) => Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      // color: Theme.of(context).accentColor,
      elevation: 8.0,
      margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      child: Container(
        // decoration: BoxDecoration(color: Color.fromRGBO(64, 75, 96, .9)),
        child: makeListTile(todo),
      ),
    );

  @override
  Widget build(BuildContext context) {
    final makeBody = Container(
      padding: EdgeInsets.all(10.0),
      // decoration: BoxDecoration(color: Color.fromRGBO(58, 66, 86, 1.0)),
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: socialFeed.length,
        itemBuilder: (BuildContext context, int index) {
          return makeCard(socialFeed[index]);
        },
      ),
    );

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: makeBody,
      floatingActionButton: SpeedDial(
        backgroundColor: Theme.of(context).primaryColorDark,
        animatedIcon: AnimatedIcons.menu_close,
        children: [
          SpeedDialChild(
            labelStyle: TextStyle(
              color: Colors.black,
            ),
            backgroundColor: Theme.of(context).accentColor,
            child: Icon(Icons.add),
            label: "Add",
            onTap: () => print('Add')
          ),
          SpeedDialChild(
            labelStyle: TextStyle(
              color: Colors.black,
            ),
            backgroundColor: Theme.of(context).primaryColor,
            child: Icon(Icons.person),
            label: "My Profile",
            onTap: () {
              Navigator.pushNamed(context, '/myprofile', arguments: currentUser);
            },
          ),
          SpeedDialChild(
            labelStyle: TextStyle(
              color: Colors.black,
            ),
            backgroundColor: Theme.of(context).primaryColorLight,
            child: Icon(Icons.notifications),
            label: "Notification Center",
            onTap: () {
              Navigator.pushNamed(context, '/notifications', arguments: uid);
            },
          ),
          SpeedDialChild(
            labelStyle: TextStyle(
              color: Colors.black,
            ),
            backgroundColor: Colors.black45,
            child: Icon(Icons.person_add),
            label: "Add Friends",
            onTap: () {
              Navigator.pushNamed(context, '/search', arguments: uid);
            },
          ),
        ],
      ),
    );
  }
}
