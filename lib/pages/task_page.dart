import 'package:flutter/material.dart';
//import 'package:peeklist/pages/create_account.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:peeklist/pages/create_task.dart';
import 'package:peeklist/pages/inbox.dart';
import 'package:peeklist/models/tasklist.dart';
import 'package:peeklist/pages/tasklistpage.dart';
import 'package:peeklist/utils/auth.dart';
import 'package:peeklist/pages/show_starred.dart';
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

  void _getdata()async{
    tasklist.clear();
    var uid= await AuthService().userID();
    Stream<QuerySnapshot> qsp=Firestore.instance.collection('users').where('uid',isEqualTo: uid).snapshots();
    await qsp.forEach((ds) {
      List<DocumentSnapshot> ds1=ds.documents;
      ds1.forEach((element) {
        for(int i=0;i<element['tasks'].length;i++){
          var newlist=Tasklist(listname: element['tasks'][i]);
          tasklist.add(newlist);
        }
      });
    });
  }

  gettasklist(){
    List n=tasklist.toList();
    Set re={};
    for(int i=0; i<n.length; i++){
      var strin=n[i].listname;
      re.add(strin);
    }
    return re.toList();
  }
  @override
  void initState() {
    super.initState();

    Future f1=new Future(()=>null);
    f1.then((_){
      _getdata();
    });

    authService.profile.listen((state) => setState(() => _profile = state));
    //_getdata();
  }

  // void addTask() {
  //   List inbox = _profile['tasks']['inbox'];

  // }
  


  Future _addtomylist(String Listname)async {
    var uid=await AuthService().userID();
    var newlist=Tasklist(listname: Listname);
    List task1=[];
    tasklist.add(newlist);
    tasklist.forEach((element) {
     var n=element.listname;
     task1.add(n);
    });
    tasklist.clear();

    Stream<QuerySnapshot> sp=Firestore.instance.collection('users').where('uid',isEqualTo: uid).snapshots();
    sp.forEach((ds){
      List<DocumentSnapshot> ds1=ds.documents;
      ds1.forEach((element) {
        element.reference.updateData({"tasks":task1});
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
                Row(children: <Widget>[
                    Icon(
                    Icons.inbox,
                    color: Colors.green,
                    size: 30.0,
                    ),
                    RaisedButton(
                      child: Text('starred'),
                      onPressed: () async{
                        var uid=await AuthService().userID();
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => BuildStarred(
                                  uid: uid,
                                )));
                      }),
              ]
          ),
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
                            onPressed: () async{
                              //print(newtasklistinputController.text);
                              await _addtomylist(newlist.text);
                            },
                          )
                        ],
                      ))),
                Column(
//                  children: <Widget>[
//                    StreamBuilder(
//
//                      stream: Firestore.instance.collection('users').where('uid',isEqualTo: AuthService().userID()).snapshots(),
//                      builder: (context, snapshot) {
//                        if (!snapshot.hasData) return Container();
//                        return _showlist(context, snapshot.data.documents);
//                      },
//                    )
//                  ],
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
            MaterialPageRoute(builder: (context) => CreateTask(
              allist: gettasklist(),
            )),
          );
        },
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

//  Widget _showlist(BuildContext context,DocumentSnapshot ds){
//    return ListView.builder(
//
//    );
//  }
}





