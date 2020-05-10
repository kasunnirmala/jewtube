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
