import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fm_fit/fm_fit.dart';
import 'package:footwork_chinese/constants/app_colors.dart';
import 'package:footwork_chinese/constants/app_constants.dart';
import 'package:footwork_chinese/constants/app_images_path.dart';
import 'package:footwork_chinese/custom_widget/DialogParentWidget.dart';

class DialogUtils {
  static DialogUtils _instance = new DialogUtils.internal();

  DialogUtils.internal();

  factory DialogUtils() => _instance;

  static void showCustomDialog(BuildContext context,
      {@required String title,
      String okBtnText = "Ok",
      @required FmFit fit,
      String cancelBtnText = "Cancel",
      String content,
      String icon,
      @required Function okBtnFunction,
      Function cancelBtnFunction}) {
    showDialog(
        context: context,
        barrierDismissible: false,
        child: Center(
          child: MyDialog(
            elevation: 0.0,
            backgroundColor: Colors.black54,
            child: Container(
                padding: EdgeInsets.symmetric(
                    horizontal: fit.t(40.0), vertical: fit.t(24.0)),
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.only(top: fit.t(100.0)),
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
                              top: fit.t(30.0),
                              left: fit.t(10.0),
                              right: fit.t(10.0)),
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
                                  child: icon == null
                                      ? Icon(
                                          Icons.check,
                                          color: Colors.white,
                                          size: fit.t(25.0),
                                        )
                                      : Image.asset(
                                          icon,
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
                                    title == ''
                                        ? Container()
                                        : Container(
                                            margin: EdgeInsets.symmetric(
                                                vertical: fit.t(8.0),horizontal:fit.t(1.0) ),
                                            child: Center(
                                              child: Text(
                                                title,
                                                style: TextStyle(
                                                    color: appColor,
                                                    fontFamily: robotoBoldFont,
                                                    fontSize: fit.t(12.0),
                                                    fontWeight:
                                                        FontWeight.w600),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          ),
                                    Container(
                                      height: fit.t(90),
                                      margin: EdgeInsets.symmetric(
                                          vertical: fit.t(8.0)),
                                      padding: EdgeInsets.all(fit.t(8.0)),
                                      child: Center(
                                        child: Text(
                                          content,
                                          style: TextStyle(
                                              fontFamily: robotoBoldFont,
                                              fontSize: fit.t(18.0)),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                    okBtnFunction != null
                                        ? GestureDetector(
                                            onTap: okBtnFunction,
                                            child: Container(
                                              margin: EdgeInsets.symmetric(
                                                  horizontal: fit.t(16.0)),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        fit.t(24.0)),
                                                color: btnAppColor,
                                              ),
                                              height: fit.t(35.0),
                                              child: Center(
                                                child: Container(
                                                  padding: EdgeInsets.only(
                                                      top: fit.t(4.0),
                                                      bottom: fit.t(4.0)),
                                                  child: Text(okBtnText,
                                                      style: TextStyle(
                                                          fontFamily:
                                                              robotoMediumFont,
                                                          color: Colors.white)),
                                                ),
                                              ),
                                            ),
                                          )
                                        : Container(),
                                    okBtnFunction != null
                                        ? GestureDetector(
                                            onTap: cancelBtnFunction == null
                                                ? () =>
                                                    Navigator.of(context).pop()
                                                : cancelBtnFunction,
                                            child: Container(
                                              margin: EdgeInsets.only(
                                                  left: fit.t(16.0),
                                                  right: fit.t(16.0),
                                                  bottom: fit.t(16.0),
                                                  top: fit.t(8.0)),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        fit.t(24.0)),
                                                color: Color(0xFF96989d),
                                              ),
                                              height: fit.t(35.0),
                                              child: Center(
                                                child: Container(
                                                  padding: EdgeInsets.only(
                                                      top: fit.t(4.0),
                                                      bottom: fit.t(4.0)),
                                                  child: Text(cancelBtnText,
                                                      style: TextStyle(
                                                          fontFamily:
                                                              robotoMediumFont,
                                                          color: Colors.white)),
                                                ),
                                              ),
                                            ),
                                          )
                                        : Container()
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
                          decoration: BoxDecoration(
                              shape: BoxShape.circle, color: colorWhite),
                        ),
                      ),
                    ),
                  ],
                )),
          ),
        ));
  }
}
