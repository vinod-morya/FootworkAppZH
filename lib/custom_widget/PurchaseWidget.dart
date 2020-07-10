import 'package:flutter/material.dart';
import 'package:fm_fit/fm_fit.dart';
import 'package:footwork_chinese/constants/app_colors.dart';
import 'package:footwork_chinese/constants/app_constants.dart';
import 'package:footwork_chinese/constants/app_images_path.dart';
import 'package:url_launcher/url_launcher.dart';

class PurchaseWidget extends StatefulWidget {
  final title;
  final body;
  final aliPayBtnFunction;

  PurchaseWidget(this.body, this.title, this.aliPayBtnFunction);

  @override
  _PurchaseWidgetState createState() => _PurchaseWidgetState();
}

class _PurchaseWidgetState extends State<PurchaseWidget> {
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
            horizontal: fit.t(40.0), vertical: fit.t(40.0)),
        width: fit.t(MediaQuery.of(context).size.width),
        height: fit.t(MediaQuery.of(context).size.height),
        margin: EdgeInsets.only(top: fit.t(50.0)),
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
                            topRight: Radius.circular(fit.t(4.0)),
                          ),
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
                            top: fit.t(15.0),
                            bottom: fit.t(10.0)),
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
                                    '\n\nMicah Lancaster\'s Checklist approach allows you to experience 4 basketball foot training assignments every month, putting the guess work behind you.\n\n',
                                style: TextStyle(
                                    color: colorGrey,
                                    fontSize: fit.t(11.0),
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
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => widget.aliPayBtnFunction(),
                        child: Container(
                          margin: EdgeInsets.only(
                              left: fit.t(24.0),
                              right: fit.t(24.0),
                              bottom: fit.t(10.0),
                              top: fit.t(8.0)),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(fit.t(24.0)),
                              color: Color(0xFF96989d)),
                          height: fit.t(35.0),
                          child: Center(
                            child: Container(
                              padding: EdgeInsets.only(
                                  top: fit.t(4.0), bottom: fit.t(4.0)),
                              child: Text(
                                'Continue with AliPay',
                                style: TextStyle(
                                    fontSize: fit.t(24.0),
                                    fontFamily: robotoBoldFont,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                        ),
                      ),
//                      GestureDetector(
//                        onTap: () => widget.weChatPayBtnFunction(),
//                        child: Container(
//                          margin: EdgeInsets.only(
//                              left: fit.t(24.0),
//                              right: fit.t(24.0),
//                              bottom: fit.t(10.0),
//                              top: fit.t(8.0)),
//                          decoration: BoxDecoration(
//                            borderRadius: BorderRadius.circular(fit.t(24.0)),
//                            color: btnAppColor,
//                          ),
//                          height: fit.t(35.0),
//                          child: Center(
//                            child: Container(
//                              padding: EdgeInsets.only(
//                                  top: fit.t(4.0), bottom: fit.t(4.0)),
//                              child: Text('Buy with WeChatPay',
//                                  style: TextStyle(
//                                      fontSize: fit.t(20.0),
//                                      fontFamily: robotoBoldFont,
//                                      color: Colors.white,
//                                      fontWeight: FontWeight.w600)),
//                            ),
//                          ),
//                        ),
//                      ),
//                      Container(
//                        margin: EdgeInsets.only(
//                            top: fit.t(10.0), bottom: fit.t(10.0)),
//                        child: RichText(
//                          softWrap: true,
//                          textAlign: TextAlign.center,
//                          text: TextSpan(
//                            text:
//                                AppLocalizations.of(context).translate('terms'),
//                            style: TextStyle(
//                                fontFamily: robotoBoldFont,
//                                color: appColor,
//                                fontWeight: FontWeight.w500,
//                                decoration: TextDecoration.underline,
//                                fontSize: fit.t(15.0)),
//                            recognizer: TapGestureRecognizer()
//                              ..onTap = () {
//                                _launchUrl(
//                                    'https://micahlancaster.com/terms-conditions/');
//                              },
//                            children: <TextSpan>[
//                              TextSpan(
//                                  text: ' | ',
//                                  style: TextStyle(
//                                      fontFamily: robotoBoldFont,
//                                      color: colorBlack,
//                                      decoration: TextDecoration.none,
//                                      fontSize: fit.t(15.0))),
//                              TextSpan(
//                                text:
//                                    '${AppLocalizations.of(context).translate('privacy')}',
//                                style: TextStyle(
//                                    fontFamily: robotoBoldFont,
//                                    color: appColor,
//                                    decoration: TextDecoration.underline,
//                                    fontWeight: FontWeight.w500,
//                                    fontSize: fit.t(15.0)),
//                                recognizer: TapGestureRecognizer()
//                                  ..onTap = () {
//                                    _launchUrl(
//                                        'https://micahlancaster.com/privacy/');
//                                  },
//                              )
//                            ],
//                          ),
//                        ),
//                      ),
                    ],
                  ),
                ),
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

  _launchUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}