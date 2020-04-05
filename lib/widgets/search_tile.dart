import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:peeklist/utils/user.dart';
import 'package:peeklist/widgets/progress.dart';

class SearchTile extends StatefulWidget {
  Map friends;

  String uid;

  SearchTile({Key key, @required this.uid, @required this.friends}) : super(key: key);

  @override
  _SearchTileState createState() => _SearchTileState();
}

class _SearchTileState extends State<SearchTile> with SingleTickerProviderStateMixin{
  bool friendReqSent = false;

  @override
  void initState() { 
    super.initState();
  }
  
  addFriend() async {
    await UserService().sendFriendRequest(widget.uid, widget.friends['uid']);
    print("Success");
    setState(() {
      friendReqSent = true;
    });
  }

  buildTile(bool reqSent) {
    return ListTile(
      onTap: () {
        Navigator.pushNamed(context, '/myprofile', arguments: widget.friends['uid']);
      },
      title: Text(
        widget.friends['displayName'],
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(
        widget.friends['email'],
        style: TextStyle(
          color: Colors.grey,
        ),
      ),
      leading: CircleAvatar(
        backgroundColor: Colors.grey,
        backgroundImage: CachedNetworkImageProvider(widget.friends['photoURL'])
      ),
      trailing: RaisedButton(
        child: reqSent == true || friendReqSent == true ? Text("Request Sent") : Text("Add Friend"),
        onPressed: reqSent == true || friendReqSent == true ? null : () => addFriend(),
        color: Theme.of(context).primaryColorLight,
        elevation: 5.0,
        disabledColor: Colors.green,
        disabledElevation: 5.0,
        disabledTextColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18.0),
        ),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: UserService().checkRequestSent(widget.uid, widget.friends['uid']),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text("Error ${snapshot.error}");
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return circularProgress();
        } else if (snapshot.connectionState == ConnectionState.done) {
          return buildTile(snapshot.data);
        }
      }
    );
  }
}