import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:peeklist/pages/task_page.dart';
import 'package:peeklist/pages/timeline.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:peeklist/utils/user.dart';
import '../utils/auth.dart';

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
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    authService.profile.listen((state) => setState(() => _profile = state));
    authService.loading.listen((state) => setState(() => _loading = state));
    super.initState();
}

  Scaffold loginButton() {
    return Scaffold(
      backgroundColor: Color(0xFFE5E5E5),
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
      backgroundColor: Color(0xFFE5E5E5),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColorLight,
        title: Text(
            'Peek List',
          style: GoogleFonts.raleway(
            textStyle: TextStyle(
              color: Colors.black,
              fontSize: 20.0,
            ),
          ),
        ),
        bottom: TabBar(
          indicatorColor: Theme.of(context).accentColor,
          labelStyle: GoogleFonts.raleway(
            textStyle: TextStyle(
                fontSize: 15.0
            ),
          ),
          tabs: [
            Tab(
              icon: Icon(Icons.home, color: Colors.black,),
              text: "Home",
            ),
            Tab(
              icon: Icon(Icons.person, color: Colors.black,),
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
      backgroundColor: Color(0xFFE5E5E5),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColorLight,
        title: Text(
            'Peek List',
          style: GoogleFonts.raleway(
            textStyle: TextStyle(
              color: Colors.black,
              fontSize: 25.0,
            ),
          ),
        ),
        bottom: TabBar(
          indicatorColor: Theme.of(context).accentColor,
          labelStyle: GoogleFonts.raleway(
            textStyle: TextStyle(
              fontSize: 15.0
            ),
          ),
          tabs: [
            Tab(
              icon: Icon(Icons.home, color: Colors.black,),
              text: "Home",
            ),
            Tab(
              icon: Icon(Icons.group, color: Colors.black,),
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
          updateToken();
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

  void updateToken() async {
    var uid = await authService.userID();
    _firebaseMessaging.getToken().then((token){
        UserService().updateToken(uid, token);
    });
  }
}