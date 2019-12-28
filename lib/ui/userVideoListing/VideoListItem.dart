import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fm_fit/fm_fit.dart';
import 'package:footwork_chinese/constants/app_colors.dart';
import 'package:footwork_chinese/constants/app_constants.dart';
import 'package:footwork_chinese/constants/app_images_path.dart';
import 'package:footwork_chinese/model/VideolistResponse/VideoListResponseData.dart';
import 'package:footwork_chinese/style/theme.dart';
import 'package:footwork_chinese/utils/app_localizations.dart';

class VideoListItem extends StatefulWidget {
  final VideoListBean data;
  final int pos;
  final Function(int pos) onTap;
  final Function(int pos) onTapMarkComplete;
  final Function(int pos) onTapFavourite;
  final Function(int pos) onTapChat;
  final FmFit fit;

  VideoListItem(
      {this.data,
      this.pos,
      this.fit,
      this.onTap,
      this.onTapFavourite,
      this.onTapMarkComplete,
      this.onTapChat});

  @override
  _VideoListItemState createState() => _VideoListItemState();
}

class _VideoListItemState extends State<VideoListItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(widget.fit.t(15.0)),
      color: colorWhite,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          IntrinsicHeight(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Flexible(
                  flex: 3,
                  child: Container(
                    margin: EdgeInsets.all(widget.fit.t(5.0)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(left: widget.fit.t(10.0)),
                          child: Text(
                            '${widget.data.label}',
                            style: TextStyle(
                              color: Color(0xFFD50A30),
                              fontFamily: robotoMediumFont,
                              fontSize: widget.fit.t(28.0),
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.start,
                          ),
                        ),
                        SizedBox(
                          height: widget.fit.t(10.0),
                        ),
                        Row(
                          children: <Widget>[
                            SizedBox(
                              width: widget.fit.t(10.0),
                            ),
                            GestureDetector(
                              onTap: () => widget.onTapMarkComplete(widget.pos),
                              child: Image.asset(
                                widget.data.playStatus.length > 0
                                    ? widget.data.playStatus[0]
                                                .videoPlayStatus ==
                                            "0"
                                        ? '$ic_check_grey'
                                        : '$ic_check_blue'
                                    : '$ic_check_grey',
                                height: widget.fit.t(35.0),
                                width: widget.fit.t(35.0),
                              ),
                            ),
                            SizedBox(
                              width: widget.fit.t(10.0),
                            ),
                            Text(
                              widget.data.playStatus.length > 0
                                  ? widget.data.playStatus[0].videoPlayStatus ==
                                          "0"
                                      ? '${AppLocalizations.of(context).translate("mark_complete_label")}'
                                      : '${AppLocalizations.of(context).translate("completed")}!'
                                  : '${AppLocalizations.of(context).translate("mark_complete_label")}',
                              style: TextStyle(
                                  color: widget.data.playStatus.length > 0
                                      ? widget.data.playStatus[0]
                                                  .videoPlayStatus ==
                                              "0"
                                          ? Color(0xFF96989d)
                                          : appColor
                                      : Color(0xFF96989d),
                                  fontWeight: widget.data.playStatus.length > 0
                                      ? widget.data.playStatus[0]
                                                  .videoPlayStatus ==
                                              "0"
                                          ? FontWeight.bold
                                          : FontWeight.w500
                                      : FontWeight.bold,
                                  fontFamily: robotoMediumFont,
                                  fontSize: widget.fit.t(10.0)),
                            )
                          ],
                        ),
                        SizedBox(height: widget.fit.t(10.0)),
                        Divider(
                          height: widget.fit.t(1.0),
                          color: appColor,
                          indent: widget.fit.t(15.0),
                        ),
                        SizedBox(height: widget.fit.t(10.0)),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            GestureDetector(
                              onTap: () => widget.onTapChat(widget.pos),
                              child: Container(
                                padding: EdgeInsets.only(
                                    left: 0.0,
                                    right: widget.fit.t(5.0),
                                    top: widget.fit.t(2.0)),
                                margin:
                                    EdgeInsets.only(left: widget.fit.t(14.0)),
                                child: Image.asset(
                                  '$ic_chat_blue',
                                  color: appColor,
                                  height: widget.fit.t(20.0),
                                  width: widget.fit.t(20.0),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () => widget.onTapFavourite(widget.pos),
                              child: Container(
                                padding: EdgeInsets.only(
                                    left: 0.0, right: widget.fit.t(5.0)),
                                margin:
                                    EdgeInsets.only(left: widget.fit.t(5.0)),
                                child: Image.asset(
                                  widget.data.playStatus.length > 0
                                      ? widget.data.playStatus[0].isFavorite ==
                                              "1"
                                          ? '$ic_star_fill'
                                          : '$ic_star_empty'
                                      : '$ic_star_empty',
                                  height: widget.fit.t(20.0),
                                  width: widget.fit.t(20.0),
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                Flexible(
                  flex: 2,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      GestureDetector(
                        onTap: () => widget.onTap(widget.pos),
                        child: Container(
                          height: widget.fit.t(100.0),
                          width: widget.fit.t(100.0),
                          margin: EdgeInsets.all(widget.fit.t(5.0)),
                          child: Stack(
                            children: <Widget>[
                              Container(
                                child: CachedNetworkImage(
                                  height: widget.fit.t(100.0),
                                  width: widget.fit.t(100.0),
                                  imageUrl: '${widget.data.videoThumb}',
                                  imageBuilder: (context, imageProvider) =>
                                      Container(
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: imageProvider,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      Icon(Icons.error),
                                ),
                                decoration: BoxDecoration(
                                    shape: BoxShape.rectangle,
                                    color: colorGrey),
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
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
