import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fm_fit/fm_fit.dart';
import 'package:footwork_chinese/constants/app_colors.dart';
import 'package:footwork_chinese/constants/app_constants.dart';
import 'package:footwork_chinese/constants/app_images_path.dart';
import 'package:footwork_chinese/custom_widget/circular_progress_widget/CircleProgress.dart';
import 'package:footwork_chinese/model/userDashBoardResponse/UserDashBoardResponse.dart';
import 'package:footwork_chinese/style/theme.dart';
import 'package:footwork_chinese/ui/userVideoListing/VideoPlayWebview.dart';
import 'package:footwork_chinese/utils/app_localizations.dart';
import 'package:footwork_chinese/utils/date_formatter.dart';
import 'package:webview_flutter/webview_flutter.dart';

class UserDashboardListItem extends StatefulWidget {
  final DataListBean data;
  final int pos;
  final Function(int pos) onTap;
  final progressController;
  final animation;
  final FmFit fit;

  UserDashboardListItem(
      {this.data,
      this.pos,
      this.onTap,
      this.fit,
      this.animation,
      this.progressController});

  @override
  _UserDashboardListItemState createState() => _UserDashboardListItemState();
}

class _UserDashboardListItemState extends State<UserDashboardListItem> {
  AnimationController progressController;
  Animation<double> animation;
  WebViewController _controller;

  var data = Uri.dataFromString(
          '''<html><head><meta name="viewport" content="width=device,height=device, initial-scale=1"><style>
.loader {
position: relative;
    top: 25%;
    left: 45%;
  border: 4px solid #f3f3f3;
  border-radius: 50%;
  border-top: 4px solid #d50a30;
  width: 20px;
  height: 20px;
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
</style></head><body><div class="loader"></div></body></html>''',
          mimeType: 'text/html', encoding: Encoding.getByName('utf-8'))
      .toString();

