import 'package:cloud_firestore/cloud_firestore.dart';

class Requests {
  final String user;
  final String type;
  final String displayName;
  final String email;
  final String photoURL;

  Requests({
    this.user,
    this.type,
    this.displayName,
    this.email,
    this.photoURL,
  });

  factory Requests.fromDocument(DocumentSnapshot doc) {
    return Requests(
      user: doc['user'],
      type: doc['type'],
      displayName: doc['displayName'],
      email: doc['email'],
      photoURL: doc['photoURL'],
    );
  }
}