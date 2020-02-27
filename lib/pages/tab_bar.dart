import 'package:flutter/material.dart';
import 'package:peeklist/pages/social_home.dart';
import 'package:peeklist/pages/task_page.dart';

class TabBarExample extends StatefulWidget {
  final String title;

  TabBarExample({Key key, this.title}) : super(key: key);

  @override
  _TabBarExampleState createState() => _TabBarExampleState();
}

class _TabBarExampleState extends State<TabBarExample>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Peek List'),
        bottom: TabBar(
          tabs: [
            Tab(
              text: "Home",
            ),
            Tab(
              text: "Social",
            ),
            Tab(
              text: "Settings",
            ),
          ],
          controller: _tabController,
        ),
      ),
      body: TabBarView(
        children: <Widget>[
          TaskPage(),
          SocialHome(),
          // Container(
          //   color: Colors.orangeAccent,
          // ),
          // Container(
          //   color: Colors.redAccent,
          // ),
          Container(
            color: Colors.blueAccent,
          ),
        ],
        controller: _tabController,
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}