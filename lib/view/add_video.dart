import 'dart:async';
import 'dart:io';
import 'package:jewtube/util/Resources.dart';
import 'package:path/path.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';
import 'package:uuid/uuid.dart';

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
                      var uuid = Uuid().v4();
                      File file =
                          await FilePicker.getFile(type: FileType.VIDEO);
                      Dio dio = new Dio();
                      var filename =
                          "jewtube-_-_-$uuid-_-_-" + (basename(file.path));
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
