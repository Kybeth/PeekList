import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:peeklist/utils/auth.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class Showlist extends State<StatefulWidget> {
  // you could use this to show a new list data with give it a list name

  final String uid;
  final String list;
  Showlist({Key key, this.uid, this.list});


  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('tasks').where(
          'uid', isEqualTo: "$uid").where('list', isEqualTo: "$list").where('iscompleted', isEqualTo: false).snapshots(),
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
            child: Slidable(
              actionPane: SlidableDrawerActionPane(),
              actionExtentRatio: 0.25,
              child: Container(
                decoration: BoxDecoration(
                    border: Border(
                        left:BorderSide(
                          width: 5,
                          color: hasprivate(doc),
                        )
                    )
                ),
                height: 80,
                child: ListTile(
                  leading:
                  IconButton(
                    icon: changeicon_com(doc['iscompleted']),
                    onPressed: () => completed(doc),
                  ),

                  trailing:
                  IconButton(
                      icon:changeicon_star(doc['isstarred']),
                      onPressed: () => starred(doc)
                  ),


                  title: Text(doc['name'], style: returnstyle(doc['iscompleted']),),
                  subtitle: Text(
                      doc['comment'], style: returnstyle(doc['iscompleted'])),
                ),
              ),
              secondaryActions: <Widget>[
                IconSlideAction(
                  caption: pritext(doc),
                  color: priColor(doc),
                  icon: priIcon(doc),
                  onTap: () {
                    privated(doc);
//                    setState(() {
//                      hasprivate(doc);
//                    });
                    },
                )
              ],
            ),
          ) ;
        }
    );
  }




  hasprivate(DocumentSnapshot document){
    if(document.data.containsKey('isprivate') && document['isprivate']==false){
      return Colors.green;
    }
    else{
      return Colors.white;
    }
  }

  Future privated(DocumentSnapshot document) {
    if (!document.data.containsKey('isprivate')){
      document.reference.updateData({"isprivate": true});
    }
    else {
      if (document['isprivate']) {
        document.reference.updateData({"isprivate": false});
      }
      else {
        document.reference.updateData({"isprivate": true});
      }
    }
  }



    Future completed(DocumentSnapshot document) {
      if (document['iscompleted']) {
        document.reference.updateData({"iscompleted": false,'action':"cancel_complete",'actiontime':Timestamp.now()});
      }
      else {
        document.reference.updateData({"iscompleted": true,'action':"complete_task",'actiontime':Timestamp.now()});
      }
    }

  Future starred(DocumentSnapshot document) {
    if (document['isstarred']) {
      document.reference.updateData({"isstarred": false});
    }
    else {
      document.reference.updateData({"isstarred": true});
    }
  }

    returnstyle(bool completed) {
      if (completed) {
        return TextStyle(fontWeight: FontWeight.w200);
      }
      else {
        return TextStyle(fontWeight: FontWeight.normal);
      }

    }


  changeicon_com(bool completed) {
    return completed ? Icon(Icons.check_box) : Icon(
        Icons.check_box_outline_blank);
  }

  changeicon_star(bool completed) {
    return completed ? Icon(Icons.star) : Icon(
        Icons.star_border);
  }

  priColor(DocumentSnapshot document) {
    if (document.data.containsKey('isprivate') &&
        document['isprivate'] == false) {
      return Colors.green;
    }
    else {
      return Colors.red;
    }
  }

  pritext(DocumentSnapshot document) {
    if (document.data.containsKey('isprivate') &&
        document['isprivate'] == false) {
      return "open";
    }
    else {
      return "privated";
    }
  }

  priIcon (DocumentSnapshot document) {
    if (document.data.containsKey('isprivate') &&
        document['isprivate'] == false) {
      return Icons.remove_red_eye;
    }
    else {
      return Icons.block;
    }
  }
}

class Showstar extends StatelessWidget {

  final String uid;
  const Showstar({Key key, this.uid}) :super(key: key);


  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('tasks').where(
          'uid', isEqualTo: "$uid").where('isstarred', isEqualTo: true).where('iscompleted', isEqualTo: false).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return Container();
        return new Showlist().buildList(context, snapshot.data.documents);
      },
    );
  }
}


class CompletedTask extends StatelessWidget {

  final String uid;
  const CompletedTask({Key key, this.uid}) :super(key: key);

  
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('tasks').where(
          'uid', isEqualTo: "$uid").where('iscompleted', isEqualTo: true).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return Container();
        return new Showlist().buildList(context, snapshot.data.documents);
      },
    );
  }
}

//for getting todays date
DateTime now=DateTime.now();
DateTime before=DateTime(now.year,now.month,now.day,0,0,0,0,0);
DateTime after=DateTime(now.year,now.month,now.day,23,59,59,0,0);



class TodayTask extends StatelessWidget {
  //shows all tasks for today even if its past due time
  final String uid;
  TodayTask({Key key, this.uid}) :super(key: key);

  
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('tasks').where(
          'uid', isEqualTo: "$uid").where('time', isGreaterThan: Timestamp.fromDate(before)).where('time',isLessThanOrEqualTo: Timestamp.fromDate(after)).
      where('iscompleted', isEqualTo: false).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return Container();
        return new Showlist().buildList(context, snapshot.data.documents);
      },
    );
  }
}

class IncompleteTask extends StatelessWidget {

  final String uid;
  const IncompleteTask({Key key, this.uid}) :super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('tasks').where(
          'uid', isEqualTo: "$uid").where('time', isLessThanOrEqualTo: DateTime.now()) 
        .where('iscompleted', isEqualTo: false).snapshots(),
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
  final time ;
  final bool isprivate;
  final List likes;
  final List message;//friend's comment

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
    //this.like
  });

  Future<DocumentReference> addtask() async {

    var tasksid=await Firestore.instance
        .collection('tasks')
        .add(<String, dynamic>{
      'uid': uid,
      'name': name,
      'comment': comment,
      'list': list!=null? list:'inbox',
      'time': time,
      'iscompleted': iscompleted,
      'isstarred' : isstarred,
      'isprivate' :isprivate,
      'likes':[],
      'messages':[],
      'action':'create_task',
      'actiontime':Timestamp.now()
    });
    return tasksid;
  }
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
   changedata= await Firestore.instance.collection('tasks').where('uid',isEqualTo: uid).where('list',isEqualTo: old_name).getDocuments();
   await changedata.documents.forEach((element) {
     element.reference.updateData({'list':new_name});
   });
  }

  Future delete_list(String uid,String list_name)async{
    QuerySnapshot changedata;
    await Firestore.instance.collection('users').document(uid).updateData({
      'tasks':FieldValue.arrayRemove([list_name])
    });
    changedata=await Firestore.instance.collection('tasks').where('uid',isEqualTo: uid).where('list',isEqualTo: list_name).getDocuments();
    await changedata.documents.forEach((element) {
      element.reference.delete();
    });

  }
}