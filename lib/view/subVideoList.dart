import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:jewtube/model/video.dart';
import 'package:jewtube/util/Resources.dart';
import 'package:jewtube/widgets/videoListView.dart';

class SubedVideoList extends StatefulWidget {
  @override
  _SubedVideoListState createState() => _SubedVideoListState();
}

class _SubedVideoListState extends State<SubedVideoList> {
  List<VideoModel> videos = List();
  @override
  void initState() {
    final FirebaseDatabase db = FirebaseDatabase(app: Resources.firebaseApp);
    db
        .reference()
        .child("user_subs")
        .child(Resources.userID)
        .onValue
        .listen((Event event) {
      print(event.snapshot.value);
      if (event.snapshot.value != null) {
        videos.clear();
        List channels = List();
        channels.addAll(event.snapshot.value);
        for (var channelID in channels) {
          db
              .reference()
              .child("videos")
              .child(channelID)
              .onValue
              .listen((Event evt) {
            if (evt.snapshot.value != null) {
              evt.snapshot.value.forEach((videoId, value) {
                videos.add(VideoModel(
                    videoId: videoId,
                    channelName: channelID.toString(),
                    videoTitle: value["video_name"].toString(),
                    videoURL: value["video_url"].toString()));
              });
            }
          });
        }
        setState(() {});
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return VideoListViewWidget(videos);
    
  }
}
