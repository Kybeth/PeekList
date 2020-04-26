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

class MyProfile extends StatefulWidget {

  @override
  _MyProfileState createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  String uid;
  String currentUser;
  List friends=[];

  @override
  void initState() {
    super.initState();
    getCurrentUser();
    //getfriends();
  }

  getCurrentUser() async {
    String userId = await authService.userID();
    setState(() {
      currentUser = userId;
    });
  }

//  getfriends()async{
//   // var friendlist;
//    await Firestore.instance.collection('users').document(currentUser).collection('friends').snapshots().forEach((element) {
//      element.documents.forEach((doc) {
//        friends.add(doc['user']);
//      });
//    });
//    setState(() {
//      friends;
//    });
//  }


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
                    onPressed: () => Navigator.pushNamed(context, '/friends', arguments: uid),
                    color: Theme.of(context).accentColor,
                    icon: Icon(Icons.group),
                    label: Text("Friends"),
                  ),
                  FlatButton.icon(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => EditProfile(uid: uid))),
                    icon: Icon(Icons.edit),
                    label: Text("Edit Profile"),
                    color: Theme.of(context).primaryColorLight,
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
//    bool isProfileOwner = currentUser == currentProfile.uid;
//    bool isFriends= friends.contains(currentProfile.uid);
//    if (isProfileOwner) {
//      return Container(
//        child: ButtonBar(
//          alignment: MainAxisAlignment.center,
//          mainAxisSize: MainAxisSize.max,
//          children: <Widget>[
//            RaisedButton.icon(
//              shape: RoundedRectangleBorder(
//                borderRadius: BorderRadius.circular(16.0),
//              ),
//              onPressed: () => Navigator.pushNamed(context, '/friends', arguments: uid),
//              color: Theme.of(context).accentColor,
//              icon: Icon(Icons.group),
//              label: Text("Friends"),
//            ),
//            FlatButton.icon(
//              shape: RoundedRectangleBorder(
//                borderRadius: BorderRadius.circular(16.0),
//              ),
//                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => EditProfile(uid: uid))),
//                icon: Icon(Icons.edit),
//              label: Text("Edit Profile"),
//              color: Theme.of(context).primaryColorLight,
//            ),
//          ],
//        ),
//      );
//    } else {
//
//      return Column(
//        children: <Widget>[
//          Container(
//            padding: EdgeInsets.only(top: 5.0),
//            child: showaddfriends(isFriends,currentProfile),
//      ),
//    ],
//  );
//    }
  }

  buildProfileHeader(uid) {
    return FutureBuilder(
      future: userService.getUserById(uid),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return circularProgress();
        }
        User currentProfile = User.fromDocument(snapshot.data);
        //getCurrentUser();
        //getfriends();

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
      appBar: header(context, titleText: "Profile"),
      body: Container(
        padding: EdgeInsets.all(15.0),
        child: Column(
          children: <Widget>[
            buildProfileHeader(uid),
            Divider(),
            buildSocialTasks(uid),
          ],
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
            return Text("No Social Tasks");
          } else {
            return Expanded(
                child: ListView.builder(
                      scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: asyncSnap.data.length,
                        itemBuilder: (context, int index) {
                          SocialModel tasks = asyncSnap.data[index];
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
      return FlatButton.icon(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0)
        ),
        onPressed: () => addFriend(currentUser,uid),
        icon: Icon(Icons.person_add),
        label: Text("Add Friend"),
        color: Theme.of(context).primaryColorLight,
        colorBrightness: Brightness.dark,
      );
    }
    else{
      return Container();
    }
  }
}