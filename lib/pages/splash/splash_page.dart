import 'dart:async';

import 'package:flutter/material.dart';

import '../fingerprint.dart';
import '../tab/tab_page.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    Timer(
        Duration(seconds: 3),
        () => Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (BuildContext context) => TabPage())));
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        height: size.height,
        width: size.width,
        margin: EdgeInsets.only(left: 50,right: 50),
        decoration: BoxDecoration(
            image: DecorationImage(
          image: AssetImage('assets/splash/splash.gif'),
          fit: BoxFit.contain,
        )),
        child: Stack(
          children: <Widget>[
            Positioned(
              left: 0.0,
              right: 0.0,
              bottom: size.height * 0.18,
              child: Text(
                'E - WALLET',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black, fontSize: 21,fontWeight: FontWeight.w300),
              ),
            ),
            Positioned(
              left: 0.0,
              right: 0.0,
              bottom: size.height * 0.10,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Developed By Omer TajElsir',
                    style: TextStyle(fontSize: 13,fontWeight: FontWeight.w200),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
