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

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

void main() {

  Widget testWidget({Widget child}){
    return MaterialApp(
        home: child,
    );
  }
  testWidgets('verify the title of create task page', (WidgetTester tester) async {
    // Find a Widget that displays the title "Add Task"
    await tester.pumpWidget(testWidget(child: new CreateTask()));
    final titleFinder = find.text('Add Task');
    expect(titleFinder, findsOneWidget);
  });
}