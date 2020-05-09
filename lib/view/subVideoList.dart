import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:jewtube/model/video.dart';
import 'package:jewtube/util/Resources.dart';
import 'package:jewtube/view/login/constants/constants.dart';
import 'package:jewtube/widgets/videoListView.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class SubedVideoList extends StatefulWidget {
  @override
  _SubedVideoListState createState() => _SubedVideoListState();
}

class _SubedVideoListState extends State<SubedVideoList> {
  List<VideoModel> _videoList = List();
  bool _progress = true;
  getAllVideos() async {
    Response sub = await Dio()
        .get("http://${Resources.BASE_URL}/subscribe/${Resources.userID}");
    print(sub.data);
    var subArray = List();
    if (sub.data != null) {
        subArray = sub.data['channel'];
    }
    if (subArray.length > 0) {
      Response response = await Dio().get(
          "http://${Resources.BASE_URL}/video/getvideos//ByChannelArray",
          queryParameters: {"channelIDs": subArray});
      print(response.data);
      setState(() {
        _videoList.clear();
        response.data.forEach((video) {
          _videoList.add(VideoModel(
               channelID:video['channelID'],
              channelName: video['channelName'],
              channelImage: video['channelImage'],
              videoTitle: video['videoTitle'],
              videoURL: video['videoURL'],
              videoId: video['videoId'],
              sub: video['channelID'] == ""
                  ? false
                  : subArray.contains(video['channelID']),
              thumbNail:
                  video['thumbNail'].length > 0 ? video['thumbNail'][0] : ""));
        });
        _progress = false;
      });
    }
  }

  @override
  void initState() {
    if (Resources.userID != "") {
    } else {
      Alert(
        closeFunction: () {},
        context: context,
        style: AlertStyle(
          animationType: AnimationType.fromTop,
          isCloseButton: false,
          isOverlayTapDismiss: false,
          descStyle: TextStyle(fontWeight: FontWeight.bold),
          animationDuration: Duration(milliseconds: 400),
          alertBorder: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0.0),
            side: BorderSide(
              color: Colors.grey,
            ),
          ),
          titleStyle: TextStyle(
            color: Colors.red,
          ),
        ),
        type: AlertType.info,
        title: "LOGIN",
        desc: "You need to login to enable these features.",
        buttons: [
          DialogButton(
            child: Text(
              "LOGIN",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, SIGN_IN);
            },
            color: Color.fromRGBO(0, 179, 134, 1.0),
            radius: BorderRadius.circular(0.0),
          ),
        ],
      ).show();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _progress
        ? Center(
            child: CircularProgressIndicator(),
          )
        : VideoListViewWidget(_videoList);
  }
}
