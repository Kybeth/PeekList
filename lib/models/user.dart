import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String uid;
  final String email;
  final String photoURL;
  final String displayName;
  final String bio;
  final List<dynamic> tasks;

  User({
    this.uid,
    this.email,
    this.photoURL,
    this.displayName,
    this.bio,
    this.tasks,
  });

  //deserialization - take a document snapshot and create an instance of user class
  factory User.fromDocument(DocumentSnapshot doc) {
    return User(
      uid: doc['uid'],
      email: doc['email'],
      photoURL: doc['photoURL'],
      displayName: doc['displayName'],
      bio: doc['bio'],
      tasks: doc['tasks'],
    );
  }
}