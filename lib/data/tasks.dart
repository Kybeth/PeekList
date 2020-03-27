import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:peeklist/utils/auth.dart';

class Showlist extends StatelessWidget {
  // you could use this to show a new list data with give it a list name

  final String uid;
  final String list;
  const Showlist({Key key, this.uid, this.list}) :super(key: key);


  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('tasks').where(
          'uid', isEqualTo: "$uid").where('list', isEqualTo: "$list").orderBy(
          'iscompleted', descending: false).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return Container();
        return _buildList(context, snapshot.data.documents);
      },
    );
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> list) {
    return ListView.builder(
        itemCount: list.length,
        itemBuilder: (context, idx) {
          DocumentSnapshot doc = list[idx];

          return ListTile(

            leading:
            IconButton(
              icon: changeicon_com(doc['iscompleted']),
              onPressed: () => completed(doc),

            ),

              trailing:
            IconButton(
                icon:changeicon_star(doc['isstarred']),
                onPressed: () => starred(doc)
            ),

            title: Text(doc['name'], style: returnstyle(doc['iscompleted']),),
            subtitle: Text(
                doc['comment'], style: returnstyle(doc['iscompleted'])),
          );
        }
    );
  }





    Future completed(DocumentSnapshot document) {
      if (document['iscompleted']) {
        document.reference.updateData({"iscompleted": false});
      }
      else {
        document.reference.updateData({"iscompleted": true});
      }
    }

  Future starred(DocumentSnapshot document) {
    if (document['isstarred']) {
      document.reference.updateData({"isstarred": false});
    }
    else {
      document.reference.updateData({"isstarred": true});
    }
  }

    returnstyle(bool completed) {
      if (completed) {
        return TextStyle(fontWeight: FontWeight.w200);
      }
      else {
        return TextStyle(fontWeight: FontWeight.normal);
      }

    }


  changeicon_com(bool completed) {
    return completed ? Icon(Icons.check_box) : Icon(
        Icons.check_box_outline_blank);
  }

  changeicon_star(bool completed) {
    return completed ? Icon(Icons.star) : Icon(
        Icons.star_border);
  }

}

class Showstar extends StatelessWidget {

  final String uid;
  const Showstar({Key key, this.uid}) :super(key: key);


  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('tasks').where(
          'uid', isEqualTo: "$uid").where('isstarred', isEqualTo: true).orderBy(
          'iscompleted', descending: false).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return Container();
        return _buildList(context, snapshot.data.documents);
      },
    );
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> list) {
    return ListView.builder(
        itemCount: list.length,
        itemBuilder: (context, idx) {
          DocumentSnapshot doc = list[idx];

          return ListTile(

            leading:
            IconButton(
              icon: changeicon_com(doc['iscompleted']),
              onPressed: () => completed(doc),

            ),

            trailing:
            IconButton(
                icon:changeicon_star(doc['isstarred']),
                onPressed: () => starred(doc)
            ),

            title: Text(doc['name'], style: returnstyle(doc['iscompleted']),),
            subtitle: Text(
                doc['comment'], style: returnstyle(doc['iscompleted'])),
          );
        }
    );
  }

  Future completed(DocumentSnapshot document) {
    if (document['iscompleted']) {
      document.reference.updateData({"iscompleted": false});
    }
    else {
      document.reference.updateData({"iscompleted": true});
    }
  }

  Future starred(DocumentSnapshot document) {
    if (document['isstarred']) {
      document.reference.updateData({"isstarred": false});
    }
    else {
      document.reference.updateData({"isstarred": true});
    }
  }

  returnstyle(bool completed) {
    if (completed) {
      return TextStyle(fontWeight: FontWeight.w200);
    }
    else {
      return TextStyle(fontWeight: FontWeight.normal);
    }

  }


  changeicon_com(bool completed) {
    return completed ? Icon(Icons.check_box) : Icon(
        Icons.check_box_outline_blank);
  }

  changeicon_star(bool completed) {
    return completed ? Icon(Icons.star) : Icon(
        Icons.star_border);
  }

}


class CompletedTask extends StatelessWidget {

  final String uid;
  const CompletedTask({Key key, this.uid}) :super(key: key);

  
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('tasks').where(
          'uid', isEqualTo: "$uid").where('iscompleted', isEqualTo: true).orderBy(
          'iscompleted', descending: false).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return Container();
        return _buildList2(context, snapshot.data.documents);
      },
    );
  }

  Widget _buildList2(BuildContext context, List<DocumentSnapshot> list) {
    return ListView.builder(
        itemCount: list.length,
        itemBuilder: (context, idx) {
          DocumentSnapshot doc = list[idx];

          return ListTile(

            leading:
            IconButton(
              icon: changeicon_com(doc['iscompleted']),
              onPressed: () => completed(doc),

            ),

            trailing:
            Icon(Icons.check),

            title: Text(doc['name'], style: returnstyle(doc['iscompleted']),),
            subtitle: Text(
                doc['comment'], style: returnstyle(doc['iscompleted'])),
          );
        }
    );
  }
  Future completed(DocumentSnapshot document) {
    if (document['iscompleted']) {
      document.reference.updateData({"iscompleted": false});
    }
    else {
      document.reference.updateData({"iscompleted": true});
    }
  }

  returnstyle(bool completed) {
    if (completed) {
      return TextStyle(fontWeight: FontWeight.w200);
    }
    else {
      return TextStyle(fontWeight: FontWeight.normal);
    }

  }


  changeicon_com(bool completed) {
    return completed ? Icon(Icons.check_box) : Icon(
        Icons.check_box_outline_blank);
  }


}

//queries for today page and planned page incomplete
/*
class TodayTask extends StatelessWidget {

  final String uid;
  const TodayTask({Key key, this.uid}) :super(key: key);

  
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('tasks').where(
          'uid', isEqualTo: "$uid").where('time', isEqualTo: DateTime.now()).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return Container();
        return _buildList3(context, snapshot.data.documents);
      },
    );
  }
}


class ShowPlanned extends StatelessWidget {

  final String uid;
  const ShowPlanned({Key key, this.uid}) :super(key: key);

  
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('tasks').where(
          'uid', isEqualTo: "$uid").where('time', isEqualTo: DateTime.now()).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return Container();
        return _buildList3(context, snapshot.data.documents);
      },
    );
  }
}
*/


class Tasks {
  final String name;
  final String uid;
  final String comment;
  final String list;
  final bool iscompleted;
  final bool isstarred;
  final time ;
  final bool isprivate;

//final Integer likes;
  //final String date;
  Tasks({
    this.name,
    this.uid,
    this.comment,
    this.list,
    this.iscompleted,
    this.isstarred,
    this.time,
    this.isprivate
    //this.like
  });

  Future<void> addtask() async {

    await Firestore.instance
        .collection('tasks')
        .add(<String, dynamic>{
      'uid': uid,
      'name': name,
      'comment': comment,
      'list': list!=null? list:'inbox',
      'time': time,
      'iscompleted': iscompleted,
      'isstarred' : isstarred,
      'isprivate' :isprivate
    });
  }
}