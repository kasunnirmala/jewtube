import 'package:flutter/material.dart';
import 'package:bmnav/bmnav.dart' as bmnav;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:jewtube/view/videoList.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _navIndex = 0;
  final _drawerKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _drawerKey,
      drawer: Drawer(),
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.grey),
        backgroundColor: Colors.white,
        title: Row(
          children: <Widget>[
            Image.asset(
              "assets/logoT.png",
              width: 35,
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              "JewTube",
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
        leading: IconButton(
            icon: Icon(FontAwesomeIcons.bars),
            onPressed: () {
              _drawerKey.currentState.openDrawer();
              // Scaffold.of(context).openDrawer();
            }),
        actions: <Widget>[
          IconButton(icon: Icon(FontAwesomeIcons.search), onPressed: () {}),
          IconButton(icon: Icon(FontAwesomeIcons.userCircle), onPressed: () {}),
          IconButton(icon: Icon(FontAwesomeIcons.signOutAlt), onPressed: () {})
        ],
      ),
      body: VideoListScreen(),
      bottomNavigationBar: bmnav.BottomNav(
        iconStyle: bmnav.IconStyle(onSelectColor: Colors.red),
        index: _navIndex,
        onTap: (i) {
          print(i);
          setState(() {
            _navIndex = i;
          });
        },
        items: [
          bmnav.BottomNavItem(Icons.home),
          bmnav.BottomNavItem(Icons.subscriptions),
          bmnav.BottomNavItem(Icons.dashboard),
          bmnav.BottomNavItem(Icons.notifications)
        ],
      ),
    );
  }
}
