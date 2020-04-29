import 'package:flutter/material.dart';
import 'package:abcd/SplashScreen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of ABCD application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ABCDWelcomeSplashScreen(), //call the splash screen
      debugShowCheckedModeBanner: false,
    );
  }
}
