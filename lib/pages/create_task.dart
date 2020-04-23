import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:peeklist/widgets/header.dart';
import 'package:peeklist/utils/auth.dart';
import 'package:peeklist/data/tasks.dart';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';
import 'package:peeklist/models/user.dart';
import 'package:peeklist/utils/user.dart';
import 'package:peeklist/widgets/progress.dart';

class CreateTask extends StatefulWidget {
  final choose_list;
  final uid;
  final isPrivate;
  CreateTask({Key key, this.choose_list,this.uid, this.isPrivate = true}): super(key:key);
  @override

  State<StatefulWidget> createState() => _CreateTaskState(choose_list: choose_list, uid: uid, isPrivate: isPrivate);
}


class _CreateTaskState extends State<CreateTask> {
  var _taskname = TextEditingController();
  var _tasknote = TextEditingController();
  var _duedate = TextEditingController();
  var choose_list;
  var listName;
  var isPrivate;
  var uid;

  _CreateTaskState({Key key, this.choose_list, this.uid, this.isPrivate});

  String _format = 'yyyy - MM - dd    EEE,H:m'; //DateTimePicker
  TextEditingController _formatCtrl = TextEditingController();
  DateTimePickerLocale _locale = DateTimePickerLocale.en_us;
  List<DateTimePickerLocale> _locales = DateTimePickerLocale.values;
  DateTime _dateTime;

  buildList(uid) {
    return FutureBuilder(
      future: UserService().getUserById(uid),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return circularProgress();
        }
        User currentProfile = User.fromDocument(snapshot.data);
        List<DropdownMenuItem> getlist() {
          List<DropdownMenuItem> alllist = new List();
          for (int i = 0; i < currentProfile.tasks.length; i++) {
            var listchoose = new DropdownMenuItem(
              value: currentProfile.tasks[i].toString(),
              child: Text(currentProfile.tasks[i].toString()),
            );
            alllist.add(listchoose);
          }
          alllist.add(new DropdownMenuItem(value: "inbox", child: Text("inbox")));
          return alllist;
        }
        return DropdownButton(
            items: getlist(),
            hint: Text(choose_list),
            value: listName,
            icon: Icon(Icons.arrow_drop_down),
            onChanged: (T) {
              setState(() {
                listName = T;
              });
            });
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _formatCtrl.text = _format;
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
          _duedate.text = '${_dateTime.year}-${_dateTime.month.toString().padLeft(2, '0')}-${_dateTime.day.toString().padLeft(2, '0')} ${_dateTime.hour.toString().padLeft(2, '0')}:${_dateTime.minute.toString().padLeft(2, '0')}';
        });

      },
    );
  }

  changeicon_com(bool isprivated) {
    return isprivated ? Icon(Icons.check_box_outline_blank) : Icon(
        Icons.check_box);
  }

  @override
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
        title: new Text("Add Task"),
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
          Row(
            children: <Widget>[
              Text('choose list or not: '),
              buildList(uid),
            ],
          ),

          Row(

            children: <Widget>[

              Text('Do you want to share this tasks?'),
              IconButton(
                icon: changeicon_com(isPrivate),
                onPressed: (){
                  setState(() {
                    isPrivate= isPrivate? false:true;
                  });
              },
              )
            ],
          ),
          RaisedButton(
            onPressed: () async {
              if(listName!=null){
                choose_list=listName;
              }
              Tasks ntask = new Tasks(
                  name: _taskname.text,
                  uid: await AuthService().userID(),
                  comment: _tasknote.text,
                  list: choose_list,
                  iscompleted: false,
                  isstarred: false,
                  time:_dateTime,
                  isprivate:isPrivate
              );

              ntask.addtask();
              Navigator.of(context).pop();
            },
            child: Text('add'),
          )
        ],
      ),
    );
  }
}
