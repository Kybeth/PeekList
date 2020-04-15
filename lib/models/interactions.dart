import 'package:cloud_firestore/cloud_firestore.dart';

class Interactions {
  final int time;
  final String title;
  final String type;
  final Map<dynamic, dynamic> user;
  final Map<dynamic, dynamic> meta;

  Interactions({
    this.time,
    this.title,
    this.type,
    this.user,
    this.meta,
  });

  factory Interactions.fromDocument(DocumentSnapshot doc) {
    return Interactions(
      user: doc['user'],
      time: doc['time'],
      type: doc['type'],
      title: doc['title'],
      meta: doc['meta'],
    );
  }
}