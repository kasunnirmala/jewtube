import 'package:flutter/material.dart';
import 'package:jewtube/widgets/subscribe.dart';

class VideoItemWidget extends StatefulWidget {
  @override
  _VideoItemWidgetState createState() => _VideoItemWidgetState();
}

class _VideoItemWidgetState extends State<VideoItemWidget> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
        // height: height * 0.3,
        child: Column(
      children: <Widget>[
        Image.asset(
          "assets/sample.jpeg",
          height: height * 0.25,
          width: width,
          fit: BoxFit.cover,
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
                    "TITLE",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text("Channel Name")
                ],
              ),
              SubscribeWidget(false),
            ],
          ),
        )
      ],
    ));
  }
}
