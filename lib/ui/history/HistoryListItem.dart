import 'package:flutter/material.dart';
import 'package:fm_fit/fm_fit.dart';
import 'package:footwork_chinese/constants/app_colors.dart';
import 'package:footwork_chinese/constants/app_constants.dart';
import 'package:footwork_chinese/model/HistoryItemModel.dart';

class HistoryListItem extends StatelessWidget {
  final HistoryItemModel data;
  final pos;
  final onclickItem;
  final FmFit fit;

  HistoryListItem({this.data, this.pos, this.onclickItem, this.fit});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onclickItem(pos),
      child: Container(
        padding: EdgeInsets.all(fit.t(8.0)),
        margin: EdgeInsets.only(
            top: pos != 0 ? fit.t(4.0) : fit.t(16.0),
            bottom: fit.t(8.0),
            left: fit.t(16.0),
            right: fit.t(16.0)),
        color: Colors.white,
        child: Container(
          padding: EdgeInsets.all(fit.t(10.0)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              data.icon == null
                  ? Container()
                  : Icon(
                      data.icon,
                      color: appColor,
                      size: fit.t(28.0),
                    ),
              SizedBox(
                width: data.icon == null ? 0.0 : fit.t(5.0),
              ),
              Flexible(
                child: Container(
                  padding: EdgeInsets.only(top: fit.t(5.0)),
                  child: Text(
                    data.title,
                    overflow:TextOverflow.ellipsis,
                    softWrap: true,
                    maxLines: 2,
                    style: TextStyle(
                      color: Color(0xFFD50A30),
                      fontFamily: robotoBoldFont,
                      fontSize: fit.t(25.0),
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
