import 'package:cloud_firestore/cloud_firestore.dart';

class Likes {
  final Map<dynamic, dynamic> metaData;
  final Map<dynamic, dynamic> userMeta;
  final String title;

  Likes({
    this.userMeta,
    this.metaData,
    this.title,
  });

  factory Likes.fromDocument(DocumentSnapshot doc) {
    return Likes(
      userMeta: doc['userMeta'],
      metaData: doc['metaData'],
      title: doc['title'],
    );
  }
}