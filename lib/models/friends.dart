import 'package:cloud_firestore/cloud_firestore.dart';

class Friends {
  final String user;
  final String displayName;
  final String email;
  final String photoURL;
  final friendSince;

  Friends({
    this.user,
    this.displayName,
    this.email,
    this.photoURL,
    this.friendSince,
  });

  factory Friends.fromDocument(DocumentSnapshot doc) {
    return Friends(
      user: doc['user'],
      displayName: doc['displayName'],
      email: doc['email'],
      photoURL: doc['photoURL'],
      friendSince: doc['friendSince'],
    );
  }
}