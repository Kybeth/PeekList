import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:peeklist/models/social_model.dart';
import 'package:peeklist/models/user.dart';
import 'package:peeklist/pages/edit_profile.dart';
import 'package:peeklist/utils/auth.dart';
import 'package:peeklist/utils/user.dart';
import 'package:peeklist/widgets/header.dart';
import 'package:peeklist/widgets/progress.dart';
import 'package:peeklist/widgets/social_task.dart';
import 'package:google_fonts/google_fonts.dart';

class MyProfile extends StatefulWidget {

  @override
  _MyProfileState createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  String uid;
  String currentUser;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  getCurrentUser() async {
    String userId = await authService.userID();
    setState(() {
      currentUser = userId;
    });
  }


  addFriend(currUser, recUser) async {
    await UserService().sendFriendRequest(currUser, recUser);
    print("Success");
    
  }


  buildProfileButton(User currentProfile) {
    return StreamBuilder(
      stream: Firestore.instance.collection('users').document(currentUser).collection('friends').snapshots(),
      builder: (context,snapshots){
        if(!snapshots.hasData){
          return Container();
        }
        else{
          bool isProfileOwner = currentUser == currentProfile.uid;
          bool isFriends=false;
          List<DocumentSnapshot> doc =snapshots.data.documents;
          for (int i=0;i<doc.length;i++){
            if(uid==doc[i]['user']){
              isFriends=true;
            }
          }
          if (isProfileOwner) {
            return Container(
              child: ButtonBar(
                alignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  RaisedButton.icon(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => EditProfile(uid: uid))),
                    icon: Icon(Icons.edit),
                    label: Text("Edit Profile"),
                    color: Colors.orange[200],
                  ),
                  RaisedButton.icon(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return // this is not right!!
                            AlertDialog(
                              title:  Text(
                                  "Are you sure you want to logout?",
                                style: TextStyle(fontSize: 18),
                              ),
                              actions: <Widget>[
                                // usually buttons at the bottom of the dialog
                                FlatButton(
                                  highlightColor: Colors.grey[400],
                                  textColor: Colors.cyan[600],
                                  child: Text(
                                    "No, keep me here",
                                  ),
                                  onPressed: () {Navigator.of(context).pop();},
                                ),
                                FlatButton(
                                  textColor: Colors.red[400],
                                  highlightColor: Colors.grey[400],
                                  child:  Text(
                                    "Yes, log out",
                                    // style: TextStyle(color: Colors.red[400]),
                                  ),
                                  onPressed: (){
                                    authService.signOut();
                                    Navigator.of(context).pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
                                  },
                                ),
                              ],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            );
                        },
                      );
                    },
                    color: Colors.red[400],
                    icon: Icon(Icons.exit_to_app),
                    label: Text("Logout"),
                  ),
                ],
              ),
            );
          }
          else {

            return Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(top: 5.0),
                  child: showaddfriends(isFriends),
                ),
              ],
            );
          }
        }
      },
    );

  }

  buildProfileHeader(uid) {
    return FutureBuilder(
      future: userService.getUserById(uid),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return circularProgress();
        }
        User currentProfile = User.fromDocument(snapshot.data);
        return Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
//              SizedBox(height: 0,),
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
              SizedBox(height: 5,),
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
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
          centerTitle: false,
          backgroundColor: Theme.of(context).primaryColorLight,
          title: Text(
            'Profile',
            style: GoogleFonts.raleway(
              textStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 19.0,
                  fontWeight: FontWeight.w500
              ),
            ),
          ),
      ),
      body: Container(
        padding: EdgeInsets.all(15.0),
        child: Column(
          children: <Widget>[
            buildProfileHeader(uid),
            Divider(color: Theme.of(context).backgroundColor,),
            buildSocialTasks(uid),
          ],
        ),
      ),
    );
  }

  buildNoSocialTasks() {
    return Center(
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 25.0,),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                child:
                Text(
                  "Oops. This user has no public tasks yet.",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
              ),
            ]
        ),
      ),
    );
  }

  buildSocialTasks(String uid) {
    return StreamBuilder(
      stream: userService.getUserTimeline(uid),
        builder: (context, asyncSnap) {
          if (asyncSnap.hasError) {
            return Text("Error ${asyncSnap.error}");
          } else if (asyncSnap.data == null) {
            return circularProgress();
          } else if (asyncSnap.data.length == 0) {
            return buildNoSocialTasks();
          } else {
            return Expanded(
                child: ListView.builder(
                      scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: asyncSnap.data.length,
                        itemBuilder: (context, int index) {
                          // SocialModel tasks = asyncSnap.data[index];
                          SocialModel tasks = asyncSnap.data[asyncSnap.data.length - 1 - index]; // a primitive way to reverse order
                          return SocialTask(task: tasks, uid: uid,);
                        }
                    ),
            );
          }
        }
    );
  }

  showaddfriends(bool friend){
    if(!friend){
      return RaisedButton.icon(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0)
        ),
        onPressed: () => addFriend(currentUser,uid),
        icon: Icon(Icons.person_add),
        label: Text("Add Friend"),
        disabledColor: Colors.green[400],
      );
    }
    else{
      return Container();
    }
  }
}