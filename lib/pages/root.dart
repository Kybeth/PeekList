import 'package:flutter/material.dart';
import 'package:peeklist/pages/social_home.dart';
import 'package:peeklist/pages/task_page.dart';

class Root extends StatefulWidget {
  final String title;

  Root({Key key, this.title}) : super(key: key);

  @override
  _RootState createState() => _RootState();
}

class _RootState extends State<Root>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
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
          ],
          controller: _tabController,
        ),
      ),
      body: TabBarView(
        children: <Widget>[
          TaskPage(),
          SocialHome(),
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