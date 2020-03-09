import 'package:flutter/material.dart';
import 'package:peeklist/pages/create_account.dart';
import 'package:peeklist/pages/create_task.dart';
import 'package:peeklist/pages/inbox.dart';

class TaskPage extends StatefulWidget {
  // final FirebaseUser user;

  // TaskPage({Key key, this.user}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: <Widget>[
          Container(
            child: Column(children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 25.0),
                child: Center(
                  child: Text(
                    "Task Page",
                    style: TextStyle(
                      fontSize: 25.0,
                    ),
                  ),
                ),
              ),
              Row(
              children: <Widget>[
              Icon(
                Icons.inbox,
                color: Colors.green,
                size: 30.0,
              ),
              RaisedButton(
                  child: Text('Inbox'),
                  onPressed: () {
                    Navigator.push(context,
<<<<<<< HEAD
                        MaterialPageRoute(builder: (context) => InboxNavigate()));
=======
                        MaterialPageRoute(builder: (context) => BuildInbox()));
>>>>>>> 083fe9fbe587ac417e099aed069ac64d4bd7a101
                  }),
            ]),  ],)
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CreateTask()),
          );
        },
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

<<<<<<< HEAD
class InboxNavigate extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("inbox"),
      ),
      body: Center(
        child: RaisedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Go back!'),
        ),
      ),
    );
  }
}
=======


//Widget _buildBody(BuildContext context){
//  return StreamBuilder<QuerySnapshot>(
//    stream: Firestore.instance.collection('tasks').where('list',isEqualTo: 'inbox').snapshots(),
//     builder: (context, snapshot) {
//      if(!snapshot.hasData) return Container();
//      return _buildList(context,snapshot.data.documents);
//     },
//  );
//}
//
//Widget _buildList(BuildContext context,List<DocumentSnapshot> list){
//  return ListView.builder(
//      itemCount: list.length,
//      itemBuilder: (context,idx){
//        DocumentSnapshot doc =list[idx];
//        return ListTile(
//          title: Text(doc['name']),
//          subtitle: Text(doc['comment']),
//        );
//      }
//  );
//}
>>>>>>> 083fe9fbe587ac417e099aed069ac64d4bd7a101
