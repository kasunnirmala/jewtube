import 'package:animated_card/animated_card.dart';
import 'package:flutter/material.dart';
import 'package:jewtube/widgets/videoItemWidget.dart';

class VideoListScreen extends StatefulWidget {
  @override
  _VideoListScreenState createState() => _VideoListScreenState();
}

class _VideoListScreenState extends State<VideoListScreen> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) {
          return AnimatedCard(
              direction: AnimatedCardDirection.left,
              initDelay: Duration(milliseconds: 0),
              duration: Duration(seconds: 1),
              child: Container(
                // width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Card(
                  elevation: 5,
                  child: VideoItemWidget(),
                ),
              ));
        });
  }
}
