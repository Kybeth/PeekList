import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:peeklist/models/social_model.dart';
import 'package:peeklist/pages/root.dart';
import 'package:peeklist/utils/auth.dart';
import 'package:peeklist/utils/user.dart';
import 'package:peeklist/widgets/progress.dart';
import 'package:peeklist/widgets/social_task.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:peeklist/pages/create_task.dart';
import 'package:peeklist/pages/my_profile.dart';

class Timeline extends StatefulWidget {
  @override
  _TimelineState createState() => _TimelineState();
}

class _TimelineState extends State<Timeline> {
  String uid;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  getCurrentUser() async {
    String userId = await authService.userID();
    setState(() {
      uid = userId;
    });
  }

  @override
  Widget build(context) {
    return Scaffold(
      body: buildTimeline(),
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
            onTap: () async {
              var uid = await AuthService().userID();
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        CreateTask(choose_list: 'inbox', uid: uid, isPrivate: false)),
              );
            },
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

  buildTimeline() {
    return StreamBuilder(
      stream: userService.getTimeline(this.uid),
        builder: (context, asyncSnap) {
          if (asyncSnap.hasError) {
            return Text("Error ${asyncSnap.error}");
          } else if (asyncSnap.data == null) {
            return circularProgress();
          } else if (asyncSnap.data.length == 0) {
            return Text("No tasks in timeline");
          } else {
            return new
              Column(
              children: <Widget>[
                shownewmessage(),
                Divider(),
                ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemCount: asyncSnap.data.length,
                itemBuilder: (context, int index) {
                SocialModel tasks = asyncSnap.data[index];

                return SocialTask(task: tasks, uid: this.uid,);
                }
                )
              ],
            );

          }
        }
    );
  }

  shownewmessage(){
    return StreamBuilder(
      stream: Firestore.instance.collection('users').document(this.uid).snapshots(),
      builder: (context,snapshots){
        if(!snapshots.hasData){
          return Container();
        }
        else{
          AsyncSnapshot dsp=snapshots;
          return new ListTile(
            title: Text(dsp.data['displayName']),
            trailing: Icon(Icons.notifications),
            leading:
            InkWell(
              onTap: (){
                Navigator.pushNamed(context, '/myprofile', arguments: currentUser);
              },
              child:
              CircleAvatar(
                backgroundImage: CachedNetworkImageProvider(dsp.data['photoURL']),
                backgroundColor: Colors.white,
              ),));
        }},);
  }
}