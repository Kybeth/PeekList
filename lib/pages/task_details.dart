import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:peeklist/models/comments.dart';
import 'package:peeklist/models/likes.dart';
import 'package:peeklist/utils/tasks.dart';
import 'package:peeklist/widgets/progress.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../models/social_model.dart';
import '../widgets/header.dart';

class TaskDetails extends StatefulWidget {
  final SocialModel task;
  final String uid;

  TaskDetails({ this.task, this.uid });
  @override
  _TaskDetailsState createState() => _TaskDetailsState();
}

class _TaskDetailsState extends State<TaskDetails> {
  String toggleListener = "likes";
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header(context, titleText: "Social Task"),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          buildTaskHeader(),
          Divider(),
          buildToggle(),
          Divider(),
          buildLikesComments(),
        ],
      ),
    );
  }

  buildTaskHeader() {
    return Padding(
        padding: EdgeInsets.all(16.0),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              CircleAvatar(
                radius: 40.0,
                backgroundColor: Colors.grey,
                backgroundImage: CachedNetworkImageProvider(widget.task.user['photoURL']),
              ),
              Expanded(
                flex: 1,
                child: Card(
                  child: Text(widget.task.name),
                ),
              ),
            ],
          ),
          Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(top: 12.0),
            child: Text(
              "${widget.task.user['displayName']}",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  buildToggle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        IconButton(
            icon: Icon(Icons.thumb_up),
            color: toggleListener == 'likes' ? Theme.of(context).primaryColor : Colors.grey,
            onPressed: () {
              setState(() {
                toggleListener = 'likes';
              });
            }
        ),
        IconButton(
            icon: Icon(Icons.comment),
            color: toggleListener != 'likes' ? Theme.of(context).primaryColor : Colors.grey,
            onPressed: () {
              setState(() {
                toggleListener = 'comments';
              });
            }
        ),
      ],
    );
  }

  buildLikesComments() {
    if (toggleListener == "likes") {
      return Expanded(
          child: StreamBuilder(
        stream: taskService.getLikes(widget.task.taskId),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return circularProgress();
            } else {
              return ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: snapshot.data.length,
                  itemBuilder: (context, int index) {
                    Likes likes = snapshot.data[index];
                    return buildLike(likes);
                  }
              );
            }
          }
      ),);
    } else {
      return Expanded(
        child: StreamBuilder(
          stream: taskService.getComments(widget.task.taskId),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return circularProgress();
            } else {
              return ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, int index) {
                    Comments comments = snapshot.data[index];
                    return buildComment(comments);
                  }
              );
            }
          },
        ),
      );
    }

  }

  buildLike(Likes likes) {
    return Column(
      children: <Widget>[
        ListTile(
          title: Text(likes.userMeta['displayName']),
          leading: CircleAvatar(
            backgroundImage: CachedNetworkImageProvider(likes.userMeta['photoURL']),
            backgroundColor: Colors.grey,
          ),
        ),
        Divider(),
      ],
    );
  }

  buildComment(Comments comment) {
    return Column(
      children: <Widget>[
        ListTile(
          title: Text(comment.message),
          leading: CircleAvatar(
            backgroundImage: CachedNetworkImageProvider(comment.userMeta['photoURL']),
            backgroundColor: Colors.grey,
          ),
          subtitle: Text(timeago.format(comment.posted.toDate())),
        ),
        Divider(),
      ],
    );
  }
}
