import 'package:animated_card/animated_card.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jewtube/model/video.dart';
import 'package:jewtube/util/Resources.dart';
import 'package:jewtube/widgets/subscribe.dart';
import 'package:jewtube/widgets/videoItemWidgetHorizontal.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerScreen extends StatefulWidget {
  VideoPlayerScreen(this.videoModel, {this.prevModel});
  final VideoModel videoModel;
  final VideoModel prevModel;
  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  final FirebaseDatabase db = FirebaseDatabase(app: Resources.firebaseApp);
  VideoPlayerController _videoPlayerController;
  ChewieController _chewieController;
  List subList = List();
  List<VideoModel> _videoList = List();

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

  getSubscription() {
    db
        .reference()
        .child("user_subs")
        .child(Resources.userID)
        .once()
        .then((DataSnapshot snapshot) {
      if (snapshot.value != null) {
        if (snapshot.value.contains(widget.videoModel.channelName)) {
          subList.clear();
          setState(() {
            subList.addAll(snapshot.value);
            print("AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA" +
                subList.toString());
            widget.videoModel.sub = true;
          });
        } else {
          setState(() {
            subList.clear();
            subList.addAll(snapshot.value);
            widget.videoModel.sub = false;
          });
        }
      } else {
        setState(() {
          subList.clear();
          widget.videoModel.sub = false;
        });
      }
    });
  }

  void setUpdate() {
    db.reference().child("user_subs").onChildChanged.listen((Event event) {
      if (event.snapshot.value != null) {
        if (event.snapshot.value.contains(widget.videoModel.channelName)) {
          subList.clear();
          setState(() {
            subList.addAll(event.snapshot.value);
            print("AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA" +
                subList.toString());
            widget.videoModel.sub = true;
          });
        } else {
          setState(() {
            subList.clear();
            subList.addAll(event.snapshot.value);
            widget.videoModel.sub = false;
          });
        }
      } else {
        setState(() {
          subList.clear();
          widget.videoModel.sub = false;
        });
      }
    });
  }

  @override
  void initState() {
    db.reference().child("videos").once().then((DataSnapshot snapshot) {
      getAllVideos(snapshot);
    });

    super.initState();
    getSubscription();
    setUpdate();
    _videoPlayerController =
        VideoPlayerController.network(widget.videoModel.videoURL);

    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      aspectRatio: 3 / 2,
      autoPlay: true,
      looping: false,
      // placeholder: Container(
      //   color: Colors.grey,
      // ),
      // autoInitialize: true,
    );
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        body: Container(
          child: Column(
            children: <Widget>[
              Chewie(
                controller: _chewieController,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          widget.videoModel.videoTitle,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(widget.videoModel.channelName)
                      ],
                    ),
                    SubscribeWidget(
                      widget.videoModel.sub,
                      onClick: (status) {
                        print(status);
                        setState(() {
                          print("PPPPPPPPPPPPP" + subList.toString());
                          print(widget.videoModel.channelName);
                          if (status) {
                            subList.add(widget.videoModel.channelName);
                          } else {
                            subList.remove(widget.videoModel.channelName);
                          }

                          db
                              .reference()
                              .child("user_subs")
                              .child(Resources.userID)
                              .set(subList);
                        });
                      },
                    )
                  ],
                ),
              ),
              Container(
                height: height * 0.5,
                width: width,
                child: SingleChildScrollView(
                  child: Container(
                    height: height * 0.5,
                    width: width,
                    child: ListView.builder(
                        itemCount: _videoList.length,
                        itemBuilder: (context, index) {
                          if (widget.videoModel.videoId ==
                              _videoList[index].videoId) {
                            return Container(
                              height: 0,
                              width: 0,
                            );
                          } else {
                            return AnimatedCard(
                                direction: AnimatedCardDirection.left,
                                initDelay: Duration(milliseconds: 0),
                                duration: Duration(seconds: 1),
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  child: Card(
                                    elevation: 5,
                                    child: VideoItemWidgetHorizontal(
                                        _videoList[index], () {
                                      print("object");
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (builder) =>
                                                  VideoPlayerScreen(
                                                      _videoList[index])));
                                    }),
                                  ),
                                ));
                          }
                        }),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
