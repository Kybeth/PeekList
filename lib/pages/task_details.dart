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
          Divider(
            thickness: 1,
            color: Colors.grey[300],
          ),
          buildToggle(),
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
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage: CachedNetworkImageProvider(
                    widget.task.user['photoURL']),
                backgroundColor: Colors.grey,
                radius: 18,
              ),
              contentPadding: EdgeInsets.all(2),
              title: Text(
                "${widget.task.user['displayName']}",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.cyan[900],
                ),
              ),
              onTap: () => Navigator.pushNamed(context, '/myprofile',
                  arguments: widget.task.user['uid']),
              trailing: Text(
                "${timeago.format(widget.task.create.toDate())}",
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: ListTile(
              contentPadding: EdgeInsets.all(2),
              //leading: widget.task.iscompleted == true
              //? Icon(Icons.check_box)
              //: Icon(Icons.check_box_outline_blank),
              title: Text(
                "${widget.task.name}",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                ),
              ),
              subtitle: Text(
                "${widget.task.comment}",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => TaskDetails(
                        task: widget.task,
                        uid: widget.uid,
                      ))),

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
        FlatButton(
            //icon: Icon(Icons.thumb_up),
            child: Text(
              "Likes",
              style: TextStyle(
                  color: toggleListener == 'likes' ? Colors.cyan[500] : Colors.grey[400],
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
              ),
            ),
            //color: toggleListener == 'likes' ? Theme.of(context).primaryColor : Colors.grey,
            onPressed: () {
              setState(() {
                toggleListener = 'likes';
              });
            }
        ),
        FlatButton(
            //icon: Icon(Icons.comment),
            child: Text(
              "Comments",
              style: TextStyle(
                  color: toggleListener == 'comments' ? Colors.cyan[500] : Colors.grey[400],
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
              ),
            ),
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
          dense: true,
          title: Text(
              likes.userMeta['displayName'],
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Colors.cyan[900],
            ),
          ),
          leading: CircleAvatar(
            backgroundImage: CachedNetworkImageProvider(likes.userMeta['photoURL']),
            backgroundColor: Colors.grey,
            radius: 15,
          ),
          onTap: () => Navigator.pushNamed(context, '/myprofile',
              arguments: likes.userMeta['uid']),
        ),
        Divider(),
      ],
    );
  }

  buildComment(Comments comment) {
    return Column(
      children: <Widget>[
        ListTile(

          leading: InkWell(
            child: CircleAvatar(
              backgroundImage: CachedNetworkImageProvider(comment.userMeta['photoURL']),
              backgroundColor: Colors.grey,
              radius: 15,
              ),
            onTap: () => Navigator.pushNamed(context, '/myprofile',
                arguments: comment.userMeta['uid']),
          ),
          title: Text(comment.message),
          subtitle: Text(
            timeago.format(comment.posted.toDate()),
            style: TextStyle(
              fontSize: 12
            ),
          ),
        ),
        Divider(),
      ],
    );
  }
}
