import 'dart:async';
import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fm_fit/fm_fit.dart';
import 'package:footwork_chinese/constants/app_colors.dart';
import 'package:footwork_chinese/style/theme.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerApp extends StatefulWidget {
  final video_Url;

  VideoPlayerApp({this.video_Url});

  @override
  _VideoPlayerAppState createState() => _VideoPlayerAppState();
}

class _VideoPlayerAppState extends State<VideoPlayerApp>
    with WidgetsBindingObserver {
  FmFit fit = FmFit(width: 750);

  VideoPlayerController videoPlayerController;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight
    ]);
    videoPlayerController = VideoPlayerController.network(widget.video_Url);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    videoPlayerController.dispose();
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    videoPlayerController.pause();
    Future.delayed(Duration(seconds: 1), _plaVideo);
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
      appBar: _gradientAppBarWidget(),
      body: Stack(
        children: <Widget>[
          Platform.isIOS ? Center(child: CircularProgressIndicator()) : Container(),
          Chewie(
            controller: ChewieController(
                videoPlayerController: videoPlayerController,
                aspectRatio: 3 / 2,
                autoPlay: true,
                looping: false,
                allowFullScreen: true,
                autoInitialize: true,
                showControlsOnInitialize: false,
                deviceOrientationsAfterFullScreen: [
                  DeviceOrientation.portraitUp,
                ]),
          ),
        ],
      ),
    );
  }

  Widget _gradientAppBarWidget() {
    return GradientAppBar(
      gradient: ColorsTheme.dashBoardGradient,
      centerTitle: true,
      leading: InkWell(
        child: Icon(
          Platform.isAndroid ? Icons.arrow_back : Icons.arrow_back_ios,
          color: colorWhite,
          size: fit.t(25.0),
        ),
        onTap: () {
          Navigator.of(context).pop();
        },
      ),
    );
  }

  FutureOr _plaVideo() {
    videoPlayerController.play();
  }
}
