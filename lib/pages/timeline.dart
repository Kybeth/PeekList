import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:peeklist/widgets/progress.dart';

import '../widgets/header.dart';

final userRef = Firestore.instance.collection('users');

class Timeline extends StatefulWidget {
  @override
  _TimelineState createState() => _TimelineState();
}

class _TimelineState extends State<Timeline> {

  List<dynamic> users;

  @override
  void initState() {
    // getUsers();
    // getUserById();
    super.initState();
    
  }

  createUser() async {
    userRef.add({
      
    });
  }

  // getUsers() async {
  //   // final QuerySnapshot snapshot = await userRef.where("isAdmin", isEqualTo: true).getDocuments();
  //   final QuerySnapshot snapshot = await userRef
  //   .where("postsCount", isGreaterThan: 0)
  //   .where("isAdmin", isEqualTo: true)
  //   .getDocuments();
  //   snapshot.documents.forEach((DocumentSnapshot doc) {
  //     print(doc.data);
  //   });
  // }

  // getUsers() async {
  //   final QuerySnapshot snapshot = await userRef.getDocuments();
  //   setState(() {
  //     users = snapshot.documents;
  //   });
  // }

  // getUserById() {
  //   final String id = "pUXFP82zvWSHEfD8vMXt";
  //   userRef.document(id).get().then((DocumentSnapshot doc) {
  //     print(doc.data);
  //   });
  // }

  // getUserById() async {
  //   final String id = "pUXFP82zvWSHEfD8vMXt";
  //   final DocumentSnapshot doc = await userRef.document(id).get();
  //   print(doc.data);
  // }

  // getUsers() {
  //   userRef.getDocuments().then((QuerySnapshot snapshot) {
  //     snapshot.documents.forEach((DocumentSnapshot doc) {
  //       print(doc.data);
  //       print(doc.documentID);
  //     });
  //   });
  // }

  @override
  Widget build(context) {
    return Scaffold(
      appBar: header(context, isAppTitle: true),
      body: FutureBuilder<QuerySnapshot>( //StreamBuilder - to get a stream of data in real time
        future: userRef.getDocuments(), //stream: userRef.snapshots() - instead of future
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return circularProgress();
          }
          final List<Text> children = snapshot.data.documents.map((doc) => Text(doc['username'])).toList();
          return Container(
            child: ListView(
              children: children,
            ),
          );
        },
      ),
    );
  }
}