import 'package:flutter/material.dart';
//import 'package:peeklist/pages/create_account.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:peeklist/pages/create_task.dart';
import 'package:peeklist/pages/inbox.dart';
import 'package:peeklist/models/tasklist.dart';
import 'package:peeklist/pages/tasklistpage.dart';
import 'package:peeklist/utils/auth.dart';
import '../utils/auth.dart';


class TaskPage extends StatefulWidget {
  // final FirebaseUser user;

  // TaskPage({Key key, this.user}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  final List<Tasklist> tasklist=[];
  Map<String, dynamic> _profile;

  final newlist = TextEditingController();

  @override
  void initState() { 
    super.initState();
    authService.profile.listen((state) => setState(() => _profile = state));
  }

  // void addTask() {
  //   List inbox = _profile['tasks']['inbox'];

  // }
  


  Future _addtomylist(String Listname)async {



    await Firestore.instance
        .collection('lists')
        .add(<String, dynamic>{
      'list':Listname,
    });
    tasklist.clear();
    Stream<QuerySnapshot> sp=await Firestore.instance.collection('lists').snapshots();
    sp.forEach((ds){
      List<DocumentSnapshot> ds1=ds.documents;
      ds1.forEach((element) {
       var newlist=Tasklist(listname: element['list']);
       setState(() {
         tasklist.add(newlist);
       });
    });
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: <Widget>[
          Container(

              child: Column(
            children: <Widget>[
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
                Row(children: <Widget>[
                  Icon(
                  Icons.inbox,
                  color: Colors.green,
                  size: 30.0,
                ),
                   RaisedButton(
                    child: Text('Inbox'),
                    onPressed: () async{
                      var uid=await AuthService().userID();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => BuildInbox(
                                uid: uid,
                              )));
                    }),
              ]),
                Padding(
                  padding: EdgeInsets.only(top: 25.0),
                   child: Center(
                     child: Text(
                    "My Lists",
                    style: TextStyle(
                      fontSize: 25.0,
                    ),
                  ),
                ),
              ),
                Card(
                  elevation: 5,
                  child: Container(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          TextField(
                            decoration:
                                InputDecoration(labelText: 'new list name'),
                            controller: newlist,
                          ),
                          RaisedButton(
                            child: Text('create list'),
                            textColor: Colors.blue,
                            onPressed: () {
                              //print(newtasklistinputController.text);
                              _addtomylist(newlist.text);
                            },
                          )
                        ],
                      ))),
                Column(
                children: tasklist.map((lst) {
                  return FlatButton(
                      child: Text(lst.listname),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => tasklistpage()));
                      });
                }).toList(),
              ),
            ]
          )),
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
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

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

