import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:peeklist/models/social_model.dart';
import 'package:peeklist/utils/auth.dart';
import 'package:peeklist/utils/user.dart';
import 'package:peeklist/widgets/progress.dart';
import 'package:peeklist/widgets/social_task.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:peeklist/pages/create_task.dart';

class Timeline extends StatefulWidget {
  @override
  _TimelineState createState() => _TimelineState();
}

class _TimelineState extends State<Timeline> {
  String uid;
 // List notificationlist;

  @override
  void initState() {
    super.initState();
    getCurrentUser();

    //getnotification();
  }

  getCurrentUser() async {
    String userId = await authService.userID();
    setState(() {
      uid = userId;
    });
  }
//  getnotification()async{
//    await Firestore.instance.collection('users').document(uid).collection('interactions').snapshots().forEach((element) {
//        notificationlist=element.documents;
//    });
//
//  }

  @override
  Widget build(context) {
    return Scaffold(
      backgroundColor: Color(0xFFE5E5E5),
      body: buildTimeline(),
      floatingActionButton: SpeedDial(
        backgroundColor: Theme.of(context).accentColor,
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
            backgroundColor: Theme.of(context).accentColor,
            child: Icon(Icons.person),
            label: "My Profile",
            onTap: () {
              Navigator.pushNamed(context, '/myprofile', arguments: uid);
            },
          ),
          SpeedDialChild(
            labelStyle: TextStyle(
              color: Colors.black,
            ),
            backgroundColor: Theme.of(context).accentColor,
            child: Icon(Icons.notifications),
            label: "Notification Center",
            onTap: () {
             // await Firestore.instance.collection('users').document(this.uid).updateData({'newnoti':false});
              Navigator.pushNamed(context, '/notifications', arguments: uid);
            },
          ),
          SpeedDialChild(
            labelStyle: TextStyle(
              color: Colors.black,
            ),
            backgroundColor: Theme.of(context).accentColor,
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
                Expanded(
                  child:  ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemCount: asyncSnap.data.length,
                      itemBuilder: (context, int index) {
                        SocialModel tasks = asyncSnap.data[index];

                        return SocialTask(task: tasks, uid: this.uid,);
                      }
                  ),)

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
            trailing:
            shownotification(dsp.data),
            leading:
            InkWell(
              onTap: (){
                Navigator.pushNamed(context, '/myprofile', arguments: this.uid);
              },
              child:
              CircleAvatar(
                backgroundImage: CachedNetworkImageProvider(dsp.data['photoURL']),
                backgroundColor: Colors.white,
              ),));
        }},);
  }


 shownotification(DocumentSnapshot dsp){
    if(dsp.data['newnoti']==true){
      return  new IconButton(
                  icon: Icon(Icons.notifications_none,color:Color.fromRGBO(255, 11, 267, 100),),
                  onPressed: (){
                   // await dsp.reference.updateData({'newnoti':false});
                    Navigator.pushNamed(context, '/notifications', arguments: uid);
                  });
    }
    else{
      return Text('');
    }
//    getnotification();
//    for(int i=0; i<notificationlist.length;i++){
//      if (notificationlist[i]['readed']!=true){
//        return  new IconButton(
//                  icon: Icon(Icons.notifications),
//                  onPressed: (){
//                    Navigator.pushNamed(context, '/notifications', arguments: uid);
//                  });
//      }
//    }
//    return Text('');
//    return StreamBuilder(
//      stream: Firestore.instance.collection('users').document(uid).collection('interactions').snapshots(),
//      builder: (context,snapshots){
//        if(!snapshots.hasData){
//          return Text('');
//        }
//        else {
//          var allinter=snapshots.data.documents;
//          var hadnoread;
//          for (int i=0; i<allinter.length; i++){
//            if(allinter[i]['readed']!=true){
//              hadnoread=true;
//              return  new IconButton(
//                  icon: Icon(Icons.notifications),
//                  onPressed: (){
//                    Navigator.pushNamed(context, '/notifications', arguments: uid);
//                  });
//            }
//          }
//          if(hadnoread!=true){
//            return Text('');
//          }
//
//        }
//      },
//    );
 }

}