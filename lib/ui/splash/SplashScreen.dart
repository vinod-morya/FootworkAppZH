import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fm_fit/fm_fit.dart';
import 'package:footwork_chinese/constants/app_colors.dart';
import 'package:footwork_chinese/constants/app_constants.dart';
import 'package:footwork_chinese/custom_widget/custom_progress_loader.dart';
import 'package:footwork_chinese/utils/Utility.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  FmFit fit = FmFit(width: 750);

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
    fit = FmFit(width: MediaQuery.of(context).size.width);
    if (MediaQuery.of(context).size.width > 600) {
      fit.scale = 1.0 + MediaQuery.of(context).size.aspectRatio;
    } else {
      fit.scale = 1.0;
    }
    return Scaffold(
      backgroundColor: colorWhite,
      body: Stack(
        children: <Widget>[
          ProgressLoader(
            fit: fit,
            isShowLoader: true,
            color: appColor,
          ),
        ],
      ),
    );
  }
}
