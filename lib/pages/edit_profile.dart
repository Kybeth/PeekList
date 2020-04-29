import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import "package:flutter/material.dart";
import 'package:google_fonts/google_fonts.dart';
import 'package:peeklist/models/user.dart';
import 'package:peeklist/utils/auth.dart';
import 'package:peeklist/utils/user.dart';
import 'package:peeklist/widgets/progress.dart';

class EditProfile extends StatefulWidget {
  final String uid;

  EditProfile({ this.uid });

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController displayNameController = TextEditingController();
  TextEditingController bioController = TextEditingController();
  bool isLoading = false;
  User user;
  bool _displayNameValid = true;
  bool _bioValid = true;

  @override
  void initState() {
    super.initState();
    getUser();
  }

  getUser() async {
    setState(() {
      isLoading = true;
    });
    DocumentSnapshot doc = await UserService().getUserById(widget.uid);
    user = User.fromDocument(doc);
    displayNameController.text = user.displayName;
    bioController.text = user.bio;
    setState(() {
      isLoading = false;
    });
  }

  Column buildDisplayNameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 12.0),
          child: Text(
            "Display Name",
            style: TextStyle(
              color: Colors.grey,
            ),
          ),
        ),
        TextField(
          controller: displayNameController,
          decoration: InputDecoration(
            hintText: "Update Display Name",
            errorText: _displayNameValid ? null : "Display name too short"
          ),
        ),
      ],
    );
  }

  Column buildBioField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 12.0),
          child: Text(
            "Status",
            style: TextStyle(
              color: Colors.grey,
            ),
          ),
        ),
        TextField(
          controller: bioController,
          decoration: InputDecoration(
            hintText: "Update Status",
            errorText: _bioValid ? null : "Status too long"
          ),
        ),
      ],
    );
  }

  updateProfileData() async {
    setState(() {
      displayNameController.text.trim().length < 3 ||
      displayNameController.text.isEmpty ? _displayNameValid = false :
      _displayNameValid = true;
      bioController.text.trim().length > 100 ? _bioValid = false :
      _bioValid = true;
    });

    if (_displayNameValid && _bioValid) {
      var x = await UserService().updateUserProfile(widget.uid, displayNameController.text, bioController.text);
      print(x);
      SnackBar snackBar = SnackBar(content: Text("Profile Updated"),);
      _scaffoldKey.currentState.showSnackBar(snackBar);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColorLight,
        centerTitle: true,
        title: Text(
          "Edit Profile",
          style: GoogleFonts.raleway(
            textStyle: TextStyle(
              color: Colors.black,
              fontSize: 20.0,
            ),
          )
        ),
        actions: <Widget>[
          IconButton(
            onPressed: updateProfileData,//() => Navigator.pop(context),
            icon: Icon(
              Icons.done,
              size: 30.0,
              color: Colors.green,
            ),
          ),
        ],
      ),
      body: isLoading ? circularProgress() : ListView(
        children: <Widget>[
          Container(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top:16.0, bottom: 8.0,),
                  child: CircleAvatar(
                    radius: 50.0,
                    backgroundImage: CachedNetworkImageProvider(user.photoURL)
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    children: <Widget>[
                      buildDisplayNameField(),
                      buildBioField(),
                    ],
                  ),
                ),
                RaisedButton.icon(
                  //color: Theme.of(context).accentColor,
                  onPressed: updateProfileData,
                  icon: Icon(Icons.check),
                  label: Text(
                    "Looks good",
                  ),
                  elevation: 1,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}