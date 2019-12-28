import 'package:flutter/material.dart';
import 'package:fm_fit/fm_fit.dart';
import 'package:footwork_chinese/constants/app_constants.dart';
import 'package:footwork_chinese/constants/app_images_path.dart';

class NoDataWidget extends StatelessWidget {
  final String txt;
  final FmFit fit;

  const NoDataWidget({Key key, this.txt, this.fit}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: fit.t(50.0), bottom: fit.t(20.0)),
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
                fontSize: fit.t(9.0),
                color: Color(0xFFA7A9AC),
                fontFamily: regularFont,
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
          Center(
            child: Image.asset(
              ic_app_icon,
              scale: fit.scale == 1 ? 3.0 : 2.0,
              color: Colors.grey,
            ),
          )
        ],
      ),
    );
  }
}
