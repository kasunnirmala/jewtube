import 'package:flutter/cupertino.dart';

class VideoModel {
  VideoModel(
      {@required this.channelName,
      @required this.videoTitle,
      @required this.videoURL,
      @required this.videoId,
      this.sub = false});

  final String channelName;
  final String videoTitle;
  final String videoURL;
   bool sub;
  final String videoId;
}
