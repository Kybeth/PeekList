import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class Showlist extends State<StatefulWidget> {
  // you could use this to show a new list data with give it a list name

  final String uid;
  final String list;
  Showlist({Key key, this.uid, this.list});


  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance
          .collection('pubTasks')
          .where('uid', isEqualTo: "$uid")
          .where('list', isEqualTo: "$list")
          .where('iscompleted', isEqualTo: false).orderBy('create',descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return Container();
        return buildList(context, snapshot.data.documents);
      },
    );
  }

  Widget buildList(BuildContext context, List<DocumentSnapshot> list) {
    return ListView.builder(

        itemCount: list.length,
        itemBuilder: (context, idx) {
          DocumentSnapshot doc = list[idx];
          return Container(
            color: Colors.white,
            child: Slidable(
              actionPane: SlidableDrawerActionPane(),
              actionExtentRatio: 0.25,
              child: Container(
                decoration: BoxDecoration(
                    border: Border(
                        left: BorderSide(
                  width: 6.5,
                  color: hasprivate(doc),
                ))),
                height: 60,
                child: ListTile(
                  leading: IconButton(
                    icon: changeicon_com(doc['iscompleted']),
                    onPressed: () => completed(doc),
                  ),
                  title: Text(
                    doc['name'],
                    style: returnstyle(doc['iscompleted']),
                  ),
                  subtitle: doc['comment'].length == 0 ? null : Text(
                      doc['comment'],
                      style: returnstyle(doc['iscompleted'])),
                   trailing: IconButton(
                       icon: changeicon_star(doc['isstarred']),
                       onPressed: () => starred(doc)),

                ),
              ),
              secondaryActions: <Widget>[
                /**
                IconSlideAction(
                  caption: pritext(doc),
                  color: priColor(doc),
                  icon: priIcon(doc),
                  onTap: () {
                    privated(doc);
                    Scaffold.of(context).showSnackBar(SnackBar(
                      content: changetext(doc) ,
                    ));
//                    setState(() {
//                      hasprivate(doc);
//                    });
                  },
                ), **/
                IconSlideAction(
                  caption: 'Delete',
                  color: Colors.red[400],
                  icon: Icons.delete,
                  onTap: () {
                    //deleted(doc);
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        // return object of type Dialog
                        return AlertDialog(
                          title:  Text("Delete task?"),
                          content:  Text(
                              "Deleting with remove all data associated with the task"),
                          actions: <Widget>[
                            // usually buttons at the bottom of the dialog
                            FlatButton(
                              child:Text("Cancel"),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            FlatButton(
                              child:  Text("Delete"),
                              onPressed: () {
                                deleted(doc);
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                )
              ],
            ),
          );
        });
  }

  hasprivate(DocumentSnapshot document) {
    if (document.data.containsKey('isprivate') &&
        document['isprivate'] == false) {
      return Colors.cyan[200];
    } else {
      return Colors.white;
    }
  }

  Future privated(DocumentSnapshot document) {
    if (!document.data.containsKey('isprivate')) {
      document.reference.updateData({"isprivate": true});
    } else {
      if (!document['isprivate']) {
        document.reference.updateData({"isprivate": true});
      }
    }
  }

  Future deleted(DocumentSnapshot document) {
    document.reference.delete();
  }


    Future completed(DocumentSnapshot document) {
      if (!document['iscompleted']) {
        document.reference.updateData({"iscompleted": true,'complete':Timestamp.now()});
      }
    }
  }
  changetext(DocumentSnapshot document){
      if(document['isprivate']){
        return Text('Private Task Status Can Not Change');
      }
      else{
        return Text('Task Status Changed');
      }
  }

  Future starred(DocumentSnapshot document) {
    if (document['isstarred']) {
      document.reference.updateData({"isstarred": false});
    } else {
      document.reference.updateData({"isstarred": true});
    }
  }

  returnstyle(bool completed) {
    if (completed) {
      return TextStyle(fontWeight: FontWeight.w200);
    } else {
      return TextStyle(fontWeight: FontWeight.normal);
    }
  }

  changeicon_com(bool completed) {
    return completed
        ? Icon(Icons.check_box)
        : Icon(Icons.check_box_outline_blank);
  }

  changeicon_star(bool completed) {
    return completed ? Icon(Icons.star,color: Colors.orange,) : Icon(Icons.star_border,color: Colors.orange[200],);
  }

  priColor(DocumentSnapshot document) {
    if (document.data.containsKey('isprivate') &&
        document['isprivate'] == false) {
      return Colors.orange[300];
    } else {
      return Colors.orange[300];
    }
  }

  pritext(DocumentSnapshot document) {
    if (document.data.containsKey('isprivate') &&
        document['isprivate'] == false) {
      return "Make Private";
    } else {
      return "Make Public";
    }
  }

  priIcon(DocumentSnapshot document) {
    if (document.data.containsKey('isprivate') &&
        document['isprivate'] == false) {
      return Icons.remove_red_eye;
    } else {
      return Icons.remove_red_eye;
    }
  }


class Showstar extends StatelessWidget {
  final String uid;
  const Showstar({Key key, this.uid}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance
          .collection('pubTasks')
          .where('uid', isEqualTo: "$uid")
          .where('isstarred', isEqualTo: true)
          .where('iscompleted', isEqualTo: false).orderBy('create',descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return Container();
        return new Showlist().buildList(context, snapshot.data.documents);
      },
    );
  }
}

class CompletedTask extends StatelessWidget {
  final String uid;
  const CompletedTask({Key key, this.uid}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance
          .collection('pubTasks')
          .where('uid', isEqualTo: "$uid")
          .where('iscompleted', isEqualTo: true).orderBy('complete',descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return Container();
        return new Showlist().buildList(context, snapshot.data.documents);
      },
    );
  }
}

//for getting todays date
DateTime now = DateTime.now();
DateTime before = DateTime(now.year, now.month, now.day, 0, 0, 0, 0, 0);
DateTime after = DateTime(now.year, now.month, now.day, 23, 59, 59, 0, 0);

class TodayTask extends StatelessWidget {
  //shows all tasks for today even if its past due time
  final String uid;
  TodayTask({Key key, this.uid}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance
          .collection('pubTasks')
          .where('uid', isEqualTo: "$uid")
          .where('time', isGreaterThan: Timestamp.fromDate(before))
          .where('time', isLessThanOrEqualTo: Timestamp.fromDate(after))
          .where('iscompleted', isEqualTo: false)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return Container();
        return new Showlist().buildList(context, snapshot.data.documents);
      },
    );
  }
}

class IncompleteTask extends StatelessWidget {
  final String uid;
  const IncompleteTask({Key key, this.uid}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance
          .collection('pubTasks')
          .where('uid', isEqualTo: "$uid")
          .where('iscompleted', isEqualTo: false).orderBy('create',descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return Container();
        return new Showlist().buildList(context, snapshot.data.documents);
      },
    );
  }
}

