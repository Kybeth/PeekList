import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:peeklist/utils/auth.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class Messages{
  final String taskid;
  final String taskname;
  final String friendid;
  final String friendname;
  final String comment;

  Messages({
    this.taskid,
    this.taskname,
    this.friendid,
    this.friendname,
    this.comment
  });

  Future<DocumentReference> addmessages() async{
    var message;
    var messages=await Firestore.instance.collection('messages').add(<String, dynamic>{
      'taskid':taskid,
      'taskname':taskname,
      'friendid':friendid,
      'friendname':friendname,
      'comment':comment,
      'time':Timestamp.now()
    }).then((value) {
      message=value;
      Firestore.instance.collection('tasks').document(taskid).updateData(<String,dynamic>{
        'messages': FieldValue.arrayUnion([value.documentID])
      });
    });


    return message;
  }

  Future<DocumentReference> updatemessage(String message,String newcomment)async{

    await Firestore.instance.collection('messages').document(message).updateData(<String,dynamic>{
      'comment':newcomment,'time':Timestamp.now()
    });

  }


  Future<void> deletemessages(String message)async{
    var demessage= await Firestore.instance.collection('messages').document(message).get();
    var messageid=await demessage.documentID;
    var taskid=await demessage['taskid'];

    // Remove the 'capital' field from the document
    await Firestore.instance.collection('tasks').document(taskid).updateData(<String,dynamic>{
      'likes':FieldValue.arrayRemove([messageid])
    });
    await demessage.reference.delete();

  }

  }





