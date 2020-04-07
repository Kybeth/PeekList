import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:peeklist/models/requests.dart';
import 'package:peeklist/utils/auth.dart';
import 'package:peeklist/utils/user.dart';
import 'package:peeklist/widgets/header.dart';
import 'package:peeklist/widgets/progress.dart';

class NotificationsPage extends StatefulWidget {

  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> with SingleTickerProviderStateMixin {
  TabController _tabController;
  bool isLoading = false;
  var notifications = [];
  String uid;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
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
            onPressed: () => UserService().acceptFriendRequest(uid, req),
          ),
          IconButton(
            icon: Icon(Icons.clear),
            onPressed: () => UserService().declineFriendRequest(uid, req),
          ),
        ],
      ),
    );
  }

  noRequestsCard() {
    return Text("No requests");
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
          return noRequestsCard();
        } else {
          return new ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            itemCount: asyncSnap.data.length,
            itemBuilder: (context, int index) {
              Requests req = asyncSnap.data[index];
              return buildRequest(uid, req);
            }
          );
        }
      }
    );
  }

  buildInteractions() {
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    RouteSettings settings = ModalRoute.of(context).settings;
    uid = settings.arguments;
    return Scaffold(
       appBar: AppBar(
         title: Text('Notifications'),
         bottom: TabBar(
           tabs: [
             Tab(
               text: "Interactions",
             ),
             Tab(
               text: "Friend Requests",
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
}