import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:peeklist/models/user.dart';
import 'package:peeklist/pages/edit_profile.dart';
import 'package:peeklist/pages/root.dart';
import 'package:peeklist/utils/user.dart';
import 'package:peeklist/widgets/header.dart';
import 'package:peeklist/widgets/progress.dart';

class MyProfile extends StatefulWidget {
  MyProfile({Key key}) : super(key: key);

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

  Container buildButton({ String text, Function function }) {
    return Container(
      padding: EdgeInsets.only(top: 2.0),
      child: FlatButton(
        onPressed: function,
        child: Container(
          width: 250.0,
          height: 27.0,
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

  buildProfileButton() {
    bool isProfileOwner = currentUser == uid;
    if (isProfileOwner) {
      return buildButton(
        text: "Edit Profile",
        function: editProfile,
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
        User user = User.fromDocument(snapshot.data);
        return Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              SizedBox(height: 40,),
              CircleAvatar(
                backgroundImage: CachedNetworkImageProvider(user.photoURL),
                radius: 50,
              ),
              SizedBox(height: 10,),
              Text(
                user.displayName,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
              SizedBox(height: 5,),
              Text(
                user.email,
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(height: 3,),
              Text(
                user.bio,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20,),
              buildProfileButton(),
              // Row(
              //   mainAxisSize: MainAxisSize.min,
              //   children: <Widget>[
              //     FlatButton(
              //       child: Icon(
              //         Icons.message,
              //         color: Colors.white,
              //       ),
              //       color: Colors.grey,
              //       onPressed: (){},
              //     ),
              //     SizedBox(width: 10),
              //     FlatButton(
              //       child: Icon(
              //         Icons.add,
              //         color: Colors.white,
              //       ),
              //       color: Theme.of(context).accentColor,
              //       onPressed: (){},
              //     ),
              //   ],
              // ),
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
      appBar: header(context, titleText: "My Profile"),
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