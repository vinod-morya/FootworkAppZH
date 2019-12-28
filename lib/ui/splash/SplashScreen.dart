import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:footwork_chinese/constants/app_constants.dart';
import 'package:footwork_chinese/utils/Utility.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
    _startSplashScreenTimer();
  }

  _startSplashScreenTimer() async {
    var _duration = Duration(microseconds: splashDuration);
    return Timer(_duration, _navigationToNextPage);
  }

  void _navigationToNextPage() {
    getBoolDataLocally(key: session).then((onValue) {
      if (onValue) {
        Navigator.pushReplacementNamed(context, '/dashboardScreen');
      } else {
        Navigator.pushReplacementNamed(context, '/login');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(),
    );
  }
}
