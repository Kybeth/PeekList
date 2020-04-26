import 'package:cloud_firestore/cloud_firestore.dart';

class Interactions {
  final int time;
  final String title;
  final String type;
  final Map<dynamic, dynamic> userMeta;
  final Map<dynamic, dynamic> metaData;
  final bool readed;

  Interactions({
    this.time,
    this.title,
    this.type,
    this.userMeta,
    this.metaData,
    this.readed

  });

  factory Interactions.fromDocument(DocumentSnapshot doc) {
    return Interactions(
      userMeta: doc['userMeta'],
      time: doc['time'],
      type: doc['type'],
      title: doc['title'],
      metaData: doc['metaData'],
      readed:doc['readed']
    );
  }
}