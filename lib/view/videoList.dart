import 'package:firebase_database/firebase_database.dart';
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
  @override
  void initState() {
    final FirebaseDatabase db = FirebaseDatabase(app: Resources.firebaseApp);

    db.reference().child("videos").once().then((DataSnapshot snapshot) {
      // print(snapshot.value);
      getAllVideos(snapshot);
    });
    db.reference().child("videos").onValue.listen((Event event) {
      getAllVideos(event.snapshot);
      // print(event.snapshot.value);
    });
    super.initState();
  }

  getAllVideos(DataSnapshot snapshot) {
    setState(() {
      _videoList.clear();
      if (snapshot.value != null) {
        snapshot.value.forEach((channelID, value) {
          print(channelID);
          value.forEach((videoId, value) {
            _videoList.add(VideoModel(
                videoId: videoId,
                channelName: channelID.toString(),
                videoTitle: value["video_name"].toString(),
                videoURL: value["video_url"].toString()));
          });
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
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
