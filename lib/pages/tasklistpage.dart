import 'package:flutter/material.dart';
import 'package:peeklist/data/tasks.dart';
import 'package:peeklist/pages/create_task.dart';
import 'package:peeklist/utils/auth.dart';
import 'package:google_fonts/google_fonts.dart';
class tasklistpage extends StatelessWidget {
  final String listname;
  final String uid;
  tasklistpage({Key key, this.listname, this.uid}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        title: Text(
          this.listname,
          style: GoogleFonts.raleway(
            textStyle: TextStyle(
            color: Colors.black,
            fontSize: 19.0,
                fontWeight: FontWeight.w500
            ),
          )
      ),
      ),
      body: Showlist(
        uid:"$uid",
        list: "$listname",
      ).build(context),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.cyan[200],
        onPressed: () async{
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CreateTask(
                choose_list: listname, uid:uid
            )),
          );
        },
        child: Icon(Icons.add,color: Colors.black,),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
