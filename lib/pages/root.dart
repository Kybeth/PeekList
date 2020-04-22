import 'package:flutter/material.dart';
import 'package:peeklist/pages/task_page.dart';
import 'package:peeklist/pages/timeline.dart';

import '../models/user.dart';
import '../utils/auth.dart';

var currentUser;

class Root extends StatefulWidget {
  final String title;

  Root({Key key, this.title}) : super(key: key);

  @override
  _RootState createState() => _RootState();
}

class _RootState extends State<Root>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  Map<String, dynamic> _profile;
  bool _loading = false;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    authService.profile.listen((state) => setState(() => _profile = state));
    authService.loading.listen((state) => setState(() => _loading = state));
    super.initState();
  }

  Scaffold loginButton() {
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


  Scaffold buildUnAuthScreen() {
    return Scaffold(
      appBar: AppBar(
        title: Text('Peek List'),
        bottom: TabBar(
          tabs: [
            Tab(
              text: "Home",
            ),
            Tab(
              text: "Login",
            ),
          ],
          controller: _tabController,
        ),
      ),
      body: TabBarView(
        children: <Widget>[
          TaskPage(),
          loginButton(),
        ],
        controller: _tabController,
      ),
    );

  }

  Scaffold buildAuthScreen() {
    return Scaffold(
      appBar: AppBar(
        title: Text('Peek List'),
        bottom: TabBar(
          tabs: [
            Tab(
              text: "Home",
            ),
            Tab(
              text: "Social",
            ),
          ],
          controller: _tabController,
        ),
      ),
      body: TabBarView(
        children: <Widget>[
          TaskPage(),
//          SocialHome(),
          Timeline(),
        ],
        controller: _tabController,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: authService.user,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return buildAuthScreen();
        } else {
          return buildUnAuthScreen();
        }
      },
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}