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

class _RootState extends State<Root> with SingleTickerProviderStateMixin {
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
        padding: EdgeInsets.symmetric(
          horizontal: 25.0,
        ),
          alignment: Alignment.center,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                Theme.of(context).accentColor.withOpacity(0.8),
                Theme.of(context).backgroundColor,
              ])),
          child: Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const ListTile(
                  title:  Text(
                  'Like our design?',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                    height: 2,
                    color: Colors.black,
                  ),
                ),
                  subtitle: Text(
                    'Login to enjoy our full function!',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                      height: 2,
                      color: Colors.black,
                    ),
                  ),
                ),
                ButtonBar(
                    children: <Widget>[
                      FlatButton(
                        child: const Text(
                            'Login with Google',
                          style: TextStyle(color: Colors.cyan, fontSize: 15,),
                        ),

                        onPressed: () => authService.googleSignIn(),
                      ),
                      ]
                ),
              ]
            ),
          ),
      ),
    );
  }

  Scaffold buildUnAuthScreen() {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              child: Icon(Icons.more_vert),
            ),
          ),
        ],
        backgroundColor: Theme.of(context).primaryColorLight,
        title: Text(
          'PeekList',
          style: GoogleFonts.raleway(
            textStyle: TextStyle(
                color: Colors.black,
                fontSize: 19.0,
                fontWeight: FontWeight.w500
            ),
          ),
        ),
        bottom: TabBar(
          indicatorColor: Theme.of(context).accentColor,
          labelStyle: GoogleFonts.raleway(
            textStyle: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500),
          ),
          tabs: [
            Tab(
              text: "TASKS",
            ),
            Tab(
              text: "FRIENDS",
            ),
          ],
          controller: _tabController,
        ),
        elevation: 0.0,
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
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              child: Icon(Icons.more_vert),
            ),
          ),
        ],
        backgroundColor: Theme.of(context).primaryColorLight,
        title: Text(
          'PeekList',
          style: GoogleFonts.raleway(
            textStyle: TextStyle(
              color: Colors.black,
              fontSize: 19.0,
                fontWeight: FontWeight.w500
            ),
          ),
        ),
        bottom: TabBar(
          indicatorColor: Theme.of(context).accentColor,
          labelStyle: GoogleFonts.raleway(
            textStyle: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500),
          ),
          tabs: [
            Tab(
              text: "TASKS",
            ),
            Tab(
              text: "FRIENDS",
            ),
          ],
          controller: _tabController,
        ),
        elevation: 0.0,
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
    _firebaseMessaging.getToken().then((token) {
      UserService().updateToken(uid, token);
    });
  }
}
