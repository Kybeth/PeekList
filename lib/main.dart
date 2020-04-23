import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:peeklist/pages/my_profile.dart';
import 'package:peeklist/pages/notifications_page.dart';
import 'package:peeklist/pages/root.dart';
import 'package:peeklist/pages/create_task.dart';

import 'pages/search.dart';

const MaterialColor white = const MaterialColor(
  0xFFFFFFFF,
  const <int, Color>{
    50: const Color(0xFFFFFFFF),
    100: const Color(0xFFFFFFFF),
    200: const Color(0xFFFFFFFF),
    300: const Color(0xFFFFFFFF),
    400: const Color(0xFFFFFFFF),
    500: const Color(0xFFFFFFFF),
    600: const Color(0xFFFFFFFF),
    700: const Color(0xFFFFFFFF),
    800: const Color(0xFFFFFFFF),
    900: const Color(0xFFFFFFFF),
  },
);

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Peek List',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.ralewayTextTheme(
          Theme.of(context).textTheme,
        ),
        brightness: Brightness.light,
        primarySwatch: Colors.grey,
        accentColor: Colors.blue,
        bottomSheetTheme: BottomSheetThemeData(
          backgroundColor: Colors.black.withOpacity(0),
        ),
      ),
      darkTheme: ThemeData(
        textTheme: GoogleFonts.ralewayTextTheme(
          Theme.of(context).textTheme,
        ),
        brightness: Brightness.dark,
        primarySwatch: Colors.grey,
        accentColor: Colors.black,
      ),
      home: new Root(),
      routes: <String, WidgetBuilder>{
        '/search': (context) => Search(),
        '/myprofile': (context) => MyProfile(),
        '/createtask':(context) => CreateTask(),
        '/notifications': (context) => NotificationsPage(),
      },
    );
  }
}