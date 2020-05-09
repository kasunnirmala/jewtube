import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:jewtube/model/video.dart';
import 'package:jewtube/util/Resources.dart';
import 'package:jewtube/view/videoPlay.dart';
import 'package:jewtube/widgets/videoItemWidget.dart';

class VideoListScreen extends StatefulWidget {
  @override
  _VideoListScreenState createState() => _VideoListScreenState();
}

class _VideoListScreenState extends State<VideoListScreen> {
  List<VideoModel> _videoList = List();
  bool _progress = true;
  @override
  void initState() {
    getAllVideos();

    super.initState();
  }

  getAllVideos() async {
    Response sub = await Dio()
        .get("http://${Resources.BASE_URL}/subscribe/${Resources.userID}");
    print(sub.data);
    var subArray = List();
    if (sub.data != null) {
      subArray = sub.data['channel'];
    }
    Response response =
        await Dio().get("http://${Resources.BASE_URL}/video/getvideos");
    print(response.data);
    setState(() {
      _videoList.clear();
      response.data.forEach((video) {
        _videoList.add(
          VideoModel(
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
                  video['thumbNail'].length > 0 ? video['thumbNail'][0] : ""),
        );
      });

      // print(jsonEncode(_videoList));
      _progress = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _progress
        ? Center(child: CircularProgressIndicator())
        : ListView.builder(
            itemCount: _videoList.length,
            itemBuilder: (context, index) {
              return Card(
                elevation: 5,
                child: VideoItemWidget(_videoList[index], () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (builder) =>
                              VideoPlayerScreen(_videoList[index])));
                }),
              );
            });
  }
}
