import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:peeklist/widgets/header.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:peeklist/utils/auth.dart';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';

class CreateTask extends StatefulWidget {
  CreateTask({Key key}) : super(key: key);

  @override
  _CreateTaskState createState() => _CreateTaskState();
}
const String INIT_DATETIME = '2019-05-16 09:00';

class _CreateTaskState extends State<CreateTask> {
  final _taskname=TextEditingController();
  final _tasknote=TextEditingController();
  final _duedate=TextEditingController();

  String _format = 'yyyy - MM - dd    EEE,H:m';//DateTimePicker
  TextEditingController _formatCtrl = TextEditingController();
  DateTimePickerLocale _locale = DateTimePickerLocale.en_us;
  List<DateTimePickerLocale> _locales = DateTimePickerLocale.values;
  DateTime _dateTime;

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


    return Scaffold(
      appBar: new AppBar(
        title: new Text("Add a task"),
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
                      TextField(
            autofocus: true,
            controller: _taskname,
            decoration: InputDecoration(
                hintText: "Task Name",
                prefixIcon: Icon(Icons.person)
            ),
          ),
          TextField(
            controller: _tasknote,
            decoration: InputDecoration(
                hintText: "Note",
                prefixIcon: Icon(Icons.note)
            ),
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
            // selected date time
          Container(
            child: Text(
              '${_dateTime.year}-${_dateTime.month.toString().padLeft(2, '0')}-${_dateTime.day.toString().padLeft(2, '0')} ${_dateTime.hour.toString().padLeft(2, '0')}:${_dateTime.minute.toString().padLeft(2, '0')}',
            ),
          ),
          RaisedButton(
            onPressed: (){
              _addtask(_taskname.text,_tasknote.text,"inbox");
              Navigator.of(context).pop();
            },
            child: Text('add'),
          )
          ],
        ),
      ),
    );
  }
//  @override
//  Widget build(BuildContext context) {
//
//  }
}

Future _addtask(String taskname,String tasknote,String list)async {
  var mylist="inbox";
  var uid = await AuthService().userID();
  if(list==null || list.length==0){
    mylist=list;
  }
  await Firestore.instance
  .collection('tasks')
    .add(<String, dynamic>{
    'uid': uid,
    'name': taskname,
    'comment': tasknote,
    'list' : mylist,
    'time': Timestamp.now(),
    'iscompleted':false,
    });
}