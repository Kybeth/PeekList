import 'package:flutter/material.dart';
//import 'package:peeklist/pages/create_account.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:peeklist/pages/create_task.dart';
import 'package:peeklist/pages/inbox.dart';
import 'package:peeklist/models/tasklist.dart';
import 'package:peeklist/pages/tasklistpage.dart';
import 'package:peeklist/utils/auth.dart';
import 'package:peeklist/pages/show_starred.dart';
import 'package:peeklist/pages/today_page.dart';
import 'package:peeklist/pages/planned_page.dart';
import 'package:peeklist/pages/completed_page.dart';
import '../utils/auth.dart';

class TaskPage extends StatefulWidget {
  // final FirebaseUser user;

  // TaskPage({Key key, this.user}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  final List<Tasklist> tasklist = [];
  Map<String, dynamic> _profile;
  String docid;
  Set alllists = {};
  final newlist = TextEditingController();
  final renamelist = TextEditingController();

  void _getdata() async {
    var uid = await AuthService().userID();
    Stream<QuerySnapshot> qsp = Firestore.instance
        .collection('users')
        .where('uid', isEqualTo: uid)
        .snapshots();
    await qsp.forEach((ds) {
      List<DocumentSnapshot> ds1 = ds.documents;
      tasklist.clear();
      ds1.forEach((element) {
        docid = element.documentID;
        for (int i = 0; i < element['tasks'].length; i++) {
          var newlist = Tasklist(listname: element['tasks'][i]);
          tasklist.add(newlist);
          alllists.add(element['tasks'][i]);
        }
      });
      setState(() {
        tasklist;
      });
    });
  }

  void _deletelist(listname, uid) async {
    // query to delete list and all tasks in the list
  }

  void _renamelist(listname, uid, renamed) async {
    //query to rename list and rename all the tasks in the list
  }

  gettasklist() {
    List n = tasklist.toList();
    Set re = {};
    for (int i = 0; i < n.length; i++) {
      var strin = n[i].listname;
      re.add(strin);
    }
    return re.toList();
  }

  @override
  void initState() {
    super.initState();

    Future f1 = new Future(() => null);
    f1.then((_) {
      _getdata();
    });

    authService.profile.listen((state) => setState(() => _profile = state));
    //_getdata();
  }

  // void addTask() {
  //   List inbox = _profile['tasks']['inbox'];

  // }

  Future _addtomylist(String Listname) async {
    var uid = await AuthService().userID();
    List newlist = alllists.toList();
    newlist.add(Listname);
    await Firestore.instance
        .collection('users')
        .where('uid', isEqualTo: uid)
        .reference()
        .document(docid)
        .updateData({'tasks': newlist});
  }

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
            Row(children: <Widget>[
              Icon(
                Icons.inbox,
                color: Colors.green,
                size: 30.0,
              ),
              RaisedButton(
                  child: Text('Inbox'),
                  onPressed: () async {
                    var uid = await AuthService().userID();
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
                Icons.grade,
                color: Colors.yellow[900],
                size: 30.0,
              ),
              RaisedButton(
                  child: Text('starred'),
                  onPressed: () async {
                    var uid = await AuthService().userID();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => BuildStarred(
                                  uid: uid,
                                )));
                  }),
            ]),
            Row(children: <Widget>[
              Icon(
                Icons.today,
                color: Colors.blue,
                size: 30.0,
              ),
              RaisedButton(
                  child: Text('Today'),
                  onPressed: () async {
                    var uid = await AuthService().userID();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => BuildToday(
                                  uid: uid,
                                )));
                  }),
            ]),
            Row(children: <Widget>[
              Icon(
                Icons.calendar_today,
                color: Colors.red,
                size: 30.0,
              ),
              RaisedButton(
                  child: Text('Incomplete'),
                  onPressed: () async {
                    var uid = await AuthService().userID();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => BuildPlanned(
                                  uid: uid,
                                )));
                  }),
            ]),
            Row(children: <Widget>[
              Icon(
                Icons.event_available,
                color: Colors.black,
                size: 30.0,
              ),
              RaisedButton(
                  child: Text('Completed'),
                  onPressed: () async {
                    var uid = await AuthService().userID();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => BuildCompleted(
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
                          onPressed: () async {
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
                return Row(children: <Widget>[
                  FlatButton(
                      splashColor: Colors.green,
                      child: Text(lst.listname),
                      onPressed: () async {
                        var uid = await AuthService().userID();
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => tasklistpage(
                                      listname: lst.listname,
                                      uid: uid,
                                    )));
                      }),
                  PopupMenuButton(
                      itemBuilder: (_) => <PopupMenuItem<String>>[
                            PopupMenuItem<String>(
                                child: const Text('Delete'), value: '1'),
                            PopupMenuItem<String>(
                                child: const Text('Rename'), value: '2'),
                          ],
                      onSelected: (value) async {
                        var uid = await AuthService().userID();
                        //print("value:$value");
                        if (value == '1') {
                    var l = lst.listname;
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              // return object of type Dialog
                              return AlertDialog(
                                title: Text("Delete $l?"),
                                content: Text(
                                    "Deleting this list will remove all tasks in the list."),
                                actions: <Widget>[
                                  // usually buttons at the bottom of the dialog
                                  FlatButton(
                                    child: Text("Cancel"),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  FlatButton(
                                    child: Text("Delete"),
                                    onPressed: () {
                                      _deletelist(lst.listname, uid);
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        }
                        if (value == '2') {
                          var l = lst.listname;
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                // return object of type Dialog
                                return AlertDialog(
                                  title: Text("Rename $l ?"),
                                  content: TextField(
                                    decoration: InputDecoration(
                                        labelText: 'Rename this list to?'),
                                    controller: renamelist,
                                  ),
                                  actions: <Widget>[
                                    // usually buttons at the bottom of the dialog
                                    FlatButton(
                                      child: Text("Cancel"),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    FlatButton(
                                      child: Text("rename"),
                                      onPressed: () {
                                        _renamelist(
                                            lst.listname, uid, renamelist.text);
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                );
                              });
                        }
                      })
                ]);
              }).toList(),
            ),
          ])),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          //         Navigator.of(context).pushNamed('/createtask', arguments: "inbox");
          var uid = await AuthService().userID();
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    CreateTask(choose_list: 'inbox', uid: uid)),
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
