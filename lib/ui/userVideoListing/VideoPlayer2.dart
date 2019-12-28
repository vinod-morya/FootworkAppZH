//import 'dart:io';
//
//import 'package:chewie/chewie.dart';
//import 'package:flutter/material.dart';
//import 'package:flutter/services.dart';
//import 'package:footwork_chinese/constants/app_colors.dart';
//import 'package:footwork_chinese/style/theme.dart';
//import 'package:gradient_app_bar/gradient_app_bar.dart';
//import 'package:video_player/video_player.dart';
//
//class Video2 extends StatefulWidget {
//  final video_url;
//  final id;
//  final month;
//  final video_play_status;
//  final video_play_time;
//
//  Video2(
//      {this.video_url,
//      this.id,
//      this.month,
//      this.video_play_status,
//      this.video_play_time});
//
//  @override
//  _Video2State createState() => _Video2State();
//}
//
//class _Video2State extends State<Video2> {
//  VideoPlayerController videoPlayerController;
//
//  ChewieController chewieController;
//
//  Chewie playerWidget;
//
//  @override
//  void initState() {
//    SystemChrome.setPreferredOrientations([
//      DeviceOrientation.landscapeRight,
//      DeviceOrientation.landscapeLeft,
//    ]);
//    videoPlayerController =
//        VideoPlayerController.network('${widget.video_url}');
//    var data = widget.video_play_time != null
//        ? widget.video_play_time.toString().split(':').toList()
//        : [];
//
//    chewieController = ChewieController(
//      videoPlayerController: videoPlayerController,
//      autoPlay: true,
//      fullScreenByDefault: true,
//      startAt: data.length > 1
//          ? Duration(
//              hours: int.parse(data[0]),
//              minutes: int.parse(data[1]),
//              seconds: int.parse(data[2].toString().split('.')[0]))
//          : Duration(hours: 0, minutes: 0, seconds: 0),
//      deviceOrientationsAfterFullScreen: const [
//        DeviceOrientation.portraitUp,
//        DeviceOrientation.portraitDown,
//      ],
//    );
//
//    playerWidget = Chewie(
//      controller: chewieController,
//    );
//    super.initState();
//  }
//
//  @override
//  void dispose() {
//    videoPlayerController.dispose();
//    chewieController.dispose();
//    SystemChrome.setPreferredOrientations([
//      DeviceOrientation.portraitUp,
//      DeviceOrientation.portraitDown,
//    ]);
//    super.dispose();
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return WillPopScope(
//      child: Scaffold(
//        appBar: _gradientAppBarWidget(),
//        body: Center(
//          child: Container(
//            width: MediaQuery.of(context).size.width,
//            height: MediaQuery.of(context).size.height,
//            padding: const EdgeInsets.only(top: 25.0),
//            child: playerWidget,
//          ),
//        ),
//      ),
//      onWillPop: () {
//        final Duration duration = videoPlayerController.value.duration;
//        Duration playLength = videoPlayerController.value.position;
//        if (duration != null && playLength != null)
//          playLength = (playLength > duration) ? duration : playLength;
//        Navigator.of(context).pop(playLength);
//      },
//    );
//  }
//
//  Widget _gradientAppBarWidget() {
//    return GradientAppBar(
//      gradient: ColorsTheme.dashBoardGradient,
//      centerTitle: true,
//      leading: InkWell(
//        child: Icon(
//          Platform.isAndroid ? Icons.arrow_back : Icons.arrow_back_ios,
//          color: colorWhite,
//        ),
//        onTap: () {
//          final Duration duration = videoPlayerController.value.duration;
//          Duration playLength = videoPlayerController.value.position;
//          if (duration != null && playLength != null)
//            playLength = (playLength > duration) ? duration : playLength;
//          Navigator.of(context).pop(playLength);
//        },
//      ),
//    );
//  }
//}
