import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jewtube/view/videoList.dart';
import 'package:jewtube/util/Resources.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class AddVideoScreen extends StatefulWidget {
  AddVideoScreen(this.channelName);
  final String channelName;
  @override
  _AddVideoScreenState createState() => _AddVideoScreenState();
}

class _AddVideoScreenState extends State<AddVideoScreen> {
  StorageReference storageReference;
  double _progressValue = 0;
  bool _isUploading = false;
  bool _titleEditEnable = true;
  TextEditingController _txtTitle = TextEditingController();
  var _prevImg;
  // Alert _alert;
  @override
  void initState() {
    // _alert =
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var sysWidth = MediaQuery.of(context).size.width;
    var sysHeight = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("ADD VIDEO"),
        ),
        resizeToAvoidBottomPadding: false,
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: <Widget>[
              _isUploading
                  ? Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            SizedBox(
                              width: 20,
                            ),
                            _prevImg != null
                                ? Image.memory(
                                    _prevImg,
                                    width: sysWidth * 0.2,
                                  )
                                : Container,
                            SizedBox(
                              width: 20,
                            ),
                            _AnimatedLiquidLinearProgressIndicator(
                                _progressValue),
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              _txtTitle.text,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 50,
                        ),
                      ],
                    )
                  : Container(),
              TextField(
                enabled: _titleEditEnable,
                controller: _txtTitle,
                decoration: InputDecoration(labelText: "TITLE"),
              ),
              SizedBox(
                height: 50,
              ),
              Container(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () async {
                      // setState(() {
                      //   _titleEditEnable = false;
                      // });

                      File file =
                          await FilePicker.getFile(type: FileType.VIDEO);
                      print(file.path);
                      _prevImg = await VideoThumbnail.thumbnailData(
                        video: file.path,
                        imageFormat: ImageFormat.JPEG,
                        maxWidth: 500,
                        quality: 25,
                      );
                      setState(() {});
                      storageReference = FirebaseStorage().ref().child(
                          "/videos/${file.path.split('/')[file.path.split('/').length - 1]}");
                      final StorageUploadTask uploadTask =
                          storageReference.putData(file.readAsBytesSync());

                      final StreamSubscription<StorageTaskEvent>
                          streamSubscription =
                          uploadTask.events.listen((event) {
                        setState(() {
                          _isUploading = true;

                          _progressValue =
                              event.snapshot.bytesTransferred.toDouble() /
                                  event.snapshot.totalByteCount.toDouble();
                          print(_progressValue);
                        });
                      });
                      await uploadTask.onComplete;
                      uploadTask.lastSnapshot.ref
                          .getDownloadURL()
                          .then((downloadedURL) {
                        FirebaseDatabase db =
                            FirebaseDatabase(app: Resources.firebaseApp);
                        db
                            .reference()
                            .child("videos/")
                            .child(widget.channelName)
                            .push()
                            .set({
                          "video_name": _txtTitle.text,
                          "video_url": downloadedURL
                        });
                      });

                      // print(downloadedURL);

                      streamSubscription.cancel();
                      _isUploading = false;
                      Fluttertoast.showToast(
                          msg: "Successfully Video Added !",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIos: 1,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          fontSize: 16.0);
                      // Navigator.pop(context);
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (builder) => VideoListScreen()));
                    },
                    child: Image.asset(
                      "assets/addVideo.png",
                      width: sysWidth * 0.8,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              // Container(
              //   child: FlatButton(
              //       onPressed: () async {
              //         File file = await FilePicker.getFile(type: FileType.VIDEO);
              //         print(file.path);
              //         _prevImg = await VideoThumbnail.thumbnailData(
              //           video: file.path,
              //           imageFormat: ImageFormat.JPEG,
              //           maxWidth: 500,
              //           quality: 25,
              //         );
              //         setState(() {});
              //         storageReference = FirebaseStorage().ref().child(
              //             "/videos/${file.path.split('/')[file.path.split('/').length - 1]}");
              //         final StorageUploadTask uploadTask =
              //             storageReference.putData(file.readAsBytesSync());

              //         final StreamSubscription<StorageTaskEvent>
              //             streamSubscription = uploadTask.events.listen((event) {
              //           setState(() {
              //             _isUploading = true;

              //             _progressValue =
              //                 event.snapshot.bytesTransferred.toDouble() /
              //                     event.snapshot.totalByteCount.toDouble();
              //             print(_progressValue);
              //           });
              //         });
              //         await uploadTask.onComplete;
              //         uploadTask.lastSnapshot.ref
              //             .getDownloadURL()
              //             .then((downloadedURL) {
              //           FirebaseDatabase db =
              //               FirebaseDatabase(app: Resources.firebaseApp);
              //           db
              //               .reference()
              //               .child("videos/")
              //               .child(widget.channelName)
              //               .push()
              //               .set({
              //             "video_name": _txtTitle.text,
              //             "video_url": downloadedURL
              //           });
              //         });

              //         // print(downloadedURL);

              //         streamSubscription.cancel();
              //         _isUploading = false;
              //         Fluttertoast.showToast(
              //             msg: "Successfully Video Added !",
              //             toastLength: Toast.LENGTH_SHORT,
              //             gravity: ToastGravity.BOTTOM,
              //             timeInSecForIos: 1,
              //             backgroundColor: Colors.red,
              //             textColor: Colors.white,
              //             fontSize: 16.0);
              //         Navigator.pushReplacement(context, MaterialPageRoute(
              //                                   builder: (builder) =>
              //                                   VideoListScreen()));
              //       },
              //       child: Text("PICK VIDEO")),

              // ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AnimatedLiquidLinearProgressIndicator extends StatefulWidget {
  _AnimatedLiquidLinearProgressIndicator(this.value);
  double value;
  @override
  State<StatefulWidget> createState() =>
      _AnimatedLiquidLinearProgressIndicatorState();
}

class _AnimatedLiquidLinearProgressIndicatorState
    extends State<_AnimatedLiquidLinearProgressIndicator>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.65,
        height: 75.0,
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: LiquidLinearProgressIndicator(
          value: widget.value,
          backgroundColor: Colors.white,
          valueColor: AlwaysStoppedAnimation(Colors.blue),
          borderRadius: 12.0,
          center: Text(
            "${(widget.value * 100).toStringAsFixed(0)}%",
            style: TextStyle(
              color: Colors.lightBlueAccent,
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
