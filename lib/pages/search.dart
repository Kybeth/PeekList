import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:peeklist/utils/search.dart';
import 'package:peeklist/utils/user.dart';
import 'package:peeklist/widgets/progress.dart';
import 'package:peeklist/widgets/search_tile.dart';

class Search extends StatefulWidget {
  Search({Key key}) : super(key: key);

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  String uid;
  var queryResult = [];
  var tempSearch = [];

  addFriend(currUser, recUser) async {
    await UserService().sendFriendRequest(currUser, recUser);
    print("Success");
    
  }

  initiateSearch(value) {
    if (value.length == 0) {
      setState(() {
        queryResult = [];
        tempSearch = [];
      });
    }

    var lowerCaseValue = value.substring(0, 1).toLowerCase() + value.substring(1);

    if (queryResult.length == 0 && value.length == 1) {
      SearchService().searchByEmail(value).then((QuerySnapshot docs) {
        for (int i = 0; i < docs.documents.length; i++) {
          queryResult.add(docs.documents[i].data);
        }
      });
      print(queryResult);
    } else {
      tempSearch = [];
      queryResult.forEach((element) {
        if (element['email'].startsWith(lowerCaseValue)) {
          setState(() {
            tempSearch.add(element);
          });
        }
      });
    }

  }

  buildSearchResults(String uid, Map friends) {
    return FutureBuilder(
      future: UserService().checkFriend(uid, friends['uid']),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text("Error ${snapshot.error}");
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return circularProgress();
        } else if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.data == true) {
            return Text("This is a friend");
          } else {
            return SearchTile(uid: uid, friends: friends);
          }
        }
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    RouteSettings settings = ModalRoute.of(context).settings;
    uid = settings.arguments;
    return Scaffold(
      backgroundColor: Color(0xFFE5E5E5),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(10.0),
            child: TextField(
              onChanged: (val) {
                initiateSearch(val);
              },
              decoration: InputDecoration(
                prefixIcon: IconButton(
                  color: Colors.black,
                  icon: Icon(Icons.arrow_back),
                  iconSize: 20.0,
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                contentPadding: EdgeInsets.only(left: 25.0),
                hintText: 'Search by email',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4.0),
                ),
              ),
            ),
          ),
          SizedBox(height: 10.0,),
          // buildSearchResults()
          ListView.builder(
            itemCount: tempSearch.length,
            itemBuilder: (context, index) {
              return buildSearchResults(uid, tempSearch[index]);
            },
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
          ),
        ]
    ),
    );
  }
}