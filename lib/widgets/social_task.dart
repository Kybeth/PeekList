import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:peeklist/models/social_model.dart';
import 'package:peeklist/pages/comments_page.dart';
import 'package:peeklist/utils/tasks.dart';

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
    return Card(
      elevation: 8.0,
      margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).accentColor,
        ),
        child: Padding(
          padding: EdgeInsets.all(5.0),
          child: Column(
            children: <Widget>[
              ListTile(
                contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                leading: CircleAvatar(
                  backgroundImage: CachedNetworkImageProvider(widget.task.user['photoURL']),
                  backgroundColor: Colors.grey,
                ),
                title: Text(widget.task.name),
                subtitle: Text(widget.task.comment),
                onTap: () => print("Tapped"),
              ),
              ButtonBar(
                children: <Widget>[
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: isLiked == true ? Colors.blue : Colors.white,
                    child: IconButton(
                      icon: Icon(Icons.thumb_up),
                      onPressed: isLiked == true ? unlike : handleLike,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.comment),
                    onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => CommentsPage(task: widget.task, uid: widget.uid,))),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
