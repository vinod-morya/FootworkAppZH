import 'package:flutter/material.dart';

//Fonts
const String robotoMediumFont = 'assets/fonts/roboto/Roboto-Medium.ttf';
const String regularFont = 'assets/fonts/roboto/Roboto-Regular.ttf';
const String robotoBoldFont = 'assets/fonts/roboto/Roboto-Bold.ttf';
const String robotoBoldCondenseFont =
    'assets/fonts/roboto/Roboto-BoldCondensed.ttf';
const String CONTACT_US = "http://www.nbafootwork.cn/contact-us-app/";
const String SIGN_UP_CONTACT = "http://www.nbafootwork.cn/contact-us/";
const String TERMS_OF_USE = "http://www.nbafootwork.cn/terms-conditions/";
const String PRIVACY_USE = "http://www.nbafootwork.cn/privacy/";
const String returnUrl = "stripesdk://footwork.stripesdk.mlxt.us";
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
final String session = 'ft_zh_session';
final nativeDeviceId = 'ft_zh_deviceId';
final cookie = 'ft_zh_cookie';
final userData = 'ft_zh_user_data';
final String deviceToken = 'ft_zh_asdklasdlasndlkma';
final String userId = 'ft_zh_user_id';
final String password = 'ft_zh_user_password';
final String language = 'ft_zh_app_language';
final String countries = 'ft_zh_countries_list';
final String userName = 'ft_zh_userName';
final String dashBoardData = 'ft_zh_dashboard_list';
final String historyCall = 'ft_zh_history_call_time';
final String dashboardCall = 'ft_zh_dash_call_time';
final String hitApiHistory = 'ft_zh_history_api_call';
final String dashboardCallApi = 'ft_zh_dashboardCallApi';
final String historyList = 'ft_zh_history_list';
final String videoThumbnail = 'ft_zh_videoT';
final String videoURl = 'ft_zh_videoURl';

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
const int CUSTOM_VIDEO_LIST = 1012;
const int UPDATE_PAYMENT = 1014;
const int MAIN_DASHBOARD = 1015;
const int SAVE_INSTA_URL = 1016;
