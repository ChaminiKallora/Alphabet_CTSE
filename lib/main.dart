import 'package:abcd/imageUpload/imageListView.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ABCDWelcomeSplashScreen(), //call the splash screen
    );
  }
}

class ABCDWelcomeSplashScreen extends StatefulWidget {
  @override
  _ABCDWelcomeSplashScreenState createState() =>
      _ABCDWelcomeSplashScreenState();
}

//splash screen
class _ABCDWelcomeSplashScreenState extends State<ABCDWelcomeSplashScreen> {
  bool show = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[300],
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
                  color: Colors.transparent,
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
                                  "assets/images/children.png"), //background image
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
                            //goes to the list page
                            var route = new MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  new ImageListView(),
                            );
                            Navigator.of(context).push(route);
                          }),
                    ],
                  ),
                ),
                crossFadeState: CrossFadeState.showSecond,
                duration: Duration(milliseconds: 2000),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
