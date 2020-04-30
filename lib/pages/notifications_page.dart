import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:peeklist/models/interactions.dart';
import 'package:peeklist/models/requests.dart';
import 'package:peeklist/utils/user.dart';
import 'package:peeklist/widgets/progress.dart';
import 'package:peeklist/pages/create_task.dart';
import 'package:peeklist/utils/auth.dart';

import '../models/requests.dart';
import '../utils/user.dart';

class NotificationsPage extends StatefulWidget {
  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  bool isLoading = false;
  var notifications = [];
  String uid;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }
  
  acceptFriendRequest(uid, Requests req) async {
    await userService.acceptFriendRequest(uid, req);
    showDialog(
        context: context,
      builder: (BuildContext context) {
          return AlertDialog(
            title: Text("You are now friends with ${req.displayName}"),
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("Close"),
              ),
            ],
          );
      }
    );
    
  }

  declineFriendRequest(uid, Requests req) async {
    await userService.declineFriendRequest(uid, req);
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Friend Request from ${req.displayName} declined"),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("Close"),
              ),
            ],
          );
        }
    );

  }

  buildRequest(uid, Requests req) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.grey,
        backgroundImage: CachedNetworkImageProvider(req.photoURL),
      ),
      title: Text(req.displayName),
      subtitle: Text(req.email),
      trailing: Wrap(
        spacing: 15,
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.check),
            color: Colors.lightGreen,
            onPressed: () => acceptFriendRequest(uid, req),
          ),
          IconButton(
            icon: Icon(Icons.clear),
            color: Colors.red[400],
            onPressed: () => declineFriendRequest(uid, req),
          ),
        ],
      ),
    );
  }

  buildNoFriendRequests() {
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
              ListTile(
                leading: CircleAvatar(
                  backgroundImage:  AssetImage('assets/images/PeekListLogo.png'),
                  //backgroundColor: Colors.grey,
                  radius: 13,
                ),
                title: Text(
                  'PeekList',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.cyan[900],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child:
                Text(
                  "You have no pending friend requests. Here's something you can do",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
              ),
              ButtonBar(
                  children: <Widget>[
                    FlatButton(
                      child: const Text(
                        'Add new friends',
                        style: TextStyle(color: Colors.orange, fontSize: 15,),
                      ),
                      onPressed: () =>
                          Navigator.pushNamed(context, '/search', arguments: uid)
                    ),
                  ]
              ),
            ]
        ),
      ),
    );
  }

  buildNoInteractions() {
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
              ListTile(
                leading: CircleAvatar(
                  backgroundImage:  AssetImage('assets/images/PeekListLogo.png'),
                  //backgroundColor: Colors.grey,
                  radius: 13,
                ),
                title: Text(
                  'PeekList',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.cyan[900],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child:
                Text(
                  "You have no social notifications. Here's something you can do",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
              ),
              ButtonBar(
                  children: <Widget>[
                    FlatButton(
                        child: const Text(
                          'Add public task',
                          style: TextStyle(color: Colors.cyan, fontSize: 15,),
                        ),
                        onPressed: () async {
                          var uid = await AuthService().userID();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    CreateTask(choose_list: 'inbox', uid: uid, isPrivate: false)),
                          );
                        },
                    ),
                    FlatButton(
                        child: const Text(
                          'Add new friends',
                          style: TextStyle(color: Colors.orange, fontSize: 15,),
                        ),
                        onPressed: () =>
                            Navigator.pushNamed(context, '/search', arguments: uid)
                    ),
                  ]
              ),
            ]
        ),
      ),
    );
  }

  buildFriendRequests(uid) {
    return StreamBuilder(
        stream: UserService().getRequests(uid),
        builder: (context, asyncSnap) {
          if (asyncSnap.hasError) {
            return Text("Error ${asyncSnap.error}");
          } else if (asyncSnap.data == null) {
            return circularProgress();
          } else if (asyncSnap.data.length == 0) {
            return buildNoFriendRequests();
          } else {
            return new ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemCount: asyncSnap.data.length,
                itemBuilder: (context, int index) {
                  Requests req = asyncSnap.data[index];
                  return buildRequest(uid, req);
                });
          }
        });
  }

  buildInteractions() {
    return StreamBuilder(
      stream: userService.getInteractions(uid),
      builder: (context, asyncSnap) {
        if (asyncSnap.hasError) {
          return Text("Error ${asyncSnap.error}");
        } else if (asyncSnap.data == null) {
          return circularProgress();
        } else if (asyncSnap.data.length == 0) {
          return buildNoInteractions();
        } else {
          userService.updateIntertions(uid);
          return new ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemCount: asyncSnap.data.length,
              itemBuilder: (context, int index) {
                //allintertnumber=asyncSnap.data.length;
                Interactions inter = asyncSnap.data[index];
                return buildInter(inter);
              });
        }
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
          'Notifications',
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
            textStyle: TextStyle(fontSize: 15.0),
          ),
          labelColor: Colors.cyan[700],
          unselectedLabelColor: Colors.grey[500],
          tabs: [
            Tab(
              icon: Icon(Icons.notifications_none),
              //text: "Interactions",
            ),
            Tab(
              icon: Icon(Icons.person_add),
              //text: "Friend Requests",
            ),
          ],
          controller: _tabController,
        ),
      ),
      body: TabBarView(
        children: <Widget>[
          buildInteractions(),
          buildFriendRequests(uid),
        ],
        controller: _tabController,
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  buildInter(Interactions inter) {
    return Container(
      color: Colors.white,
      child: Column(
        children: <Widget>[
          ListTile(
            leading: Stack(
                children: <Widget>[
                CircleAvatar(
                //backgroundColor: Colors.white,
                radius: 20,
                backgroundImage: CachedNetworkImageProvider(inter.userMeta['photoURL']),
              ),
              Positioned(
                top: 22,
                left:22,
                child:
                CircleAvatar(
                  radius: 10,
                  backgroundColor: Colors.white,
                  child: Icon(
                    inter.type == 'like'? Icons.thumb_up : (inter.type == 'comment' ? Icons.comment : Icons.people),
                    color: Colors.cyan,
                    size: 14,
                  ),
                ),
              ),
            ]
            ),
              title: Text(inter.title),
            //subtitle: Text('Type: ${inter.type}'),
            ),
          Divider(),
        ],
      ),
    );


  }
}
