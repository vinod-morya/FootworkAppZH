import 'package:flutter/material.dart';
import 'package:flutter_seekbar/seekbar/progress_value.dart';
import 'package:flutter_seekbar/seekbar/seekbar.dart';
import 'package:fm_fit/fm_fit.dart';
import 'package:footwork_chinese/constants/app_colors.dart';
import 'package:footwork_chinese/constants/app_constants.dart';
import 'package:footwork_chinese/constants/app_images_path.dart';
import 'package:footwork_chinese/utils/app_localizations.dart';

class MarkAsCompleteContent extends StatefulWidget {
  final title;
  final okBtnText;
  final cancelBtnText;
  final content;
  final icon;
  final okBtnFunction;
  final cancelBtnFunction;
  final rating;

  MarkAsCompleteContent(
      this.title,
      this.okBtnText,
      this.cancelBtnText,
      this.content,
      this.icon,
      this.okBtnFunction,
      this.cancelBtnFunction,
      this.rating);

  @override
  _MarkAsCompleteContentState createState() => _MarkAsCompleteContentState();
}

class _MarkAsCompleteContentState extends State<MarkAsCompleteContent> {
  String ratingText = '0';
  double ratingValue = 1.0;
  String ratingRemark = 'VERY EASY';
  Color color = Color(0xcc0A4E93);
  FmFit fit = FmFit(width: 750);