class Tasks {
  final String name;
  final String uid;
  final String comment;
  final String list;
  final bool iscompleted;
  final bool isstarred;
  final time;
  final create;
  final bool isprivate;
  final Map<dynamic, dynamic> likes;
  final List message;//friend's comment
  final String taskId;

//final Integer likes;
  //final String date;
  Tasks({
    this.name,
    this.uid,
    this.comment,
    this.list,
    this.iscompleted,
    this.isstarred,
    this.time,
    this.isprivate,
    this.likes,
    this.message,
    this.create,
    this.taskId,
    //this.like
  });

  factory Tasks.fromDocument(DocumentSnapshot doc) {
    return Tasks(
      name: doc['name'],
      uid: doc['uid'],
      comment: doc['comment'],
      list: doc['list'],
      iscompleted: doc['iscompleted'],
      isstarred: doc['isstarred'],
      time: doc['time'],
      isprivate: doc['isprivate'],
      likes: doc['likes'],
      create: doc['create'],
      taskId: doc.documentID,
    );
  }

  Future<DocumentReference> addtask() async {
    var tasksid=await Firestore.instance
        .collection('pubTasks')
        .add(<String, dynamic>{
      'uid': uid,
      'name': name,
      'comment': comment,
      'list': list != null ? list : 'inbox',
      'time': time,
      'iscompleted': iscompleted,
      'isstarred' : isstarred,
      'isprivate' :isprivate,
      'likes':{},
      'create':Timestamp.now(),
      'complete':null,
    });
    return tasksid;
  }
}

//this class is all functions of tasks
class TaskMethod{
  // 2020/4/7 return the list of documents likes and messages
  Future all_like(String taskid)async{
   QuerySnapshot likes= await Firestore.instance.collection('likes').where('taskid',isEqualTo: '$taskid').getDocuments();
   List<DocumentSnapshot> all_likes=await likes.documents;
   return all_likes;

  }

  Future all_message(String taskid)async{
    QuerySnapshot message= await Firestore.instance.collection('likes').where('taskid',isEqualTo: '$taskid').getDocuments();
    List<DocumentSnapshot> all_message=await message.documents;
    return all_message;
  }
}

//this class is all functions of list
class ListMethod{

  //rename a list
  Future rename_list(String uid, String old_name, String new_name) async{
    int index;
    QuerySnapshot changedata;
    await Firestore.instance.collection('users').document(uid).get().then((value){
      List lists=value['tasks'];
      index=lists.indexOf(old_name);
      lists[index]=new_name;
      value.reference.updateData({
        'tasks': lists
      });
    });
   changedata= await Firestore.instance.collection('pubTasks').where('uid',isEqualTo: uid).where('list',isEqualTo: old_name).getDocuments();
   await changedata.documents.forEach((element) {
     element.reference.updateData({'list':new_name});
   });
  }

  Future delete_list(String uid,String list_name)async{
    QuerySnapshot changedata;
    await Firestore.instance.collection('users').document(uid).updateData({
      'tasks':FieldValue.arrayRemove([list_name])
    });
    changedata=await Firestore.instance.collection('pubTasks').where('uid',isEqualTo: uid).where('list',isEqualTo: list_name).getDocuments();
    await changedata.documents.forEach((element) {
      element.reference.delete();
    });

  }
}