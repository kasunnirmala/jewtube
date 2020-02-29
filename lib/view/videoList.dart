import 'package:animated_card/animated_card.dart';
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
      getAllVideos(snapshot);
    });
    // db.reference().child("videos").onChildChanged.listen((Event event) {
    //   getAllVideos(event.snapshot);
    // });
    super.initState();
  }

  getAllVideos(DataSnapshot snapshot) {
    setState(() {
      _videoList.clear();

      snapshot.value.forEach((channelID, value) {
        value.forEach((videoId, value) {
          _videoList.add(VideoModel(
              videoId: videoId,
              channelName: channelID,
              videoTitle: value['video_name'],
              videoURL: value['video_url']));
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: _videoList.length,
        itemBuilder: (context, index) {
          return AnimatedCard(
              direction: AnimatedCardDirection.left,
              initDelay: Duration(milliseconds: 0),
              duration: Duration(seconds: 1),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Card(
                  elevation: 5,
                  child: VideoItemWidget(_videoList[index], () {
                    print("object");
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (builder) =>
                                VideoPlayerScreen(_videoList[index])));
                  }),
                ),
              ));
        });
  }
}
