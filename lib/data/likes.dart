import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:peeklist/utils/auth.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class Likes{
  final String taskid;
  final String taskname;
  final String friendid;
  final String friendname;

  Likes({
    this.taskid,
    this.taskname,
    this.friendid,
    this.friendname
});

  Future<DocumentReference> addlikes() async{
    var likeref;
    var likes=await Firestore.instance.collection('likes').add(<String, dynamic>{
      'taskid':taskid,
      'taskname':taskname,
      'friendid':friendid,
      'friendname':friendname,
      'time':Timestamp.now()
    }).then((value) {
          likeref=value;
           Firestore.instance.collection('tasks').document(taskid).updateData(<String,dynamic>{
              'likes': FieldValue.arrayUnion([value.documentID])
        });
    });
    return likeref;
  }

  Future<void> deletelikes(String likes)async{
   var delike=await Firestore.instance.collection('likes').document(likes).get();
   var taskid=await delike['taskid'];
   var likeid=await delike.documentID;

    // Remove the 'capital' field from the document

    await Firestore.instance.collection('tasks').document(taskid).updateData(<String,dynamic>{
      'likes':FieldValue.arrayRemove([likeid])
    });
    await delike.reference.delete();

  }


  Future<DocumentSnapshot> getlikes(String likes)async{
    var likeinfo=await Firestore.instance.collection('like').document(likes).get();
    return likeinfo;
  }




}