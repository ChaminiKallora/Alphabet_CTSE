import 'package:abcd/imageUpload/imageListView.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class ABCDWelcomeSplashScreen extends StatefulWidget {
  @override
  _ABCDWelcomeSplashScreenState createState() =>
      _ABCDWelcomeSplashScreenState();
}

//splash screen
class _ABCDWelcomeSplashScreenState extends State<ABCDWelcomeSplashScreen>{
  //route
  var route = new MaterialPageRoute(builder: (BuildContext context) => new ImageListView(), );

  void initState(){
    super.initState();
    Timer(Duration(seconds: 2), () =>  Navigator.of(context).push(route));//direct to the ImageListView Page after 5 seconds
  }

  //build the splash screen
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/splash_ss.jpg"), //background image
            fit: BoxFit.fill,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Center(
              child: AnimatedCrossFade(
                alignment: Alignment.center,
                firstChild: Container(
                 // color: Colors.transparent,
                  child: CircularProgressIndicator(),
                  height: 200,
                  width: 200,
                ),
                secondChild: Container(
                  child: Column(
                    children: <Widget>[
                      Container(
                          child: CircularProgressIndicator(),
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            image: DecorationImage(
                              image: AssetImage(
                                  "assets/images/children.png"), //image above the text
                              fit: BoxFit.fill,
                            ),
                          ),
                          height: 200,
                          width: 200),
                      RaisedButton(
                          color: Colors.transparent,
                          child: Text(
                            "Lets Learn English",
                            style: TextStyle(
                                fontFamily: 'FredokaOne-Regular',
                                fontSize: 30,
                                color: Colors.pink),
                          ),
                          onPressed: () {
                          }),
                    ],
                  ),
                ),
                crossFadeState: CrossFadeState.showSecond, //display the second child
                duration: Duration(milliseconds: 2000),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
