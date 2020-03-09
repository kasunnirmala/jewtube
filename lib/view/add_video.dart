import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class AddVideoScreen extends StatefulWidget {
  AddVideoScreen(this.channelName);
  final String channelName;
  @override
  _AddVideoScreenState createState() => _AddVideoScreenState();
}

class _AddVideoScreenState extends State<AddVideoScreen> {
  @override
  void initState() {
    print(widget.channelName);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FlatButton(
          onPressed: () async {
            File file = await FilePicker.getFile(type: FileType.VIDEO);
            print(file.path);
          },
          child: Text("PICK VIDEO")),
    );
  }
}
