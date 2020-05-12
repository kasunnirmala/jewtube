import 'package:animated_card/animated_card.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jewtube/model/video.dart';
import 'package:jewtube/util/Resources.dart';
import 'package:jewtube/util/utils.dart';
import 'package:jewtube/widgets/subscribe.dart';
import 'package:jewtube/widgets/videoItemWidgetHorizontal.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerScreen extends StatefulWidget {
  // VideoPlayerScreen(this.videoModel, {this.prevModel});
  // final VideoModel videoModel;
  // final VideoModel prevModel;
  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  VideoPlayerController _videoPlayerController;
  ChewieController _chewieController;
  List subList = List();
  List<VideoModel> _videoList = List();
  bool init = false;

  Future<Null> getAllVideos() async {
    setState(() {
      // _progress = true;
    });
    await getVideos(
            "http://${Resources.BASE_URL}/subscribe/${Resources.userID}")
        .then((value) => {
              setState(() {
                _videoList.clear();
                _videoList =  value['videos'];

                // print(jsonEncode(_videoList));
              })
            });
  }

  // getAllVideos() async {
  //   Response sub = await Dio()
  //       .get("http://${Resources.BASE_URL}/subscribe/${Resources.userID}");
  //   print(sub.data);
  //   var subArray = List();
  //   if (sub.data != null) {
  //     subArray = sub.data['channel'];
  //   }
  //   Response response =
  //       await Dio().get("http://${Resources.BASE_URL}/video/getvideos");
  //   print(response.data);
  //   if (sub.data != null && response.data != null) {
  //     setState(() {
  //       _videoList.clear();
  //       response.data.forEach((video) {
  //         _videoList.add(VideoModel(
  //             channelID: video['channelID'],
  //             channelName: video['channelName'],
  //             channelImage: video['channelImage'],
  //             videoTitle: video['videoTitle'],
  //             videoURL: video['videoURL'],
  //             videoId: video['videoId'],
  //             sub: video['channelID'] == ""
  //                 ? false
  //                 : subArray.contains(video['channelID']),
  //             thumbNail:
  //                 video['thumbNail'].length > 0 ? video['thumbNail'][0] : ""));
  //       });
  //     });
  //   }
  // }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    VideoModel videoModel = ModalRoute.of(context).settings.arguments;
    if (!init) {
      getAllVideos();
      _videoPlayerController =
          VideoPlayerController.network(videoModel.videoURL);

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
      init = true;
    }
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
                          videoModel.videoTitle,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(videoModel.channelName)
                      ],
                    ),
                    SubscribeWidget(
                      videoModel.sub,
                      onClick: (status) async {
                        Response response = await Dio().post(
                            "http://${Resources.BASE_URL}/subscribe/add",
                            data: {
                              "userID": Resources.userID,
                              "ChannelID": videoModel.channelID
                            });

                        setState(() {
                          videoModel.sub = status;
                        });

                        getAllVideos();
                      },
                    )
                  ],
                ),
              ),
              Container(
                height: height - ((height * 0.15) + width * 2 / 3),
                width: width,
                child: SingleChildScrollView(
                  child: Container(
                    height: height - ((height * 0.15) + width * 2 / 3),
                    width: width,
                    child: ListView.builder(
                        itemCount: _videoList.length,
                        itemBuilder: (context, index) {
                          if (videoModel.videoId == _videoList[index].videoId) {
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
                                      Resources.navigationKey.currentState
                                          .pushNamed('/player',
                                              arguments: _videoList[index]);
                                      // Navigator.pushReplacement(
                                      //     context,
                                      //     MaterialPageRoute(
                                      //         builder: (builder) =>
                                      //             VideoPlayerScreen(
                                      //                 _videoList[index])));
                                    }, () {
                                      getAllVideos();
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
