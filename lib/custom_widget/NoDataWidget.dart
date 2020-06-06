import 'package:flutter/material.dart';
import 'package:fm_fit/fm_fit.dart';

import '../constants/app_colors.dart';
import '../constants/app_constants.dart';
import '../constants/app_images_path.dart';

class NoDataWidget extends StatelessWidget {
  final String txt;
  final FmFit fit;
  final String url;

  const NoDataWidget({Key key, this.txt, this.fit, this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: fit.t(30.0), bottom: fit.t(20.0)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
                text: txt == '' ? '' : '$txt\n',
                style: TextStyle(
                  fontSize: url != null ? fit.t(12.0) : fit.t(9.0),
                  color: Color(0xFFA7A9AC),
                  fontFamily: regularFont,
                  fontWeight: FontWeight.normal,
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: url != null ? url : '',
                    style: TextStyle(
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.bold,
                        fontFamily: robotoBoldFont,
                        color: colorRed,
                        decoration: TextDecoration.underline,
                        fontSize: url != null ? fit.t(12.0) : fit.t(9.0)),
                  )
                ]),
          ),
          Center(
            child: Container(
              margin:
                  EdgeInsets.only(top: url != null ? fit.t(20.0) : fit.t(0.0)),
              child: Image.asset(
                ic_app_icon,
                scale: fit.scale == 1 ? 3.0 : 2.0,
                color: Colors.grey,
              ),
            ),
          )
        ],
      ),
    );
  }
}
