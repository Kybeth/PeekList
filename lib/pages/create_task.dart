import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:peeklist/widgets/header.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:peeklist/utils/auth.dart';
import 'package:peeklist/data/tasks.dart';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';

class CreateTask extends StatefulWidget {
  final allist;
  CreateTask({Key key, this.allist}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _CreateTaskState(allist: allist);
}

const String INIT_DATETIME = '2019-05-16 09:00';

class _CreateTaskState extends State<CreateTask> {
  final allist;
  _CreateTaskState({Key key, this.allist});
  var _taskname = TextEditingController();
  var _tasknote = TextEditingController();
  final _duedate = TextEditingController();
  // List allist=[];
  var choose_list;

  String _format = 'yyyy - MM - dd    EEE,H:m'; //DateTimePicker
  TextEditingController _formatCtrl = TextEditingController();
  DateTimePickerLocale _locale = DateTimePickerLocale.en_us;
  List<DateTimePickerLocale> _locales = DateTimePickerLocale.values;
  DateTime _dateTime;

//  Future getalllist()async{
//    var uid=await AuthService().userID();
//    Stream<QuerySnapshot> qsp=Firestore.instance.collection('users').where('uid',isEqualTo: uid).snapshots();
//    await qsp.forEach((ds) {
//      List<DocumentSnapshot> ds1=ds.documents;
//      ds1.forEach((element) {
//        List n=element['tasks'];
//       allist.addAll(n);
//      });
//    });
//  }

  List<DropdownMenuItem> getlist() {
    List<DropdownMenuItem> alllist = new List();
    for (int i = 0; i < allist.length; i++) {
      var listchoose = new DropdownMenuItem(
        value: allist[i].toString(),
        child: Text(allist[i].toString()),
      );
      alllist.add(listchoose);
    }
    return alllist;
  }

  @override
  void initState() {
    super.initState();
    _formatCtrl.text = _format;
    _dateTime = DateTime.parse(INIT_DATETIME);
  }

  /// Display time picker.
  void _showDateTimePicker() {
    DatePicker.showDatePicker(
      context,
      dateFormat: _format,
      locale: _locale,
      pickerMode: DateTimePickerMode.datetime, // show TimePicker
      onCancel: () {
        debugPrint('onCancel');
      },
      onChange: (dateTime, List<int> index) {
        setState(() {
          _dateTime = dateTime;
        });
      },
      onConfirm: (dateTime, List<int> index) {
        setState(() {
          _dateTime = dateTime;
        });
      },
    );
  }

  @override
//  void initState() {
//    super.initState();
//    Future f1 = new Future(() => null);
//    f1.then((_) async{
//      await getalllist();
//    });
//  }
  Widget build(BuildContext context) {
    List<Widget> radios = List<Widget>();
    _locales.forEach((locale) {
      radios.add(Container(
        margin: EdgeInsets.only(right: 8.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Radio(
                value: locale,
                groupValue: _locale,
                onChanged: (value) {
                  setState(() {
                    _locale = value;
                  });
                }),
            Text(locale
                .toString()
                .substring(locale.toString().indexOf('.') + 1)),
          ],
        ),
      ));
    });

    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Add a task"),
      ),
      body: new Column(
        children: <Widget>[
          TextField(
            autofocus: true,
            controller: _taskname,
            decoration: InputDecoration(
                hintText: "Task Name", prefixIcon: Icon(Icons.person)),
          ),
          TextField(
            controller: _tasknote,
            decoration:
                InputDecoration(hintText: "Note", prefixIcon: Icon(Icons.note)),
          ),
          TextField(
            controller: _duedate,
            onTap: _showDateTimePicker,
            decoration: InputDecoration(
              hintText: "DateTime",
              prefixIcon: Icon(Icons.timer),
            ),
            readOnly: true,
          ),
          Container(
            child: Text(
              '${_dateTime.year}-${_dateTime.month.toString().padLeft(2, '0')}-${_dateTime.day.toString().padLeft(2, '0')} ${_dateTime.hour.toString().padLeft(2, '0')}:${_dateTime.minute.toString().padLeft(2, '0')}',
            ),
          ),
          Column(
            children: <Widget>[
              DropdownButton(
                items: getlist(),
                hint: Text('choose your lists'),
                value: choose_list,
                icon: Icon(Icons.arrow_drop_down),
                onChanged: (T) {
                  setState(() {
                    choose_list = T;
                  });
                },
              )
            ],
          ),
          RaisedButton(
            onPressed: () async {
              Tasks ntask = new Tasks(
                  name: _taskname.text,
                  uid: await AuthService().userID(),
                  comment: _tasknote.text,
                  list: choose_list,
                  iscompleted: false,
                  isstarred: false);

              ntask.addtask();
              Navigator.of(context).pop();
            },
            child: Text('add'),
          )
        ],
      ),
    );
  }

  Widget _showlist(BuildContext context) {
    return ListView.builder(
      itemCount: allist.length,
      itemBuilder: (context, idx) {
        return FlatButton(
            onPressed: () {
              choose_list = allist[idx];
            },
            child: Text(allist[idx]));
      },
    );
  }
}
