import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:bmnav/bmnav.dart' as bmnav;
import 'package:flutter/services.dart';
import 'package:jewtube/util/Resources.dart';
import 'package:jewtube/view/add_video.dart';
import 'package:jewtube/view/home.dart';
import 'package:jewtube/view/login/constants/constants.dart';
import 'package:jewtube/view/login/ui/signin.dart';
import 'package:jewtube/view/login/ui/signup.dart';
import 'package:jewtube/view/login/ui/splashscreen.dart';

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
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    return MaterialApp(
      title: 'JewTube',
      // home: SafeArea(
      //   child: AddVideoScreen("channel"),
      // ),
      debugShowCheckedModeBanner: false,
      routes: <String, WidgetBuilder>{
        SPLASH_SCREEN: (BuildContext context) => SplashScreen(),
        SIGN_IN: (BuildContext context) => SignInPage(),
        SIGN_UP: (BuildContext context) => SignUpScreen(),
        HOME: (BuildContext context) => HomeScreen(),
      },
      initialRoute: SPLASH_SCREEN,
    );
  }
}
