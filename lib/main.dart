import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/desgin.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent, //top bar color
        statusBarIconBrightness: Brightness.dark, //top bar icons
        systemNavigationBarColor: Colors.white, //bottom bar color
        systemNavigationBarIconBrightness: Brightness.dark, //bottom bar icons
      )
  );
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown])
      .then((_) => runApp(new MyApp()));
}
enum PlayerState { stopped, playing, paused }
class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Spotify',
      theme: ThemeData(
          canvasColor: Colors.white,
          backgroundColor: Colors.white,
          primaryColor: Colors.white,
          accentColor: Colors.white,
          fontFamily: 'Product Sans'
      ),
      home: Spotify(),
    );
  }
}