import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:peeklist/todo_list_screen.dart';

void main() {
  SystemChrome.setEnabledSystemUIOverlays([]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Peek List',
      home: TodoListScreen(),
    );
  }
}