  @override
  void initState() {
    progressController = widget.progressController;
    progressController.forward();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    animation = widget.animation;
    return widget.pos == 0
        ? Container(
            margin: EdgeInsets.only(
                left: widget.fit.t(16.0),
                right: widget.fit.t(16.0),
                top: widget.pos == 0 ? widget.fit.t(16.0) : 0.0,
                bottom: 15.0),
            height: fit.t(375.0),
            width: MediaQuery.of(context).size.width,
            child: Platform.isIOS
                ? WebView(
                    javascriptMode: JavascriptMode.unrestricted,
                    initialUrl: data,
                    onPageFinished: (some) async {},
                    initialMediaPlaybackPolicy:
                        AutoMediaPlaybackPolicy.always_allow,
                    onWebViewCreated: (WebViewController webViewController) {
                      _controller = webViewController;
                      _controller.loadUrl(
                          'https://fast.wistia.net/embed/iframe/ywf2yh5g7o?autoplay=0&muted=0&playerColor=d50a30');
                    },
                  )
                : GestureDetector(
                    onTap: () => onVideoTap(
                        'https://fast.wistia.net/embed/iframe/ywf2yh5g7o'),
                    child: Container(
                      height: widget.fit.t(375.0),
                      width: MediaQuery.of(context).size.width,
                      child: Stack(
                        children: <Widget>[
                          Container(
                            child: CachedNetworkImage(
                              height: widget.fit.t(375.0),
                              width: MediaQuery.of(context).size.width,
                              imageUrl:
                                  'http://footworkmat.com/wp-content/uploads/2019/12/Thumb_Turn-Pound-Partial-Step-Under-Dribble-Foot-Switch.png',
                              imageBuilder: (context, imageProvider) =>
                                  Container(
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: imageProvider,
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                              errorWidget: (context, url, error) =>
                                  Icon(Icons.error),
                            ),
                            decoration: BoxDecoration(
                                shape: BoxShape.rectangle, color: colorGrey),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              gradient: ColorsTheme.background,
                            ),
                          ),
                          Positioned(
                            left: 0,
                            right: 0,
                            bottom: 0,
                            top: 0,
                            child: Center(
                              child: Image.asset(
                                '$ic_play',
                                height: widget.fit.t(35.0),
                                width: widget.fit.t(35.0),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
          )
        : GestureDetector(
            onTap: () =>
                widget.data.tapStatus == 1 ? widget.onTap(widget.pos) : null,
            child: Stack(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(0.0),
                  margin: EdgeInsets.only(
                      left: widget.fit.t(16.0),
                      right: widget.fit.t(16.0),
                      top: widget.pos == 0 ? widget.fit.t(16.0) : 0.0,
                      bottom: 0.0),
                  child: Column(
                    children: <Widget>[
                      Container(
                        color: Colors.white,
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.all(widget.fit.t(3.0)),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  Text(
                                    "",
                                    style: TextStyle(
                                        fontSize: widget.fit.t(12.0),
                                        fontWeight: FontWeight.normal),
                                  ),
                                  RichText(
                                    text: TextSpan(
                                      text: widget.data.tapStatus == 1
                                          ? '${AppLocalizations.of(context).translate("last_activity")}'
                                          : widget.data.lastActivity != null
                                              ? '${AppLocalizations.of(context).translate("unlock")}'
                                              : '',
                                      style: TextStyle(
                                        fontSize: widget.fit.t(9.0),
                                        color: Color(0xFFA7A9AC),
                                        fontFamily: regularFont,
                                        fontWeight: FontWeight.normal,
                                      ),
                                      children: <TextSpan>[
                                        TextSpan(
                                          text: widget.data.lastActivity != null
                                              ? '${getDate(widget.data.lastActivity, 'MMMM dd, yyyy')}'
                                              : '',
                                          style: TextStyle(
                                            fontSize: widget.fit.t(9.0),
                                            color: Color(0xFFA9A9A9),
                                            fontFamily: regularFont,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Divider(
                              color: colorGrey,
                              height: fit.t(0.5),
                            )
                          ],
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        color: Colors.white,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                Flexible(
                                  flex: 2,
                                  child: Container(
                                    margin: EdgeInsets.only(
                                      bottom: widget.fit.t(9.0),
                                      top: widget.fit.t(10.0),
                                    ),
                                    padding: EdgeInsets.only(
                                        left: widget.fit.t(10.0),
                                        right: widget.fit.t(20.0)),
                                    child: Text(
                                      '\"${widget.data.label == null ? "Month 1" : widget.data.label}\"',
                                      softWrap: true,
                                      style: TextStyle(
                                          fontSize: widget.fit.t(11.0),
                                          color: widget.data.tapStatus == 1
                                              ? Color(0xFFD50A30)
                                              : colorGrey,
                                          fontWeight: FontWeight.w800,
                                          fontFamily: robotoBoldFont),
                                    ),
                                  ),
                                ),
                                Flexible(
                                  flex: 1,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.max,
                                    children: <Widget>[
                                      widget.data.tapStatus == 1
                                          ? Container(
                                              margin: EdgeInsets.only(
                                                  top: 0.0,
                                                  right: widget.fit.t(10.0),
                                                  left: widget.fit.t(5.0),
                                                  bottom: 0.0),
                                              child: AnimatedBuilder(
                                                animation: progressController,
                                                builder: (context, child) {
                                                  return CustomPaint(
                                                    foregroundPainter:
                                                        CircleProgress(
                                                      animation.value,
                                                      _getColor(
                                                          animation.value),
                                                      animation.value == 0.0
                                                          ? Color(0x20464649)
                                                          : Color(0x64464649),
                                                    ),
                                                    // this will add a custom painter after a child
                                                    child: Container(
                                                      width: widget.fit.t(85.0),
                                                      height:
                                                          widget.fit.t(85.0),
                                                      child: GestureDetector(
                                                        child: Center(
                                                          child: widget.data
                                                                      .playVideo ==
                                                                  int.parse(widget
                                                                      .data
                                                                      .totalVideos)
                                                              ? Icon(
                                                                  Icons.check,
                                                                  size: widget
                                                                      .fit
                                                                      .t(50.0),
                                                                  color: widget
                                                                              .data
                                                                              .tapStatus ==
                                                                          1
                                                                      ? appColor
                                                                      : colorGrey,
                                                                )
                                                              : RichText(
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  text:
                                                                      TextSpan(
                                                                    text:
                                                                        '${widget.data.playVideo}',
                                                                    style:
                                                                        TextStyle(
                                                                      color:
                                                                          appColor,
                                                                      fontSize: widget
                                                                          .fit
                                                                          .t(18.0),
                                                                      fontFamily:
                                                                          robotoBoldFont,
                                                                      fontStyle:
                                                                          FontStyle
                                                                              .normal,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w400,
                                                                    ),
                                                                    children: <
                                                                        TextSpan>[
                                                                      TextSpan(
                                                                        text:
                                                                            '\n${AppLocalizations.of(context).translate("of")} ${widget.data.totalVideos}',
                                                                        style:
                                                                            TextStyle(
                                                                          fontSize: widget
                                                                              .fit
                                                                              .t(10.0),
                                                                          fontFamily:
                                                                              robotoBoldFont,
                                                                          fontWeight:
                                                                              FontWeight.w500,
                                                                          color:
                                                                              colorBlack,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
                                            )
                                          : Center(
                                              child: Container(
                                                margin: EdgeInsets.only(
                                                  top: widget.fit.t(20.0),
//                                      right: widget.fit.t(10.0),
//                                      left: widget.fit.t(80.0),
                                                  bottom: widget.fit.t(20.0),
                                                ),
                                                padding: EdgeInsets.only(
                                                  left: 5.0,
                                                  right: widget.fit.t(0.0),
                                                ),
                                                child: Image.asset(
                                                  ic_lock,
                                                  height: widget.fit.t(65.0),
                                                  width: widget.fit.t(65.0),
                                                ),
                                              ),
                                            ),
                                      widget.data.tapStatus == 1
                                          ? Container(
                                              margin: EdgeInsets.only(
                                                  top:
                                                      widget.data.tapStatus == 1
                                                          ? 0.0
                                                          : widget.fit.t(8.0),
//                                      right: widget.fit.t(10.0),
                                                  left: widget.fit.t(5.0),
                                                  bottom: widget.pos == 0
                                                      ? widget.fit.t(8.0)
                                                      : widget.fit.t(10.0)),
                                              padding: EdgeInsets.only(
                                                  left: 0.0,
                                                  right: widget.fit.t(10.0)),
                                              child: Text(
                                                widget.data.tapStatus == 1
                                                    ? widget.data.playVideo ==
                                                            int.parse(widget
                                                                .data
                                                                .totalVideos)
                                                        ? '${AppLocalizations.of(context).translate("completed")}!'
                                                        : '${AppLocalizations.of(context).translate("completed")}'
                                                    : '',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontSize:
                                                        widget.fit.t(10.0),
                                                    color:
                                                        widget.data.tapStatus ==
                                                                1
                                                            ? appColor
                                                            : colorGrey,
                                                    fontFamily:
                                                        robotoBoldCondenseFont,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            )
                                          : Container(),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                      left: widget.fit.t(25.0),
                      top: widget.pos == 0
                          ? widget.fit.t(50.0)
                          : widget.fit.t(35.0)),
                  child: IntrinsicHeight(
                    child: Text(
                      '#${widget.data.month == null ? "01" : int.parse(widget.data.month) > 9 ? int.parse(widget.data.month) : '0${int.parse(widget.data.month)}'}',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: widget.fit.t(90.0),
                        color:
                            widget.data.tapStatus == 1 ? appColor : colorGrey,
                        fontFamily: robotoMediumFont,
                      ),
                      textScaleFactor: 1.2,
                    ),
                  ),
                ),
              ],
            ),
          );
  }

  Color _getColor(double value) {
    return value > 25
        ? value > 50
            ? value > 75 ? appColor : Color(0xFFFF1B41)
            : Color(0xFFFF3556)
        : Color(0xFFFF5E6D);
  }

  onVideoTap(String url) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => VideoPlayWebview(
                video_url: url,
                id: 0,
                month: 0,
                video_play_status: 0,
                video_play_time: 0,
              )),
    );
  }
}
