import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fm_fit/fm_fit.dart';
import 'package:footwork_chinese/constants/app_colors.dart';
import 'package:footwork_chinese/constants/app_constants.dart';
import 'package:footwork_chinese/constants/app_images_path.dart';
import 'package:footwork_chinese/model/favouriteVideo/FavouriteVideoResponse.dart';
import 'package:footwork_chinese/style/theme.dart';
import 'package:footwork_chinese/utils/app_localizations.dart';

class FavouriteListItem extends StatefulWidget {
  final DataListBean data;
  final int pos;
  final FmFit fitScreen;
  final Function(int pos) onTap;
  final Function(int pos) onTapMarkComplete;
  final Function(int pos) onTapFavourite;
  final Function(int pos) onTapChat;

  FavouriteListItem(
      {this.data,
      this.pos,
      this.onTap,
      this.fitScreen,
      this.onTapFavourite,
      this.onTapChat,
      this.onTapMarkComplete});

  @override
  _FavouriteListItemState createState() => _FavouriteListItemState();
}

class _FavouriteListItemState extends State<FavouriteListItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(widget.fitScreen.t(15.0)),
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
                    margin: EdgeInsets.all(widget.fitScreen.t(5.0)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          margin:
                              EdgeInsets.only(left: widget.fitScreen.t(10.0)),
                          child: Text(
                            '${widget.data.label}',
                            style: TextStyle(
                              color: Color(0xFFD50A30),
                              fontFamily: robotoMediumFont,
                              fontSize: widget.fitScreen.t(26.0),
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.start,
                          ),
                        ),
                        SizedBox(
                          height: widget.fitScreen.t(10.0),
                        ),
                        Row(
                          children: <Widget>[
                            SizedBox(
                              width: widget.fitScreen.t(10.0),
                            ),
                            GestureDetector(
                              onTap: () => widget.onTapMarkComplete(widget.pos),
                              child:
                                  widget.data.playStatus.videoPlayStatus == "0"
                                      ? Image.asset(
                                          '$ic_check_grey',
                                          height: widget.fitScreen.t(35.0),
                                          width: widget.fitScreen.t(35.0),
                                        )
                                      : SvgPicture.asset(
                                          '$ic_check_blue_try',
                                          height: widget.fitScreen.t(35.0),
                                          width: widget.fitScreen.t(35.0),
                                        ),
                            ),
                            SizedBox(
                              width: widget.fitScreen.t(10.0),
                            ),
                            Text(
                              widget.data.playStatus.videoPlayStatus == "0"
                                  ? '${AppLocalizations.of(context).translate("mark_complete_label")}'
                                  : '${AppLocalizations.of(context).translate("completed")}!',
                              style: TextStyle(
                                color: widget.data.playStatus.videoPlayStatus ==
                                        "0"
                                    ? Color(0xFF96989d)
                                    : appColor,
                                fontWeight:
                                    widget.data.playStatus.videoPlayStatus ==
                                            "0"
                                        ? FontWeight.bold
                                        : FontWeight.w500,
                                fontFamily: robotoMediumFont,
                                fontSize: widget.fitScreen.t(10.0),
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: widget.fitScreen.t(10.0),
                        ),
                        Divider(
                          height: widget.fitScreen.t(1.0),
                          color: appColor,
                          indent: widget.fitScreen.t(15.0),
                        ),
                        SizedBox(
                          height: widget.fitScreen.t(10.0),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            GestureDetector(
                              onTap: () => widget.onTapChat(widget.pos),
                              child: Container(
                                padding: EdgeInsets.only(
                                    left: 0.0,
                                    right: widget.fitScreen.t(5.0),
                                    top: widget.fitScreen.t(2.0)),
                                margin: EdgeInsets.only(
                                    left: widget.fitScreen.t(14.0)),
                                child: Image.asset(
                                  '$ic_chat_blue',
                                  color: appColor,
                                  height: widget.fitScreen.t(20.0),
                                  width: widget.fitScreen.t(20.0),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () => widget.onTapFavourite(widget.pos),
                              child: Container(
                                padding: EdgeInsets.only(
                                    left: 0.0, right: widget.fitScreen.t(5.0)),
                                margin: EdgeInsets.only(
                                    left: widget.fitScreen.t(10.0)),
                                child: Image.asset(
                                  widget.data.playStatus.isFavorite == "1"
                                      ? '$ic_star_fill'
                                      : '$ic_star_empty',
                                  height: widget.fitScreen.t(20.0),
                                  width: widget.fitScreen.t(20.0),
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
                          height: widget.fitScreen.t(100.0),
                          width: widget.fitScreen.t(100.0),
                          margin: EdgeInsets.all(widget.fitScreen.t(5.0)),
                          child: Stack(
                            children: <Widget>[
                              Container(
                                child: CachedNetworkImage(
                                  height: widget.fitScreen.t(100.0),
                                  width: widget.fitScreen.t(100.0),
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
                                    height: widget.fitScreen.t(35.0),
                                    width: widget.fitScreen.t(35.0),
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
