import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:jewtube/model/video.dart';
import 'package:jewtube/util/Resources.dart';
import 'package:jewtube/widgets/videoListView.dart';

class ChannelVideoList extends StatefulWidget {
  ChannelVideoList(this.channelName);
  final String channelName;
  @override
  _ChannelVideoListState createState() => _ChannelVideoListState();
}

class _ChannelVideoListState extends State<ChannelVideoList> {
  List<VideoModel> videos = List();
  @override
  void initState() {
    final FirebaseDatabase db = FirebaseDatabase(app: Resources.firebaseApp);

    db
        .reference()
        .child("videos")
        .child(widget.channelName)
        .onValue
        .listen((Event evt) {
      if (evt.snapshot.value != null) {
        evt.snapshot.value.forEach((videoId, value) {
          videos.add(VideoModel(
              videoId: videoId,
              channelName: widget.channelName.toString(),
              videoTitle: value["video_name"].toString(),
              videoURL: value["video_url"].toString()));
        });
      }
      setState(() {});
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: VideoListViewWidget(videos),
    );
  }
}
