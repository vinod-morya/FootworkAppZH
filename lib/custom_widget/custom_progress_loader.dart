import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fm_fit/fm_fit.dart';

class ProgressLoader extends StatelessWidget {
  final isShowLoader;
  final color;
  final FmFit fit;

  const ProgressLoader({Key key, this.isShowLoader, this.color, this.fit})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: isShowLoader
          ? AbsorbPointer(
              ignoringSemantics: true,
              child: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(color: Colors.transparent),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SpinKitThreeBounce(
                        color: color,
                        size: fit.t(30.0),
                      ),
                    ],
                  ),
                ),
              ),
            )
          : Container(),
    );
  }
}
