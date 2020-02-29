import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:jewtube/model/video.dart';
import 'package:jewtube/util/Resources.dart';
import 'package:jewtube/widgets/subscribe.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class VideoItemWidgetHorizontal extends StatefulWidget {
  VideoItemWidgetHorizontal(this.videoModel, this.onClick);
  final VideoModel videoModel;
  Function onClick;
  @override
  _VideoItemWidgetHorizontalState createState() =>
      _VideoItemWidgetHorizontalState();
}

class _VideoItemWidgetHorizontalState extends State<VideoItemWidgetHorizontal> {
  var _thumbImage;
  bool _progress = true;
  final FirebaseDatabase db = FirebaseDatabase(app: Resources.firebaseApp);
  getImageThumb() async {
    _thumbImage = await VideoThumbnail.thumbnailData(
      video: widget.videoModel.videoURL,
      imageFormat: ImageFormat.JPEG,
      maxHeight: 500,
      quality: 25,
    );
    setState(() {
      _progress = false;
    });
  }

  List subList = List();

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
    getImageThumb();
    getSubscription();
    setUpdate();
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
                    child: Image.memory(
                      _thumbImage,
                      height: height * 0.1,
                      width: width * 0.3,
                      fit: BoxFit.cover,
                    ),
                    onTap: () {
                      widget.onClick();
                    },
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
            )
          ],
        ));
  }
}
