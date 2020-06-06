import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:fm_fit/fm_fit.dart';
import 'package:footwork_chinese/constants/app_colors.dart';
import 'package:footwork_chinese/constants/app_constants.dart';
import 'package:footwork_chinese/style/theme.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';

const kUserAgent =
    'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/62.0.3202.94 Mobile Safari/537.36';

class WebViewSupport extends StatefulWidget {
  @override
  _WebViewSupportState createState() => _WebViewSupportState();
}

class _WebViewSupportState extends State<WebViewSupport> {
  FmFit fit = FmFit(width: 750);

  @override
  void initState() {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    fit = FmFit(width: MediaQuery.of(context).size.width);
    if (MediaQuery.of(context).size.width > 600) {
      fit.scale = 1.0 + MediaQuery.of(context).size.aspectRatio;
    } else {
      fit.scale = 1.0;
    }
    return WebviewScaffold(
      appBar: _gradientAppBarWidget(),
      useWideViewPort: true,
      supportMultipleWindows: false,
      url: CONTACT_US,
      withLocalStorage: true,
      hidden: true,
      ignoreSSLErrors: false,
      allowFileURLs: true,
      initialChild: Container(
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      ),
      clearCache: false,
      clearCookies: true,
      debuggingEnabled: false,
      withJavascript: true,
      userAgent: kUserAgent,
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
}
