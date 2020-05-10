import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:bmnav/bmnav.dart' as bmnav;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:jewtube/model/channel.dart';
import 'package:jewtube/util/Resources.dart';
import 'package:jewtube/view/add_video.dart';
import 'package:jewtube/view/channelVideoList.dart';
import 'package:jewtube/view/login/constants/constants.dart';
import 'package:jewtube/view/subVideoList.dart';
import 'package:jewtube/view/videoList.dart';
import 'package:path/path.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _navIndex = 0;
  Widget _bodyWidget = VideoListScreen();
  final _drawerKey = GlobalKey<ScaffoldState>();
  List<Channel> _channelList = List();
  bool _progress = true;
  File file;
  String chnlName = "";
  bool _progressAddChannel = false;
  @override
  void initState() {
    getAllChannels();
    super.initState();
  }

  void getAllChannels() async {
    Response response = await Dio().get("http://${Resources.BASE_URL}/channel");
    print(response.data);
    setState(() {
      _channelList.clear();
      response.data.forEach((channel) {
        _channelList.add(Channel(
            channelID: channel['_id'],
            channelName: channel['title'],
            imgUrl: channel['img']));
      });
      _progress = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _progress
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            resizeToAvoidBottomPadding: false,
            key: _drawerKey,
            drawer: Resources.isAdmin
                ? Drawer(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Center(
                            child: CircleAvatar(
                              backgroundImage: AssetImage("assets/account.png"),
                              radius: 70,
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Center(
                            child: Text(
                              "ADMIN NAME",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Divider(
                            thickness: 5,
                            color: Colors.grey,
                          ),
                          _channelList.length > 0
                              ? Container()
                              : Container(
                                  child: Center(
                                    child: Text("No Channel To View"),
                                  ),
                                ),
                          for (var channel in _channelList)
                            ListTile(
                              leading: CircleAvatar(
                                backgroundImage: channel.imgUrl == ""
                                    ? AssetImage("assets/no_image.png")
                                    : CachedNetworkImageProvider(
                                        channel.imgUrl),
                              ),
                              title: Text(channel.channelName),
                              onTap: () {
                                print(channel.channelName);
                                // Navigator.pop(context);
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (builder) => ChannelVideoList(
                                            channel.channelName)));
                                // setState(() {
                                //   _bodyWidget = ChannelVideoList(channel.channelName);
                                // });
                              },
                            ),
                          Divider(
                            thickness: 2,
                            color: Colors.grey,
                          ),
                          ListTile(
                            onTap: () {
                              Alert(
                                  context: context,
                                  title: "ADD A CHANNEL",
                                  content: _progressAddChannel
                                      ? Center(
                                          child: CircularProgressIndicator(),
                                        )
                                      : StatefulBuilder(
                                          // You need this, notice the parameters below:
                                          builder: (BuildContext context,
                                              StateSetter setState) {
                                          return Column(
                                            children: <Widget>[
                                              Center(
                                                child: GestureDetector(
                                                  child: CircleAvatar(
                                                    radius: 50,
                                                    backgroundImage: file ==
                                                            null
                                                        ? AssetImage(
                                                            "assets/addImg.png")
                                                        : MemoryImage(file
                                                            .readAsBytesSync()),
                                                  ),
                                                  onTap: () {
                                                    FilePicker.getFile(
                                                            type:
                                                                FileType.IMAGE)
                                                        .then((value_file) {
                                                      setState(() {
                                                        file = value_file;
                                                        print("PATH   : " +
                                                            file.path);
                                                      });
                                                    });

                                                    //
                                                  },
                                                ),
                                              ),
                                              TextField(
                                                onChanged: (value) {
                                                  chnlName = value;
                                                },
                                                decoration: InputDecoration(
                                                  icon: Icon(
                                                      Icons.account_circle),
                                                  labelText: 'Channel Name',
                                                ),
                                              ),
                                            ],
                                          );
                                        }),
                                  buttons: [
                                    DialogButton(
                                      onPressed: () async {
                                        if (file != null) {
                                          setState(() {
                                            _progressAddChannel = true;
                                          });
                                          Dio dio = new Dio();
                                          var filename = (basename(file.path));
                                          var response = await dio.post(
                                              "http://${Resources.BASE_URL}/channel/add",
                                              data: {
                                                "file": file.readAsBytesSync(),
                                                "name": filename,
                                                "title": chnlName,
                                              });
                                          print(response.data);
                                            getAllChannels();
                                          setState(() {
                                            _progressAddChannel = false;
                                          });
                                        } else {
                                          print("FILE NULL");
                                          Fluttertoast.showToast(
                                              msg: "No File Selected",
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.CENTER,
                                              backgroundColor: Colors.red,
                                              textColor: Colors.white,
                                              fontSize: 16.0);
                                        }
                                      },
                                      child: Text(
                                        "ADD",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 20),
                                      ),
                                    ),
                                    DialogButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: Text(
                                        "CANCEL",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 20),
                                      ),
                                    )
                                  ]).show();
                            },
                            leading: Icon(FontAwesomeIcons.plusCircle),
                            title: Text("ADD A NEW CHANNEL"),
                          )
                        ]),
                  )
                : null,
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
              leading: Resources.isAdmin
                  ? IconButton(
                      icon: Icon(FontAwesomeIcons.bars),
                      onPressed: () {
                        _drawerKey.currentState.openDrawer();
                      })
                  : null,
              actions: <Widget>[
                IconButton(
                    icon: Icon(FontAwesomeIcons.search), onPressed: () {}),
                // IconButton(icon: Icon(FontAwesomeIcons.userCircle), onPressed: () {}),
                IconButton(
                    icon: Icon(FontAwesomeIcons.signOutAlt),
                    onPressed: () async {
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      prefs?.clear();
                      Navigator.of(context).pushReplacementNamed(SPLASH_SCREEN);
                    })
              ],
            ),
            body: _bodyWidget,
            bottomNavigationBar: bmnav.BottomNav(
              iconStyle: bmnav.IconStyle(onSelectColor: Colors.red),
              index: _navIndex,
              onTap: (i) {
                print(i);
                setState(() {
                  _navIndex = i;

                  switch (i) {
                    case 0:
                      _bodyWidget = VideoListScreen();
                      return;
                    case 1:
                      _bodyWidget = SubedVideoList();
                      return;
                    default:
                      _bodyWidget = VideoListScreen();
                  }
                });
              },
              items: [
                bmnav.BottomNavItem(Icons.home),
                bmnav.BottomNavItem(Icons.subscriptions),
                bmnav.BottomNavItem(Icons.dashboard),
                bmnav.BottomNavItem(Icons.notifications)
              ],
            ),
            floatingActionButton: Resources.isAdmin
                ? FloatingActionButton(
                    onPressed: () {
                      Alert(
                        style: AlertStyle(isCloseButton: false),
                        context: context,
                        title: "SELECT CHANNEL",
                        content: Column(children: <Widget>[
                          for (var channel in _channelList)
                            ListTile(
                              leading: CircleAvatar(
                                backgroundImage: NetworkImage(channel.imgUrl),
                              ),
                              title: Text(channel.channelName),
                              onTap: () {
                                Navigator.pop(context);
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (builder) =>
                                            AddVideoScreen(channel.channelID)));
                              },
                            ),
                        ]),
                        buttons: List(),
                      ).show();
                    },
                    tooltip: 'ADD VIDEO',
                    child: Icon(Icons.add),
                  )
                : null,
          );
  }
}
