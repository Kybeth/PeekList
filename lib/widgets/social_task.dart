import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:peeklist/models/social_model.dart';
import 'package:peeklist/pages/comments_page.dart';
import 'package:peeklist/pages/task_details.dart';
import 'package:peeklist/utils/tasks.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:peeklist/utils/auth.dart';
import '../pages/comments_page.dart';

class SocialTask extends StatefulWidget {
  SocialModel task;
  String uid;
  SocialTask({this.task, this.uid});
  @override
  _SocialTaskState createState() => _SocialTaskState();
}

class _SocialTaskState extends State<SocialTask> {
  bool isLiked = false;
  int likeCount = 0;
  Map likes;
  String currentUser;


  @override
  void initState() {
    super.initState();
    widget.task.likes[widget.uid] != null ? isLiked = widget.task.likes[widget.uid] : isLiked = false;
    likeCount = widget.task.likes.length;
    likes = widget.task.likes;
    getCurrentUser();
  }

  getCurrentUser() async {
    String userId = await authService.userID();
    setState(() {
      currentUser = userId;
    });
  }

  handleLike() async {
    //print(widget.task.likes);
    setState(() {
      isLiked = true;
      likeCount += 1;
      likes[widget.uid] = true;
    });

    await taskService.likeTask(widget.uid, widget.task, likes);

    //print(likes);
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
      padding: EdgeInsets.symmetric(
        horizontal: 25.0,
      ),
      child: InkWell(
        child: Column(
          children: <Widget>[
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Stack(
                children: <Widget>[
                  Positioned(
                    top: 10,
                    left:150,
                    child: Opacity(
                      opacity:  widget.task.iscompleted ? 0.5 : 0.0,
                      child: Image.asset(
                        'assets/images/Done_postmark.png',
                        width: 110,
                      )
                  ),
                  ),


                  Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(left: 10.0, top: 5.0, right: 10.0),
                        child: ListTile(
                          dense: true,
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
                      GestureDetector(
                        onLongPress: (currentUser == widget.task.user['uid']) ? () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                             return // this is not right!!
                                AlertDialog(
                                  title:  Text("Delete From Timeline?"),
                                  content:  Text(
                                      "This will delete task from Timeline but keep it as a private task"),
                                  actions: <Widget>[
                                    // usually buttons at the bottom of the dialog
                                    FlatButton(
                                      highlightColor: Colors.grey[400],
                                      textColor: Colors.cyan[600],
                                      child: Text(
                                        "No, keep Public",
                                      ),
                                      onPressed: () {Navigator.of(context).pop();},
                                    ),
                                    FlatButton(
                                      textColor: Colors.red[400],
                                      highlightColor: Colors.grey[400],
                                      child:  Text(
                                        "Yes, delete",
                                        // style: TextStyle(color: Colors.red[400]),
                                      ),
                                      onPressed: () async{
                                        try{
                                        await deletetask(widget.task.taskId);}
                                        catch(e){
                                          Navigator.of(context).pop();
                                          await deletetimeline(widget.task.taskId,currentUser);
                                        }
                                        finally{
                                        Navigator.of(context).pop();}
                                      },
                                    ),
                                  ],
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                );
                            },
                          );
                        } : null,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10.0),
                          child: ListTile(
                            dense: false,
                            contentPadding: EdgeInsets.symmetric(horizontal: 2),

                            title: Text(
                              "${widget.task.name}",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                            subtitle: widget.task.comment.length == 0 ? null : Text(
                              "${widget.task.comment}",
                              style: TextStyle(
                                fontSize: 13,
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
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Text("${this.likeCount}"),
                                IconButton(
                                  padding: EdgeInsets.all(0.0),
                                  icon: Icon(Icons.thumb_up, size: 18,),
                                  color: isLiked == true ? Colors.cyan[700] : Colors.grey[500],
                                  onPressed: isLiked == true ? unlike : handleLike,
                                ),
                                IconButton(
                                  padding: EdgeInsets.all(0.0),
                                  icon: Icon(Icons.comment, size: 18,),
                                  color: Colors.grey[500],
                                  onPressed: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => CommentsPage(
                                            task: widget.task,
                                            uid: widget.uid,
                                          ))),
                                ),
                              ],
                            ),
                            //
                          ),
                        ),
                      ),


                    ],
                  ),
                ],
              )

            ),
            Divider(color: Theme.of(context).backgroundColor),
          ],
        ),
      ),
    );
  }

  deletetask(String taskid)async{
    await Firestore.instance.collection('pubTasks').document(taskid).updateData({'isprivate':true});
  }
  deletetimeline(String taskid,String userid )async{
    Firestore db=Firestore.instance;
    await db.collection('users').document(userid).collection('friends').snapshots().forEach((element) {
      db.collection('users').document(userid).collection('timeline').document(taskid).delete();
      element.documents.forEach((doc) {
        db.collection('users').document(doc.documentID).collection('timeline').document(taskid).delete();
      });
    });

  }
}
