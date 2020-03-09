import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Showlist extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('tasks').where('list',isEqualTo: 'inbox').orderBy('iscompleted').snapshots(),
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
              leading:
              IconButton(
                  icon:changeicon(doc['iscompleted']),
                  onPressed: () => completed(doc),
                      //doc.reference.updateData({"iscompleted":true}),
              ),

              title: Text(doc['name'],style: returnstyle(doc['iscompleted']),),
              subtitle: Text(doc['comment'],style: returnstyle(doc['iscompleted'])),

          );

        }
    );
  }

  Future completed(DocumentSnapshot document){
    if(document['iscompleted']){
      document.reference.updateData({"iscompleted":false});
    }
    else{
      document.reference.updateData({"iscompleted":true});
    }
//      final DocumentReference taskRef=document.reference;
//      Firestore.instance.runTransaction((transaction) async=>{await transaction.update(taskRef,{'iscompleted':true})});
  }

  returnstyle(bool completed){
    if(completed){
      return TextStyle(fontWeight: FontWeight.w200 );
    }
    else{
      return TextStyle(fontWeight: FontWeight.normal);
    }
  }
}
 changeicon(bool completed){
  return completed? Icon(Icons.check_box):Icon(Icons.check_box_outline_blank);
 }