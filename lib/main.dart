import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:bmnav/bmnav.dart' as bmnav;
import 'package:jewtube/util/Resources.dart';
import 'package:jewtube/view/home.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final FirebaseApp app = await FirebaseApp.configure(
    name: 'db2',
    options: Platform.isIOS
        ? const FirebaseOptions(
            googleAppID: '1:673312298512:ios:d06198c4e53984f59edc95',
            gcmSenderID: 'AIzaSyCWB-QG2kNsvbbs6fJYxk2uNErFSr4DxGg',
            databaseURL: 'https://jewtube-76d06.firebaseio.com',
          )
        : const FirebaseOptions(
            googleAppID: '1:673312298512:android:869ff15c5ee0a0329edc95',
            apiKey: 'AIzaSyCvbnX3iiZxJt0miln0SfqJy45YuPS8Bsc',
            databaseURL: 'https://jewtube-76d06.firebaseio.com',
          ),
  );
  Resources.firebaseApp = app;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'JewTube',
      home: SafeArea(
        child: HomeScreen(),
        // child: VPL(),
      ),
      debugShowCheckedModeBanner: false,
      
    );
  }
}

