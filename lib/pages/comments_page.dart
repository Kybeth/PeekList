import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:peeklist/models/comments.dart';
import 'package:peeklist/models/social_model.dart';
import 'package:peeklist/utils/tasks.dart';
import 'package:peeklist/widgets/header.dart';
import 'package:peeklist/widgets/progress.dart';
import 'package:timeago/timeago.dart' as timeago;


class CommentsPage extends StatefulWidget {
  SocialModel task;
  String uid;

  CommentsPage({ this.task, this.uid });
  @override
  _CommentsPageState createState() => _CommentsPageState();
}

class _CommentsPageState extends State<CommentsPage> {
  TextEditingController commentController = TextEditingController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool commentValid = true;

  sendComment() async {
    setState(() {
      commentController.text.isEmpty ? commentValid = false : commentValid = true;
    });
    if (commentValid) {
      await taskService.uploadComment(widget.task.taskId, widget.uid, commentController.text);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      key: _scaffoldKey,
      appBar: header(context, titleText: "Leave a Comment"),
      body: Column(
        children: <Widget>[
          Expanded(
              child: buildComments(),
          ),
          Divider(),
          ListTile(
            title: TextFormField(
              controller: commentController,
              decoration: InputDecoration(
                labelText: "Write a comment",
              ),
            ),
            trailing: OutlineButton(
                onPressed: () => sendComment(),
              borderSide: BorderSide.none,
              child: Icon(Icons.send),
            ),
          ),
        ],
      ),
    );
  }

  buildComments() {
    return StreamBuilder(
      stream: taskService.getComments(widget.task.taskId),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return circularProgress();
          } else {
            return ListView.builder(
              itemCount: snapshot.data.length,
                itemBuilder: (context, int index) {
                  Comments comment = snapshot.data[index];
                  return buildDetail(comment);
                }
            );
          }
        }
    );
  }

  buildDetail(Comments comment) {
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
