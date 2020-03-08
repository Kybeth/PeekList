import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Showlist extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('tasks').where('list',isEqualTo: 'inbox').snapshots(),
      builder: (context, snapshot) {
        if(!snapshot.hasData) return Container();
        return _buildList(context,snapshot.data.documents);
      },
    );
  }

  Widget _buildList(BuildContext context,List<DocumentSnapshot> list){
    return ListView.builder(
        itemCount: list.length,
        itemBuilder: (context,idx){
          DocumentSnapshot doc =list[idx];
          return ListTile(
            title: Text(doc['name']),
            subtitle: Text(doc['comment']),
          );
        }
    );
  }
}
