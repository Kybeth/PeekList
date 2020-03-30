import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:peeklist/models/user.dart';
import 'package:peeklist/utils/search.dart';

class Search extends StatefulWidget {
  Search({Key key}) : super(key: key);

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  var queryResult = [];
  var tempSearch = [];

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

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          ListView.builder(
            itemCount: tempSearch.length,
            itemBuilder: (context, index) {
              return ListTile(
                trailing: RaisedButton(
                  child: Text('View'),
                  color: Theme.of(context).primaryColorLight,
                  elevation: 5.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                    side: BorderSide(color: Colors.black),
                  ),
                  onPressed: () {
                    // User user = User(
                    //   uid: tempSearch[index]['uid'],
                    //   displayName: tempSearch[index]['displayName'],
                    //   email: tempSearch[index]['email'],
                    //   photoURL: tempSearch[index]['photoURL'],
                    //   bio: tempSearch[index]['bio'],
                    // );
                    // print(user);
                    Navigator.pushNamed(context, '/myprofile', arguments: tempSearch[index]['uid']);
                  }
                ),
                leading: CircleAvatar(
                  backgroundColor: Colors.grey,
                  backgroundImage: CachedNetworkImageProvider(tempSearch[index]['photoURL']),
                ),
                title: Text(
                  tempSearch[index]['displayName'],
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  tempSearch[index]['email'],
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              );
            },
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
          ),
        ]
    ),
    );
  }
}