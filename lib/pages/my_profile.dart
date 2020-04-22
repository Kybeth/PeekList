import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:peeklist/models/user.dart';
import 'package:peeklist/pages/edit_profile.dart';
import 'package:peeklist/pages/notifications_page.dart';
import 'package:peeklist/pages/root.dart';
import 'package:peeklist/utils/user.dart';
import 'package:peeklist/widgets/header.dart';
import 'package:peeklist/widgets/progress.dart';

class MyProfile extends StatefulWidget {

  @override
  _MyProfileState createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  String uid;

  @override
  void initState() {
    super.initState();
  }

  editProfile() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => EditProfile(uid: uid)));
  }

  notification() {
    // Navigator.push(context, MaterialPageRoute(builder: (context) => NotificationsPage(uid: uid)));
    Navigator.pushNamed(context, '/notifications', arguments: uid);
  }

  addFriend(currUser, recUser) async {
    await UserService().sendFriendRequest(currUser, recUser);
    print("Success");
    
  }


  Container buildButton({ String text, Function function }) {
    return Container(
      padding: EdgeInsets.only(top: 5.0),
      child: FlatButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0)
        ),
        onPressed: function,
        child: Container(
          width: 150.0,
          height: 30.0,
          child: Text(
            text,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.blue,
            border: Border.all(
              color: Colors.blue,
            ),
            borderRadius: BorderRadius.circular(5.0),
          ),
        ),
      ),
    );
  }

  buildProfileButton(User currentProfile) {
    bool isProfileOwner = currentUser == currentProfile.uid;
    if (isProfileOwner) {
      return Column(
        children: <Widget>[
          buildButton(
            text: "Edit Profile",
            function: editProfile,
          ),
          buildButton(
            text: "Notifications",
            function: notification,
          ),
        ],
      );
    } else {
      return Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(top: 5.0),
            child: FlatButton.icon(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0)
            ),
            onPressed: () => addFriend(currentUser, currentProfile),
            icon: Icon(Icons.person_add),
            label: Text("Add Friend"),
            color: Theme.of(context).primaryColorLight,
            colorBrightness: Brightness.dark,
        ),
      ),
    ],
  );
    }
  }

  buildProfileHeader(uid) {
    return FutureBuilder(
      future: UserService().getUserById(uid),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return circularProgress();
        }
        User currentProfile = User.fromDocument(snapshot.data);
        return Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              SizedBox(height: 40,),
              CircleAvatar(
                backgroundImage: CachedNetworkImageProvider(currentProfile.photoURL),
                radius: 50,
              ),
              SizedBox(height: 10,),
              Text(
                currentProfile.displayName,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
              SizedBox(height: 5,),
              Text(
                currentProfile.email,
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(height: 3,),
              Text(
                currentProfile.bio,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20,),
              buildProfileButton(currentProfile),
            ]
          )
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    RouteSettings settings = ModalRoute.of(context).settings;
    uid = settings.arguments;
    return Scaffold(
      appBar: header(context, titleText: "Profile"),
      body: Container(
        padding: EdgeInsets.all(15.0),
        child: ListView(
          children: <Widget>[
            buildProfileHeader(uid),
          ],
        ),
      ),
    );
  }
}