  @override
  void initState() {
    ratingValue =
        double.parse(widget.rating) == 0.0 ? 1.0 : double.parse(widget.rating);
    ratingText = ratingValue.toInt().toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    fit = FmFit(width: MediaQuery.of(context).size.width);
    if (MediaQuery.of(context).size.width > 600) {
      fit.scale = 1.0 + MediaQuery.of(context).size.aspectRatio;
    } else {
      fit.scale = 1.0;
    }
    _getRatingColorText(ratingValue.toInt());
    return Container(
        padding: EdgeInsets.symmetric(
            horizontal: fit.t(40.0), vertical: fit.t(24.0)),
        width: fit.t(MediaQuery.of(context).size.width),
        height: fit.t(MediaQuery.of(context).size.height),
        margin: EdgeInsets.only(top: fit.t(20.0)),
        child: Stack(
          children: <Widget>[
            ListView(
              physics: NeverScrollableScrollPhysics(),
              children: <Widget>[
                Image.asset(
                  ic_app_icon,
                  scale: fit.scale == 1 ? 3.0 : 2.0,
                  color: Colors.white,
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(fit.t(5.0)),
                    color: Colors.white,
                  ),
                  margin: EdgeInsets.only(
                      top: fit.t(30.0), left: fit.t(10.0), right: fit.t(10.0)),
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(fit.t(4.0)),
                              topRight: Radius.circular(fit.t(4.0))),
                          color: btnAppColor,
                        ),
                        height: fit.t(50.0),
                        child: Center(
                          child: widget.icon == null
                              ? Icon(
                                  Icons.check,
                                  color: Colors.white,
                                  size: fit.t(25.0),
                                )
                              : Image.asset(
                                  widget.icon,
                                  color: colorWhite,
                                  height: fit.t(20.0),
                                  width: fit.t(20.0),
                                ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(fit.t(4.0)),
                              bottomRight: Radius.circular(fit.t(4.0))),
                          color: Colors.white,
                        ),
                        child: Column(
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.only(
                                  left: fit.t(10.0),
                                  right: fit.t(10.0),
                                  top: fit.t(15.0),
                                  bottom: fit.t(10.0)),
                              child: RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                  text: AppLocalizations.of(context)
                                      .translate("great_work"),
                                  style: TextStyle(
                                      fontSize: fit.t(8.0),
                                      color: Color(0xFF96989d),
                                      fontFamily: robotoMediumFont,
                                      fontWeight: FontWeight.w600),
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: '\n${widget.title}.',
                                      style: TextStyle(
                                          color: appColor,
                                          fontSize: fit.t(8.0),
                                          fontFamily: regularFont,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(fit.t(5.0)),
                              child: Text(
                                AppLocalizations.of(context)
                                    .translate("give_rating"),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontFamily: robotoBoldCondenseFont,
                                    fontSize: fit.t(20.0),
                                    color: colorGrey,
                                    fontWeight: FontWeight.w400),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: fit.t(5.0)),
                              height: fit.t(40.0),
                              width: fit.t(40.0),
                              decoration: new BoxDecoration(
                                color: color,
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  '$ratingText',
                                  style: TextStyle(
                                      fontSize: fit.t(16.0),
                                      fontWeight: FontWeight.w500,
                                      fontFamily: robotoMediumFont,
                                      color: Colors.white),
                                ),
                              ),
                            ),
                            Column(
                              children: <Widget>[
                                Container(
                                  margin: EdgeInsets.only(
                                      bottom: fit.t(5.0), top: fit.t(5.0)),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: fit.t(20.0),
                                      vertical: fit.t(5.0)),
                                  width: fit.t(240),
                                  child: Material(
                                    color: Colors.transparent,
                                    elevation: 0.0,
                                    type: MaterialType.canvas,
                                    shadowColor: colorWhite,
                                    child: SeekBar(
                                      onValueChanged: onchangeValue,
                                      value: ratingValue,
                                      progressColor: color,
                                      indicatorRadius: fit.t(10.0),
                                      backgroundColor: Color(0x9096989d),
                                      bubbleRadius: fit.t(16.0),
                                      isRound: true,
                                      max: 10,
                                      min: 1,
                                      progresseight: fit.t(5.0),
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(bottom: fit.t(10.0)),
                                  child: Text(
                                    '$ratingRemark',
                                    style: TextStyle(
                                      fontSize: 12.0,
                                      fontFamily: robotoBoldFont,
                                      fontWeight: FontWeight.w500,
                                      color: color,
                                    ),
                                  ),
                                )
                              ],
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                  bottom: fit.t(10.0), top: fit.t(10.0)),
                              child: Text(
                                AppLocalizations.of(context)
                                    .translate("need_work_text"),
                                style: TextStyle(
                                    fontSize: fit.t(16.0),
                                    fontFamily: regularFont,
                                    color: colorGrey,
                                    fontWeight: FontWeight.w400),
                              ),
                            ),
                            GestureDetector(
                              onTap: () => widget.okBtnFunction(ratingValue),
                              child: Container(
                                margin: EdgeInsets.symmetric(
                                    horizontal: fit.t(24.0)),
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.circular(fit.t(24.0)),
                                    color: Color(0xFF96989d)),
                                height: fit.t(35.0),
                                child: Center(
                                  child: Container(
                                    padding: EdgeInsets.only(
                                        top: fit.t(4.0), bottom: fit.t(4.0)),
                                    child: Text(widget.okBtnText,
                                        style: TextStyle(
                                            fontSize: fit.t(10.0),
                                            fontFamily: robotoBoldFont,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600)),
                                  ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () =>
                                  widget.cancelBtnFunction(ratingValue),
                              child: Container(
                                margin: EdgeInsets.only(
                                    left: fit.t(24.0),
                                    right: fit.t(24.0),
                                    bottom: fit.t(24.0),
                                    top: fit.t(8.0)),
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.circular(fit.t(24.0)),
                                  color: btnAppColor,
                                ),
                                height: fit.t(35.0),
                                child: Center(
                                  child: Container(
                                    padding: EdgeInsets.only(
                                        top: fit.t(4.0), bottom: fit.t(4.0)),
                                    child: Text(widget.cancelBtnText,
                                        style: TextStyle(
                                            fontSize: fit.t(10.0),
                                            fontFamily: robotoBoldFont,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600)),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
            Positioned(
              right: 0,
              top: fit.t(55.0),
              child: GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                  height: fit.t(30.0),
                  width: fit.t(30.0),
                  child: Icon(
                    Icons.close,
                    color: appColor,
                    size: fit.t(15.0),
                  ),
                  decoration:
                      BoxDecoration(shape: BoxShape.circle, color: colorWhite),
                ),
              ),
            ),
          ],
        ));
  }

  onchangeValue(ProgressValue value) {
    setState(() {
      if (value.value != null) {
        ratingValue = value.value;
        ratingText = value.value.toInt().toString();
        _getRatingColorText(ratingValue.toInt());
      }
    });
  }

  void _getRatingColorText(int ratingValue) {
    if (ratingValue > 0 && ratingValue < 3) {
      ratingRemark = AppLocalizations.of(context).translate("very_easy");
      color = Color(0xcc0A4E93);
    } else if (ratingValue >= 3 && ratingValue < 5) {
      ratingRemark = AppLocalizations.of(context).translate("easy_label");
      color = Color(0xFF0A4E93);
    } else if (ratingValue >= 5 && ratingValue < 7) {
      ratingRemark = AppLocalizations.of(context).translate("avg_label");
      color = Color(0xFF7a2d57);
    } else if (ratingValue >= 7 && ratingValue < 9) {
      ratingRemark = AppLocalizations.of(context).translate("difficult_label");
      color = Color(0xccd70020);
    } else {
      ratingRemark = AppLocalizations.of(context).translate("very_difficult");
      color = Color(0xFFd70020);
    }
  }
}
