import 'dart:ui';

import 'package:flutter/cupertino.dart';

class ColorsTheme {
  const ColorsTheme();

  static const Color loginGradientStart = const Color(0xFFD50A30);
  static const Color loginGradientEnd = const Color(0xFFD50A30);
  static const Color dashboardGradientStart = const Color(0xFFD50A30);
  static const Color imageGradientStart = const Color(0xFF000000);
  static const Color imageGradientEnd = const Color(0x50000000);
  static const Color dashboardGradientEnd = const Color(0xFFD50A30);

  static const dashBoardGradient = const LinearGradient(
    colors: const [loginGradientStart, loginGradientEnd],
    stops: const [0.0, 1.0],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
  static const background = const LinearGradient(
    colors: const [imageGradientEnd, imageGradientStart],
    stops: const [0.0, 1.0],
    begin: Alignment.center,
    end: Alignment.bottomCenter,
  );

  static const backgroundBlack = const LinearGradient(
    colors: const [imageGradientStart, imageGradientStart],
    stops: const [0.0, 1.0],
    begin: Alignment.center,
    end: Alignment.bottomCenter,
  );

  static const boardGradient = const LinearGradient(
    colors: const [dashboardGradientEnd, dashboardGradientStart],
    stops: const [0.0, 1.0],
    begin: Alignment.bottomCenter,
    end: Alignment.centerLeft,
  );
}
