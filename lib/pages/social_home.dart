import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:peeklist/models/todo.dart';
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
  bool _isAuth = false;
  Map<String, dynamic> _profile;
  bool _loading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    authService.profile.listen((state) => setState(() => _profile = state));
    authService.loading.listen((state) => setState(() => _loading = state));
    authService.isAuth.listen((state) => setState(() => _isAuth = state));
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

  

  Widget buildUnAuthScreen() {
    
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Theme.of(context).accentColor.withOpacity(0.8),
              Theme.of(context).primaryColor,
            ]
          )
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              'Peek List',
              style: TextStyle(
                fontFamily: "Signatra",
                fontSize: 90.0,
                color: Colors.white
              ),
            ),
            RaisedButton(
              child: Text("Login with Google"),
              padding: EdgeInsets.all(15.0),
              onPressed: () => authService.googleSignIn(),
              elevation: 5.0,
              color: Theme.of(context).primaryColorDark,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
                side: BorderSide(color: Colors.black),
              ),
            ),
      ],)
    ),);
  }
  
  Scaffold buildAuthScreen() {
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
            label: "Profile",
            onTap: () {},
          ),
          SpeedDialChild(
            labelStyle: TextStyle(
              color: Colors.black,
            ),
            backgroundColor: Theme.of(context).primaryColorLight,
            child: Icon(Icons.search),
            label: "Search",
            onTap: () {
        
            },
          ),
          SpeedDialChild(
            labelStyle: TextStyle(
              color: Colors.black,
            ),
            backgroundColor: Colors.black45,
            child: Icon(Icons.exit_to_app),
            label: "Logout",
            onTap: () => authService.signOut(),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _isAuth ? buildAuthScreen() : buildUnAuthScreen();
  }
}