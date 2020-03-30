import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:peeklist/models/requests.dart';
import 'package:peeklist/utils/user.dart';
import 'package:peeklist/widgets/header.dart';

class NotificationsPage extends StatefulWidget {
  final String uid;

  NotificationsPage({ this.uid });

  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> with SingleTickerProviderStateMixin {
  TabController _tabController;
  bool isLoading = false;
  var notifications = [];

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
    getNotifications();
  }

  getNotifications() async {
    setState(() {
      isLoading = true;
    });
    QuerySnapshot doc = await UserService().getRequests(widget.uid);
    doc.documents.forEach((notification) {
      Requests req = Requests.fromDocument(notification);
      notifications.add(req);
    });
    // QuerySnapshot doc = await UserService().getRequests(widget.uid);
    // doc.documents.forEach((notification) => {

    // });
  }

  buildReceivedNotifications() {
    return Scaffold(
      body: ListView(
        children: <Widget>[
          SizedBox(height: 10.0,),
          ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              if (notifications[index]['type'] == 'received') {
                return ListTile(
                  onTap: () {
                    Navigator.pushNamed(context, 'myprofile', arguments: notifications[index]['user']);
                  },
                  leading: CircleAvatar(
                    backgroundColor: Colors.grey,
                    backgroundImage: CachedNetworkImageProvider(notifications[index]['photoURL']),
                  ),
                  title: Text(
                    notifications[index]['displayName'],
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    notifications[index]['email'],
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                  trailing: Text(
                    'Pending',
                    style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                );
              }
            }
          ),
        ],
      ),
    );
  }

  buildPendingNotifications() {
    return Scaffold(
      body: ListView(
        children: <Widget>[
          SizedBox(height: 10.0,),
          ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              if (notifications[index]['type'] == 'sent') {
                return ListTile(
                  onTap: () {
                    Navigator.pushNamed(context, 'myprofile', arguments: notifications[index]['user']);
                  },
                  leading: CircleAvatar(
                    backgroundColor: Colors.grey,
                    backgroundImage: CachedNetworkImageProvider(notifications[index]['photoURL']),
                  ),
                  title: Text(
                    notifications[index]['displayName'],
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    notifications[index]['email'],
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                  trailing: Text(
                    'Pending',
                    style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                );
              }
            }
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
         title: Text('Notifications'),
         bottom: TabBar(
           tabs: [
             Tab(
               text: "Pending",
             ),
             Tab(
               text: "Received",
             ),
           ],
           controller: _tabController,
         ),
       ),
       body: TabBarView(
         children: <Widget>[
           buildPendingNotifications(),
           buildReceivedNotifications(),
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