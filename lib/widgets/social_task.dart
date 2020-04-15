import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:peeklist/models/social_model.dart';
import 'package:peeklist/utils/tasks.dart';
import 'package:peeklist/widgets/task_details.dart';

import '../data/tasks.dart';

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
  TextEditingController comment = TextEditingController();
//  final _scaffoldKey = GlobalKey<ScaffoldState>();

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
    
    await TaskService().likeTask(widget.task, likes);

    print(likes);

  }

  unlike() async {
    setState(() {
      isLiked = false;
      likeCount -= 1;
      likes.remove(widget.uid);
    });
    await TaskService().likeTask(widget.task, likes);

  }

  buildComment() {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('New Comment'),
            content: TextField(
              controller: comment,
              decoration: InputDecoration(hintText: "Comments go here..."),
            ),
            actions: <Widget>[
              new FlatButton(
                  onPressed: () => sendComment(),
                  child: null
              ),
              new FlatButton(
                child: new Text('CANCEL'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });

  }

  viewPost() {
    showModalBottomSheet(
      isScrollControlled: true,
        context: context,
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.3,
          minChildSize: 0.1,
          maxChildSize: 0.8,
          builder: (BuildContext context, scrollController) {
            return Container(
              color: Theme.of(context).primaryColor,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(5.0),
                    child: Card(
                      elevation: 8.0,
//                          margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white70,
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(15.0),
                          child: Column(
                            children: <Widget>[
                              Text(widget.task.name),
                              Text(widget.task.comment),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      }
    );
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
                onTap: () => viewPost(),
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
                    onPressed: () => sendComment(),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  sendComment() {

  }
}
