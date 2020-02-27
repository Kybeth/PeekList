// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:peeklist/models/user.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:peeklist/pages/timeline.dart';
// import 'package:peeklist/widgets/new_todo_dialog.dart';

// import 'activity_feed.dart';
// import 'create_account.dart';
// import 'profile.dart';
// import 'search.dart';

// final GoogleSignIn googleSignIn = GoogleSignIn();
// final userRef = Firestore.instance.collection('users');
// final DateTime timestamp = DateTime.now();
// User currentUser;

// class Home extends StatefulWidget {
//   @override
//   _HomeState createState() => _HomeState();
// }

// class _HomeState extends State<Home> {
//   bool isAuth = false;
//   PageController pageController;
//   int pageIndex = 0;

//   @override
//   void initState() { 
//     super.initState();

//     pageController = PageController();
//     //User sign in nd sign out
//     googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount account) {
//       handleSignIn(account);
//     }, onError: (err) {
//       print('Error Signing In... $err');
//     });
//     //Reauthenticate user
//     googleSignIn.signInSilently(suppressErrors: false).then((account) {
//       handleSignIn(account);
//     }).catchError((err) {
//       print('Error signing in $err');
//     });
//   }

//   void dispose() {
//     pageController.dispose();
//     super.dispose();
//   }

//   handleSignIn(GoogleSignInAccount account) {
//       if (account != null) {
//         createUserInFirestore();
//         setState(() {
//           isAuth = true;
//         });
//       } else {
//         setState(() {
//           isAuth = false;
//         });
//       }
//   }

//   createUserInFirestore() async {
//     // check if user exists in users collection in database by id
//     final GoogleSignInAccount user = googleSignIn.currentUser;
//     DocumentSnapshot doc = await userRef.document(user.id).get();

//     // if user does not exist, then take them to create account page
//     if (!doc.exists) {
//       final username = await Navigator.push(context, MaterialPageRoute(
//         builder: (context) => CreateAccount()));

//       userRef.document(user.id).setData({
//         "id": user.id,
//         "username": username,
//         "photoUrl": user.photoUrl,
//         "email": user.email,
//         "displayName": user.displayName,
//         "bio": "",
//         "timestamp": timestamp,
//       });

//       doc = await userRef.document(user.id).get();
//     }

//     currentUser = User.fromDocument(doc);
//     // get username from create account, use it to make new user document in users collection

//   }

//   login() {
//     googleSignIn.signIn();
//   }

//   logout() {
//     googleSignIn.signOut();
//   }

//   onPageChanged(int pageIndex) {
//     setState(() {
//       this.pageIndex = pageIndex;
//     });

//   }

//   onTap(int pageIndex) {
//     pageController.animateToPage(
//       pageIndex,
//       duration: Duration(milliseconds: 250),
//       curve: Curves.easeInOut,  
//     );
//   }

//   Scaffold buildAuthScreen() {
//     return Scaffold(
//       body: PageView(
//         children: <Widget>[
//           Timeline(),
//           ActivityFeed(),
//           NewTodoDialog(),
//           Search(),
//           Profile(),
//         ],
//         controller: pageController,
//         onPageChanged: onPageChanged,
//         physics: NeverScrollableScrollPhysics(),
//       ),
//       bottomNavigationBar: CupertinoTabBar(
//         currentIndex: pageIndex,
//         onTap: onTap,
//         activeColor: Theme.of(context).primaryColor,
//         items: [
//           BottomNavigationBarItem(icon: Icon(Icons.whatshot),),
//           BottomNavigationBarItem(icon: Icon(Icons.notifications_active),),
//           BottomNavigationBarItem(icon: Icon(Icons.add_circle, size: 35.0,),),
//           BottomNavigationBarItem(icon: Icon(Icons.search),),
//           BottomNavigationBarItem(icon: Icon(Icons.account_circle),),
//         ],
//       ),
//     );
//   }

//   Widget buildUnAuthScreen() {
//     return Scaffold(
//       body: Container(
//         alignment: Alignment.center,
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topRight,
//             end: Alignment.bottomLeft,
//             colors: [
//               Theme.of(context).accentColor.withOpacity(0.8),
//               Theme.of(context).primaryColor,
//             ]
//           )
//         ),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: <Widget>[
//             Text(
//               'Peek List',
//               style: TextStyle(
//                 fontFamily: "Signatra",
//                 fontSize: 90.0,
//                 color: Colors.white
//               ),
//             ),
//             GestureDetector(
//               onTap: login,
//               child: Container(
//                 width: 260.0,
//                 height: 60.0,
//                 decoration: BoxDecoration(
//                   image: DecorationImage(
//                     image: AssetImage('assets/images/google_signin_button.png'),
//                     fit: BoxFit.cover,
//                   )
//                 ),
//               ),
//             )
//       ],)
//     ),);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return isAuth ? buildAuthScreen() : buildUnAuthScreen();
//   }
// }




// import 'package:flutter/material.dart';
// import 'package:peeklist/todo.dart';

// import 'package:peeklist/new_todo_dialog.dart';
// import 'package:peeklist/todo_list.dart';

// class TodoListScreen extends StatefulWidget {
//   @override
//   _TodoListScreenState createState() => _TodoListScreenState();
// }

// class _TodoListScreenState extends State<TodoListScreen> {
//   List<Todo> todos = [];

//   _toggleTodo(Todo todo, bool isChecked) {
//     setState(() {
//       todo.isDone = isChecked;
//     });
//   }

//   _addTodo() async {
//     final todo = await showDialog<Todo>(
//       context: context,
//       builder: (BuildContext context) {
//         return NewTodoDialog();
//       },
//     );

//     if (todo != null) {
//       setState(() {
//         todos.add(todo);
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Todo List')),
//       body: TodoList(
//         todos: todos,
//         onTodoToggle: _toggleTodo,
//       ),
//       floatingActionButton: FloatingActionButton(
//         child: Icon(Icons.add),
//         onPressed: _addTodo,
//       ),
//     );
//   }
// }