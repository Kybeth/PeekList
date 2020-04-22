import 'package:cloud_firestore/cloud_firestore.dart';

class Comments {
  final String message;
  final Timestamp posted;
  final Map<dynamic, dynamic> userMeta;

  Comments({
    this.message,
    this.posted,
    this.userMeta,
});

  factory Comments.fromDocument(DocumentSnapshot doc) {
    return Comments(
      userMeta: doc['userMeta'],
      posted: doc['posted'],
      message: doc['message'],
    );
  }
}