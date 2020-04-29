import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:peeklist/utils/search.dart';
import 'package:peeklist/utils/user.dart';
import 'package:peeklist/widgets/progress.dart';
import 'package:peeklist/widgets/search_tile.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/friends.dart';
import 'package:timeago/timeago.dart' as timeago;

class Search extends StatefulWidget {
  Search({Key key}) : super(key: key);

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search>{
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
        else return Text("Congratulations you reached no man area!");
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    RouteSettings settings = ModalRoute.of(context).settings;
    uid = settings.arguments;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: AppBar(
          centerTitle: false,
          backgroundColor: Theme.of(context).primaryColorLight,
          title: Text(
            'My Friends',
            style: GoogleFonts.raleway(
              textStyle: TextStyle(
              color: Colors.black,
              fontSize: 19.0,
              fontWeight: FontWeight.w500
              ),
            ),
          ),
          bottom: TabBar(
            indicatorColor: Theme.of(context).accentColor,
            labelStyle: GoogleFonts.raleway(
              textStyle: TextStyle(fontSize: 15.0),
            ),
            labelColor: Colors.cyan[700],
            unselectedLabelColor: Colors.grey[500],
            tabs: [
              Tab(
                icon: Icon(Icons.search),
                //text: "Interactions",
              ),
              Tab(
                icon: Icon(Icons.people),
                //text: "Friend Requests",
              ),
            ],
          ),
        ),
      body: TabBarView(
        children: <Widget>[
          buildSearchTab(),
          buildFriends(),
        ],
      )
    )
    );
  }

  buildSearchTab() {
    return ListView(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 20),
            child: Text("Search for new friends",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 10),
            child: TextField(
              onChanged: (val) {
                initiateSearch(val);
              },
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(left: 10.0),
                hintText: 'Search by email',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
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
    );
  }

  buildFriends() {
    return StreamBuilder(
      stream: userService.getFriends(uid),
      builder: (context, asyncSnap) {
        if (asyncSnap.hasError) {
          return Text("Error ${asyncSnap.error}");
        } else if (asyncSnap.data == null) {
          return circularProgress();
        } else if (asyncSnap.data.length == 0) {
          return buildNoFriends();
        } else {
          return new ListView(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 20),
                child: Text("My Current friends",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                ),
              ),
              ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemCount: asyncSnap.data.length,
              itemBuilder: (context, int index) {
              Friends friends = asyncSnap.data[index];
              return buildFriendTile(friends);
              }
              )
            ],
          );



        }
      },
    );
  }

  buildNoFriends(){
    return Center(
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 25.0,),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: CircleAvatar(
                  backgroundImage:  AssetImage('assets/images/PeekListLogo.png'),
                  //backgroundColor: Colors.grey,
                  radius: 13,
                ),
                title: Text(
                  'PeekList',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.cyan[900],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 20.0, right: 20, top: 5, bottom: 20),
                child:
                Text(
                  "There is no one in your Friends List! Swipe left to add some new friends",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
              ),
            ]
        ),
      ),
    );
  }

  buildFriendTile(Friends friends) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.grey,
        backgroundImage: CachedNetworkImageProvider(friends.photoURL),
      ),
      title: Text(friends.displayName,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.cyan[900],
        ),
      ),
      subtitle: Text(friends.email),
      trailing: Text("${timeago.format(friends.friendSince.toDate())}"),
      onTap: () => Navigator.pushNamed(context, '/myprofile', arguments: friends.user),
    );
  }
}