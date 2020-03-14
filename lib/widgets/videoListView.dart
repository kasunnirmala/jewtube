import 'package:animated_card/animated_card.dart';
import 'package:animated_card/animated_card_direction.dart';
import 'package:flutter/material.dart';
import 'package:jewtube/model/video.dart';
import 'package:jewtube/view/videoPlay.dart';
import 'package:jewtube/widgets/videoItemWidgetHorizontal.dart';

class VideoListViewWidget extends StatefulWidget {
  VideoListViewWidget(this.videos);
  final List<VideoModel> videos;
  @override
  _VideoListViewWidgetState createState() => _VideoListViewWidgetState();
}

class _VideoListViewWidgetState extends State<VideoListViewWidget> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return SingleChildScrollView(
      child: Container(
        height: height * 0.9,
        width: width,
        child: ListView.builder(
            itemCount: widget.videos.length,
            itemBuilder: (context, index) {
              return AnimatedCard(
                  direction: AnimatedCardDirection.left,
                  initDelay: Duration(milliseconds: 0),
                  duration: Duration(seconds: 1),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Card(
                      elevation: 5,
                      child:
                          VideoItemWidgetHorizontal(widget.videos[index], () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (builder) =>
                                    VideoPlayerScreen(widget.videos[index])));
                      }),
                    ),
                  ));
            }),
      ),
    );
  }
}
