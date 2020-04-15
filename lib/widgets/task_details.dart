import 'package:flutter/material.dart';
import 'package:peeklist/models/social_model.dart';

class TaskDetails extends StatefulWidget {
  SocialModel task;
  String uid;
  TaskDetails({ this.task, this.uid });

  @override
  _TaskDetailsState createState() => _TaskDetailsState();
}

class _TaskDetailsState extends State<TaskDetails> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Container(
      child: DraggableScrollableSheet(
        initialChildSize: 0.3,
        minChildSize: 0.1,
        maxChildSize: 0.8,
        builder: (BuildContext context, myScrollController) {
          return Container(
            color: Theme
                .of(context)
                .primaryColor,
            child: Padding(
              padding: EdgeInsets.all(10.0),
              child: Column(
                children: <Widget>[
//                    Text(likeCount.toString()),
                  Text(widget.task.name),
                  Text(widget.task.comment),
                ],
              ),
            ),
          );
        },
      ),
    );
//    return Scaffold(
//      key: _scaffoldKey,
//      body: Container(
//        child: DraggableScrollableSheet(
//          initialChildSize: 0.3,
//          minChildSize: 0.1,
//          maxChildSize: 0.8,
//          builder: (BuildContext context, myScrollController) {
//            return Container(
//              color: Theme.of(context).primaryColor,
//              child: Padding(
//                padding: EdgeInsets.all(10.0),
//                child: Column(
//                  children: <Widget>[
////                    Text(likeCount.toString()),
//                    Text(widget.task.name),
//                    Text(widget.task.comment),
//                  ],
//                ),
//              ),
//            );
//          },
//        ),
//      ),
//    );
  }
}
