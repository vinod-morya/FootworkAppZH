import 'package:flutter/material.dart';

//Fonts
const String robotoMediumFont = 'assets/fonts/roboto/Roboto-Medium.ttf';
const String regularFont = 'assets/fonts/roboto/Roboto-Regular.ttf';
const String robotoBoldFont = 'assets/fonts/roboto/Roboto-Bold.ttf';
const String robotoBoldCondenseFont =
    'assets/fonts/roboto/Roboto-BoldCondensed.ttf';

const passwordLength = 25;
const emailLength = 80;
const userNameLength = 40;
const phoneLength = 12;
const zipCodeLength = 12;
const splashDuration = 200;

//app gradient color
const Gradient gradientApp = LinearGradient(
  begin: FractionalOffset.bottomCenter,
  end: FractionalOffset.topCenter,
  colors: [
    Color(0xFFD50A30),
    Color(0xFFD50A30),
  ],
  tileMode: TileMode.repeated,
);

//toolbar gradient color
const Gradient gradientAppToolBar = LinearGradient(colors: [
  Color(0xFFD50A30),
  Color(0xFFD50A30),
  Color(0xFFD50A30),
  Color(0xFFD50A30),
]);

//api constants
final String session = 'session';
final fcmToken = 'token';
final nativeDeviceId = 'deviceId';
final cookie = 'cookie';
final userData = 'user_data';
final String deviceToken = 'asdklasdlasndlkma';
final String userId = 'user_id';
final String password = 'user_password';
final String language = 'app_language';
final String countries = 'countries_list';
final String userName = 'userName';
final String dashBoardData = 'checklisr_dashboard_list';
final String historyCall = 'checklisr_history_call_time';
final String dashboardCall = 'checklisr_dash_call_time';
final String hitApiHistory = 'checklisr_history_api_call';
final String dashboardCallApi = 'checklisr_dashboardCallApi';
final String historyList = 'checklisr_history_list';

//api flags
const int NO_INTERNET_FLAG = 1000;
const int ERROR_EXCEPTION_FLAG = 1001;
const int LOGIN_FLAG = 1002;
const int REGISTER_FLAG = 1002;
const int FORGOT_FLAG = 1003;
const int UPDATE_PROFILE_FLAG = 1004;
const int CHANGE_PASS_FLAG = 1005;
const int DASHBOARD_API_FLAG = 1006;
const int VIDEO_LIST_API_FLAG = 1007;
const int VIDEO_STATUS_API_FLAG = 1008;
const int FAVOURITE_VIDEO_API_FLAG = 1009;
const int COUNTRY_LIST = 1010;
const int STATE_LIST = 1011;
const int CUSTOM_VIDEO_LIST = 1011;
