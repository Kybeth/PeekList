import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:peeklist/models/social_model.dart';
import 'package:peeklist/pages/comments_page.dart';
import 'package:peeklist/pages/task_details.dart';
import 'package:peeklist/utils/tasks.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../pages/comments_page.dart';

class SocialTask extends StatefulWidget {

  SocialModel task;
  String uid;

  SocialTask({ this.task, this.uid });

  @override
  _SocialTaskState createState() => _SocialTaskState();
}

class _SocialTaskState extends State<SocialTask> {
  bool isLiked;
  int likeCount;
  Map likes;

  @override
  void initState() {
    super.initState();
    isLiked = widget.task.likes[widget.uid];
    likeCount = widget.task.likes.length;
    likes = widget.task.likes;
  }

  handleLike() async {
    print(widget.task.likes);
    setState(() {
      isLiked = true;
      likeCount += 1;
      likes[widget.uid] = true;
    });
    
    await taskService.likeTask(widget.uid, widget.task, likes);

    print(likes);

  }

  unlike() async {
    setState(() {
      isLiked = false;
      likeCount -= 1;
      likes.remove(widget.uid);
    });
    await taskService.unlikeTask(widget.uid, widget.task, likes);

  }
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.0,),
      child: InkWell(
        child: Column(
          children: <Widget>[
            ListTile(
              leading: CircleAvatar(
                backgroundImage: CachedNetworkImageProvider(widget.task.user['photoURL']),
                backgroundColor: Colors.grey,
              ),
              contentPadding: EdgeInsets.all(2),
              title: Text(
                "${widget.task.user['displayName']}",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => TaskDetails(task: widget.task, uid: widget.uid,))),
              trailing: Text("${timeago.format(widget.task.create.toDate())}"),
            ),
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              child: ListTile(
                contentPadding: EdgeInsets.all(2),
                leading: widget.task.iscompleted == true ? Icon(Icons.check_box) : Icon(Icons.check_box_outline_blank),
                title: Text(
                "${widget.task.name}",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
                subtitle: Text("${widget.task.comment}"),
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => TaskDetails(task: widget.task, uid: widget.uid,))),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text("${this.likeCount}"),
                    IconButton(
                      icon: Icon(Icons.thumb_up),
                      color: isLiked == true ? Colors.blue : Colors.black,
                      onPressed: isLiked == true ? unlike : handleLike,
                    ),
                    IconButton(
                      icon: Icon(Icons.comment),
                      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => CommentsPage(task: widget.task, uid: widget.uid,))),
                    ),
                  ],
                ),
              ),
          ),
            Divider(),

          ],
        ),
      ),
    );
  }
}
