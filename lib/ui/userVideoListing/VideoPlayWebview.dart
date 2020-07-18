import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:footwork_chinese/constants/app_colors.dart';
import 'package:webview_flutter/webview_flutter.dart';

class VideoPlayWebview extends StatefulWidget {
  final video_url;
  final id;
  final month;
  final video_play_status;
  final video_play_time;

  @override
  _VideoPlayWebviewState createState() => _VideoPlayWebviewState();

  VideoPlayWebview(
      {this.video_url,
      this.id,
      this.month,
      this.video_play_status,
      this.video_play_time});
}

class _VideoPlayWebviewState extends State<VideoPlayWebview>
    with WidgetsBindingObserver {
  var _scaffoldKey = GlobalKey<ScaffoldState>();
  WebViewController _controller;

  var data = Uri.dataFromString(
          '''<html><head><meta name="viewport" content="width=device,height=device, initial-scale=1"><style>
.loader {
position: relative;
    left: 45%;
    top: 45%;
    right:55%;
    bottom:55%;
  border: 4px solid #f3f3f3;
  border-radius: 50%;
  border-top: 4px solid #d50a30;
  width: 50px;
  height: 50px;
  -webkit-animation: spin 1s linear infinite;
  animation: spin 1s linear infinite;
}
@-webkit-keyframes spin {
  0% { -webkit-transform: rotate(0deg); }
  100% { -webkit-transform: rotate(360deg); }
}
@keyframes spin {
  0% { transform: rotate(0deg); }
  100% { transform: rotate(360deg); }
}
</style></head><body><div class="loader"></div></body></html>

''',
          mimeType: 'text/html', encoding: Encoding.getByName('utf-8'))
      .toString();

  WebView webView;

  @override
  void initState() {
    webView = WebView(
      javascriptMode: JavascriptMode.unrestricted,
      initialUrl: data,
      onPageFinished: (some) async {},
      initialMediaPlaybackPolicy: AutoMediaPlaybackPolicy.always_allow,
      onWebViewCreated: (WebViewController webViewController) {
        _controller = webViewController;
        if (widget.video_url.toString().contains("wistia")) {
          _controller.loadUrl(
              '${widget.video_url}?autoplay=1&muted=0&playerColor=d50a30');
        } else {
          _controller.loadUrl('${widget.video_url}');
        }
      },
      onWebResourceError: (error) {
        print(error);
      },
    );

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp
    ]);
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (BuildContext context, Orientation orientation) {
        return Scaffold(
          key: _scaffoldKey,
          appBar: Platform.isIOS
              ? AppBar(
                  backgroundColor: colorBlack,
                )
              : null,
          body: Stack(
            children: <Widget>[
              webView,
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    _controller?.clearCache();
    _controller = null;
    webView = null;
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.paused:
        _controller.evaluateJavascript('pause');
        break;
      case AppLifecycleState.resumed:
        _controller.evaluateJavascript('play');
        break;
      default:
        break;
    }
  }
}
