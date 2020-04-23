import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../models/friends.dart';
import '../utils/user.dart';
import '../widgets/header.dart';
import '../widgets/progress.dart';

class FriendsPage extends StatefulWidget {
  @override
  _FriendsPageState createState() => _FriendsPageState();
}

class _FriendsPageState extends State<FriendsPage> {
  String uid;

  @override
  Widget build(BuildContext context) {
    RouteSettings settings = ModalRoute.of(context).settings;
    uid = settings.arguments;
    return Scaffold(
      appBar: header(context, titleText: "Friends"),
      body: Column(
        children: <Widget>[
          Expanded(
              child: buildFriends(),
          ),
        ],
      ),
    );
  }

  buildFriends() {
    return StreamBuilder(
      stream: userService.getFriends(uid),
      builder: (context, asyncSnap) {
        if (asyncSnap.hasError) {
          return Text("Error ${asyncSnap.error}");
        } else if (asyncSnap.data == null) {
          return circularProgress();
        } else if (asyncSnap.data.length == 0) {
          return Text('No Friends');
        } else {
          return new ListView.builder(
            shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemCount: asyncSnap.data.length,
              itemBuilder: (context, int index) {
                Friends friends = asyncSnap.data[index];
                return buildFriendTile(friends);
              }
          );
        }
      },
    );
  }

  buildFriendTile(Friends friends) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.grey,
        backgroundImage: CachedNetworkImageProvider(friends.photoURL),
      ),
      title: Text(friends.displayName),
      subtitle: Text(friends.email),
      trailing: Text("${timeago.format(friends.friendSince.toDate())}"),
      onTap: () => Navigator.pushNamed(context, '/myprofile', arguments: friends.user),
    );
  }
}
