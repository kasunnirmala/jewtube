import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:jewtube/model/video.dart';
import 'package:jewtube/util/Resources.dart';
import 'package:jewtube/widgets/subscribe.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class VideoItemWidget extends StatefulWidget {
  VideoItemWidget(this.videoModel, this.onClick);
  final VideoModel videoModel;
  Function onClick;
  @override
  _VideoItemWidgetState createState() => _VideoItemWidgetState();
}

class _VideoItemWidgetState extends State<VideoItemWidget> {
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
    if (this.mounted) {
      setState(() {
        _progress = false;
      });
    }
  }

  List subList = List();

  getSubscription() {
    db
        .reference()
        .child("user_subs")
        .child(Resources.userID)
        .onValue
        .listen((event) {
      if (event.snapshot.value != null) {
        if (event.snapshot.value.contains(widget.videoModel.channelName)) {
          subList.clear();
          if (this.mounted) {
            setState(() {
              subList.addAll(event.snapshot.value);
              print("AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA" +
                  subList.toString());
              widget.videoModel.sub = true;
            });
          }
        } else {
          if (this.mounted) {
            setState(() {
              subList.clear();
              subList.addAll(event.snapshot.value);
              widget.videoModel.sub = false;
            });
          }
        }
      } else {
        if (this.mounted) {
          setState(() {
            subList.clear();
            widget.videoModel.sub = false;
          });
        }
      }
    });
  }

  void setUpdate() {
    db.reference().child("user_subs").onChildChanged.listen((Event event) {
      if (event.snapshot.value != null) {
        if (event.snapshot.value.contains(widget.videoModel.channelName)) {
          subList.clear();
          if (this.mounted) {
            setState(() {
              subList.addAll(event.snapshot.value);
              print("AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA" +
                  subList.toString());
              widget.videoModel.sub = true;
            });
          }
        } else {
          if (this.mounted) {
            setState(() {
              subList.clear();
              subList.addAll(event.snapshot.value);
              widget.videoModel.sub = false;
            });
          }
        }
      } else {
        if (this.mounted) {
          setState(() {
            subList.clear();
            widget.videoModel.sub = false;
          });
        }
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
        child: Column(
      children: <Widget>[
        _progress
            ? Center(child: CircularProgressIndicator())
            : GestureDetector(
                child: Image.memory(
                  _thumbImage,
                  height: height * 0.25,
                  width: width,
                  fit: BoxFit.cover,
                ),
                onTap: () {
                  widget.onClick();
                },
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
        )
      ],
    ));
  }
}
