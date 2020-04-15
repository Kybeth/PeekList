import 'package:cloud_firestore/cloud_firestore.dart';

class SocialModel {
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
  final String taskId;
  final Map<dynamic, dynamic> user;

  SocialModel({
    this.name,
    this.uid,
    this.comment,
    this.list,
    this.iscompleted,
    this.isstarred,
    this.time,
    this.isprivate,
    this.likes,
    this.create,
    this.taskId,
    this.user,
  });

  factory SocialModel.fromDocument(DocumentSnapshot doc) {
    return SocialModel(
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
      user: doc['user'],
    );
  }
}