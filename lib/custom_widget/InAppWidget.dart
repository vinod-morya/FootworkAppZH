import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fm_fit/fm_fit.dart';
import 'package:footwork_chinese/constants/app_colors.dart';
import 'package:footwork_chinese/constants/app_constants.dart';
import 'package:footwork_chinese/constants/app_images_path.dart';
import 'package:footwork_chinese/ui/login/WebViewTermsPrivacy.dart';
import 'package:footwork_chinese/utils/app_localizations.dart';

class InAppWidget extends StatefulWidget {
  final title;
  final body;
  final yearlyBtnText;
  final yearlyBtnFunction;
  final restoreBtnFunction;

  InAppWidget(this.body, this.title, this.yearlyBtnText, this.yearlyBtnFunction,
      this.restoreBtnFunction);

  @override
  _InAppWidgetState createState() => _InAppWidgetState();
}

class _InAppWidgetState extends State<InAppWidget> {
  Color color = Color(0xccE4A244);
  FmFit fit = FmFit(width: 750);

  @override
  void initState() {
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
    return Container(
        padding: EdgeInsets.symmetric(
            horizontal: fit.t(20.0), vertical: fit.t(60.0)),
        width: fit.t(MediaQuery.of(context).size.width),
        height: fit.t(MediaQuery.of(context).size.height),
        margin: EdgeInsets.only(top: fit.t(10.0)),
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
                      top: fit.t(20.0), left: fit.t(10.0), right: fit.t(10.0)),
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
                          child: Icon(
                            Icons.check,
                            color: Colors.white,
                            size: fit.t(25.0),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(fit.t(4.0)),
                        bottomRight: Radius.circular(fit.t(4.0))),
                    color: Colors.white,
                  ),
                  margin: EdgeInsets.only(
                      top: fit.t(0.0), left: fit.t(10.0), right: fit.t(10.0)),
                  child: Column(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(
                            left: fit.t(20.0),
                            right: fit.t(20.0),
                            top: fit.t(10.0),
                            bottom: fit.t(5.0)),
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            text: '${widget.title}',
                            style: TextStyle(
                                color: appColor,
                                fontSize: fit.t(15.0),
                                fontFamily: regularFont,
                                fontWeight: FontWeight.w800),
                            children: <TextSpan>[
                              TextSpan(
                                text:
                                '\n\n米卡·兰开斯特（Micah Lancaster）的“检查表”方法使您每个月都能进行4次篮球脚训练任务，使猜测工作变得无所适从。\n\n订阅类型\n',
                                style: TextStyle(
                                    color: colorGrey,
                                    fontSize: fit.t(10.0),
                                    fontFamily: regularFont,
                                    fontWeight: FontWeight.w600),
                              ),
                              TextSpan(
                                text: '${widget.body}',
                                style: TextStyle(
                                    color: appColor,
                                    fontSize: fit.t(11.0),
                                    fontFamily: regularFont,
                                    fontWeight: FontWeight.w600),
                              ),
                              TextSpan(
                                text:
                                '\n\n 购买确认后，每年会向您的iTunes帐户收取298日元，除非在本期结束前至少24小时关闭自动更新功能，否则它将自动更新。',
                                style: TextStyle(
                                    color: colorGrey,
                                    fontSize: fit.t(11.0),
                                    fontFamily: regularFont,
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => widget.yearlyBtnFunction(),
                        child: Container(
                          margin: EdgeInsets.only(
                              left: fit.t(24.0),
                              right: fit.t(24.0),
                              bottom: fit.t(10.0),
                              top: fit.t(8.0)),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(fit.t(24.0)),
                            color: btnAppColor,
                          ),
                          height: fit.t(35.0),
                          child: Center(
                            child: Container(
                              padding: EdgeInsets.only(
                                  top: fit.t(4.0), bottom: fit.t(4.0)),
                              child: Text('购买 ' + widget.yearlyBtnText,
                                  style: TextStyle(
                                      fontSize: fit.t(20.0),
                                      fontFamily: robotoBoldFont,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600)),
                            ),
                          ),
                        ),
                      ),
                      Platform.isAndroid ? Container() : GestureDetector(
                        onTap: () => widget.restoreBtnFunction(),
                        child: Container(
                          margin: EdgeInsets.only(
                              left: fit.t(24.0),
                              right: fit.t(24.0),
                              bottom: fit.t(8.0),
                              top: fit.t(0.0)),
                          height: fit.t(35.0),
                          child: Center(
                            child: Container(
                              padding: EdgeInsets.only(
                                  top: fit.t(4.0), bottom: fit.t(4.0)),
                              child: Text(
                                  AppLocalizations.of(context)
                                      .translate("restore"),
                                  style: TextStyle(
                                      fontSize: fit.t(16.0),
                                      fontFamily: robotoBoldFont,
                                      color: Colors.blue,
                                      fontWeight: FontWeight.w600)),
                            ),
                          ),
                        ),
                      ),
                      Platform.isAndroid ? Container() : Container(
                        margin: EdgeInsets.only(
                          top: fit.t(0.0),
                          bottom: fit.t(10.0),
                          left: fit.t(24.0),
                          right: fit.t(24.0),
                        ),
                        child: Text(
                            '订阅将自动续订，除非在当前期限结束前24小时内取消订阅。您可以随时使用iTunes帐户设置取消。如果您购买了订阅，则免费试用中任何未使用的部分将被没收.\n有关更多信息，请参见',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: fit.t(9.0),
                                fontFamily: robotoBoldFont,
                                color: colorGrey,
                                fontWeight: FontWeight.w600)),
                      ),
                      Container(
                        margin: EdgeInsets.only(
                            top: fit.t(10.0), bottom: fit.t(10.0)),
                        child: RichText(
                          softWrap: true,
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            text:
                            AppLocalizations.of(context).translate('terms'),
                            style: TextStyle(
                                fontFamily: robotoBoldFont,
                                color: appColor,
                                fontWeight: FontWeight.w500,
                                decoration: TextDecoration.underline,
                                fontSize: fit.t(15.0)),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            WebViewTermsPrivacy(
                                                url: '$TERMS_OF_USE',
                                                title: AppLocalizations.of(
                                                    context)
                                                    .translate('terms'))));
                              },
                            children: <TextSpan>[
                              TextSpan(
                                  text: ' | ',
                                  style: TextStyle(
                                      fontFamily: robotoBoldFont,
                                      color: colorBlack,
                                      decoration: TextDecoration.none,
                                      fontSize: fit.t(15.0))),
                              TextSpan(
                                text:
                                '${AppLocalizations.of(context).translate(
                                    'privacy')}',
                                style: TextStyle(
                                    fontFamily: robotoBoldFont,
                                    color: appColor,
                                    decoration: TextDecoration.underline,
                                    fontWeight: FontWeight.w500,
                                    fontSize: fit.t(15.0)),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                WebViewTermsPrivacy(
                                                    url: '$PRIVACY_USE',
                                                    title:
                                                    AppLocalizations.of(context)
                                                        .translate(
                                                        'privacy'))));
                                  },
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Positioned(
              right: 0,
              top: fit.t(50.0),
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

}
