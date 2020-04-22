//import 'package:flutter/material.dart';
//import 'package:firebase_messaging/firebase_messaging.dart';
//import 'package:peeklist/models/message.dart';
//
//class TestPage extends StatelessWidget{
//  @override
//  Widget build(BuildContext context) => Scaffold(
//    appBar: AppBar(title: Text("notification list")),
//    body: MessagingWidget(),
//  );
//}
//
//class MessagingWidget extends StatefulWidget {
//  @override
//  _MessagingWidgetState createState() => _MessagingWidgetState();
//}
//
//class _MessagingWidgetState extends State<MessagingWidget> {
//  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
//  final List<Message> messages = [];
//  @override
//  void initState(){
//    super.initState();
//
//    _firebaseMessaging.getToken().then((token){
//      print(token);
//    });
//
//    _firebaseMessaging.configure(
//      onMessage: (Map<String, dynamic> message) async {
//        print("onMessage: $message");
//        final notification = message['notification'];
//        setState(() {
//          messages.add(Message(
//            title: notification['title'], body: notification['body']
//          ));
//        });
//      },
//      onLaunch: (Map<String, dynamic> message) async {
//        print("onLaunch: $message");
//      },
//      onResume: (Map<String, dynamic> message) async {
//        print("onResume: $message");
//      },
//    );
//    _firebaseMessaging.requestNotificationPermissions(
//        const IosNotificationSettings(sound: true, badge: true, alert: true));
//  }
//  @override
//  Widget build(BuildContext context) => ListView(
//    children: messages.map(buildMessage).toList(),
//  );
//  Widget buildMessage(Message message) => ListTile(
//    title: Text(message.title),
//    subtitle: Text(message.body)
//  );
//}