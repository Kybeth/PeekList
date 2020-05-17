// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:peeklist/pages/create_task.dart';
import 'package:peeklist/pages/task_page.dart';

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

void main() {
  Widget testWidget({Widget child}) {
    return MaterialApp(
      home: child,
    );
  }
  
  testWidgets('create task page', (WidgetTester tester) async {
    await tester.pumpWidget(testWidget(child: new CreateTask()));
    final titleFinder = find.text('Add Task');
    final inputFinder = find.text('Task Name');
    final shareFinder = find.text('Share with friends?');
    final personIconFinder = find.byIcon(Icons.person);
    final noteIconFinder = find.byIcon(Icons.note);
    final timerIconFinder = find.byIcon(Icons.timer);
    expect(titleFinder, findsOneWidget);
    expect(inputFinder, findsOneWidget);
    expect(shareFinder, findsOneWidget);
    expect(personIconFinder, findsOneWidget);
    expect(noteIconFinder, findsOneWidget);
    expect(timerIconFinder, findsOneWidget);
  });
}
