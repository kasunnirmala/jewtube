import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:jewtube/model/video.dart';
import 'package:jewtube/util/Resources.dart';
import 'package:jewtube/widgets/subscribe.dart';

class VideoItemWidgetHorizontal extends StatefulWidget {
  VideoItemWidgetHorizontal(this.videoModel, this.onClick);
  final VideoModel videoModel;
  Function onClick;
  @override
  _VideoItemWidgetHorizontalState createState() =>
      _VideoItemWidgetHorizontalState();
}

class _VideoItemWidgetHorizontalState extends State<VideoItemWidgetHorizontal> {
  bool _progress = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
        width: width,
        child: Row(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            _progress
                ? Center(child: CircularProgressIndicator())
                : GestureDetector(
                  
                    child: CachedNetworkImage(
                      fit: BoxFit.cover,
                      height: height * 0.25,
                      width: width,
                      imageUrl: widget.videoModel.thumbNail,
                      progressIndicatorBuilder:
                          (context, url, downloadProgress) =>
                              CircularProgressIndicator(
                                  value: downloadProgress.progress),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                  ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                // width: width*0.5,
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
                      onClick: (status) async {
                        Response response = await Dio().post(
                            "http://${Resources.BASE_URL}/subscribe/add",
                            data: {
                              "userID": Resources.userID,
                              "ChannelID": widget.videoModel.channelID
                            });

                        setState(() {
                          widget.videoModel.sub = status;
                        });
                      },
                    )
                  ],
                ),
              ),
            )
          ],
        ));
  }
}
