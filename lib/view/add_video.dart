import 'dart:async';
import 'dart:io';
// import 'package:fluttertoast/fluttertoast.dart';
import 'package:jewtube/util/Resources.dart';
import 'package:path/path.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';
import 'package:uuid/uuid.dart';

import 'login/constants/constants.dart';

class AddVideoScreen extends StatefulWidget {
  AddVideoScreen(this.channelID);
  final String channelID;
  @override
  _AddVideoScreenState createState() => _AddVideoScreenState();
}

class _AddVideoScreenState extends State<AddVideoScreen> {
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
              TextField(
                enabled: _titleEditEnable,
                controller: _txtTitle,
                decoration: InputDecoration(labelText: "TITLE"),
              ),
              SizedBox(
                height: 50,
              ),
              _isUploading
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : Container(
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () async {
                            var uuid = Uuid().v4();
                            File file =
                                await FilePicker.getFile(type: FileType.VIDEO);
                            if (file != null) {
                              Dio dio = new Dio();
                              var filename = "jewtube-_-_-$uuid-_-_-" +
                                  (basename(file.path));
                              setState(() {
                                _titleEditEnable = false;
                                _isUploading = true;
                              });
                              var response = await dio.post(
                                  "http://${Resources.BASE_URL}/video/addVideo",
                                  data: {
                                    "file": file.readAsBytesSync(),
                                    "name": filename,
                                    "title": _txtTitle.text,
                                    "videoID": uuid,
                                    "channel": widget.channelID
                                  });
                              print(response.data);
                              setState(() {
                                _isUploading = false;
                              });
                              if (response != null &&
                                  response.data != null &&
                                  response.data['status'] == 200) {
                                // Fluttertoast.showToast(
                                //     msg: "Upload Completed",
                                //     toastLength: Toast.LENGTH_SHORT,
                                //     gravity: ToastGravity.BOTTOM,
                                //     backgroundColor: Colors.grey,
                                //     textColor: Colors.white,
                                //     fontSize: 16.0);

                                Navigator.of(context)
                                    .pushReplacementNamed(HOME);
                              } else {
                                // Fluttertoast.showToast(
                                //     msg: "Upload Error",
                                //     toastLength: Toast.LENGTH_SHORT,
                                //     gravity: ToastGravity.BOTTOM,
                                //     backgroundColor: Colors.red,
                                //     textColor: Colors.white,
                                //     fontSize: 16.0);
                              }
                            } else {
                              // Fluttertoast.showToast(
                              //     msg: "No Video Selected",
                              //     toastLength: Toast.LENGTH_SHORT,
                              //     gravity: ToastGravity.BOTTOM,
                              //     backgroundColor: Colors.red,
                              //     textColor: Colors.white,
                              //     fontSize: 16.0);
                            }
                          },
                          child: Image.asset(
                            "assets/addVideo.png",
                            width: sysWidth * 0.8,
                            fit: BoxFit.cover,
                          ),
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
