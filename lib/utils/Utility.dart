import 'dart:io';
import 'dart:math';

import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/app_constants.dart';
import '../custom_widget/top_alert.dart';
import '../utils/app_localizations.dart';

showSnackBar(String message, final scaffoldKey) {
  scaffoldKey.currentState.showSnackBar(new SnackBar(
    backgroundColor: Colors.red[600],
    content: new Text(
      message,
      style: new TextStyle(color: Colors.white),
    ),
  ));
}

showToast(String msgTxt, Color color) {
//  Fluttertoast.showToast(
//      msg: msgTxt,
//      toastLength: Toast.LENGTH_SHORT,
//      gravity: ToastGravity.TOP,
//      timeInSecForIos: 1,
//      backgroundColor: color,
//      textColor: Colors.white,
//      fontSize: 16.0);
}

onLogOutFromApplication(BuildContext context, [String isshow]) {
  try {
    checkInternetConnection().then((onValue) {
      !onValue
          ? TopAlert.showAlert(context,
              AppLocalizations.of(context).translate('check_internet'), true)
          : _apiCalllogout(context, isshow);
    });
  } catch (e) {
    print(e);
  }
}

_apiCalllogout(BuildContext context, String isshow) {
  try {
//    Map<String, dynamic> map = Map<String, dynamic>();
//    map.putIfAbsent('accesstoken', () => 'asdasf');
//    if (!baseUrl.contains('https://')) {
//      map.putIfAbsent('insecure', ()=>'cool');
//    }
//        .apiClient
//        .liveService
//        .apiPostRequest(context, '$baseUrl$apiLogout', map)
//        .then((response) {
//      clearDataLocally();
//      Navigator.pushNamedAndRemoveUntil(
//          context, '/preLogin', ModalRoute.withName('/'));
//      if (isshow == null) {
//        TopAlert.showAlert(
//            context, 'User Role has been changed please login again.', true);
//      } else {
//        TopAlert.showAlert(context, 'Logout successfully!', false);
//      }
//    });
  } catch (e) {
    print(e);
  }
}

closeAnyView(BuildContext context) async {
  Navigator.pop(context);
}

double round(double val, double places) {
  double mod = pow(10.0, places);
  return ((val * mod).round().toDouble() / mod);
}

List<TextInputFormatter> userNameMobileformatter() {
  List<TextInputFormatter> list = [];
  list.add(LengthLimitingTextInputFormatter(userNameLength));
  list.add(WhitelistingTextInputFormatter(RegExp("[a-zA-Z0-9]")));
  list.add(
      BlacklistingTextInputFormatter(RegExp('/^[^* | \ " : < > [ ] { } ` \ ( ) '
          ' ; @ . & \$]+\$/')));
  return list;
}

List<TextInputFormatter> mobileNumberFormatter() {
  List<TextInputFormatter> list = [];
  list.add(LengthLimitingTextInputFormatter(phoneLength));
  list.add(WhitelistingTextInputFormatter(RegExp("[0-9]")));
  list.add(
      BlacklistingTextInputFormatter(RegExp('/^[^* | \ " : < > [ ] { } ` \ ( ) '
          ' ; @ . & \$]+\$/')));
  return list;
}

List<TextInputFormatter> companyNameFormatter() {
  List<TextInputFormatter> list = [];
  list.add(LengthLimitingTextInputFormatter(userNameLength));
  list.add(WhitelistingTextInputFormatter(RegExp("[a-zA-Z0-9 ]")));
  list.add(
      BlacklistingTextInputFormatter(RegExp('/^[^* | \ " : < > [ ] { } ` \ ( ) '
          ' ; @ . & \$]+\$/')));
  return list;
}

double convertToTwoDecimalPlacesDigit(double value) {
  int decimals = 2;
  int fac = pow(10, decimals);
  double d = value;
  d = (d * fac).round() / fac;
  return d;
}

Future<SharedPreferences> saveLocal = SharedPreferences.getInstance();

writeStringDataLocally({String key, dynamic value}) async {
  final SharedPreferences localData = await saveLocal;
  localData.setString(key, value);
}

writeBoolDataLocally({String key, bool value}) async {
  final SharedPreferences localData = await saveLocal;
  localData.setBool(key, value);
}

getDataLocally({String key}) async {
  final SharedPreferences localData = await saveLocal;
  return localData.get(key);
}

Future<String> getStringDataLocally({String key}) async {
  final SharedPreferences localData = await saveLocal;
  return localData.getString(key);
}

getBoolDataLocally({String key}) async {
  final SharedPreferences localData = await saveLocal;
  return localData.getBool(key) == null ? false : localData.getBool(key);
}

clearDataLocally() async {
  final SharedPreferences localData = await saveLocal;
  localData.clear();
}

Future<String> getDeviceDetails() async {
  String identifier;
//  final DeviceInfoPlugin deviceInfoPlugin = new DeviceInfoPlugin();
//  try {
//    if (Platform.isAndroid) {
//      var build = await deviceInfoPlugin.androidInfo;
//      identifier = build.androidId;
//    } else if (Platform.isIOS) {
//      var data = await deviceInfoPlugin.iosInfo;
//      identifier = data.identifierForVendor; //UUID for iOS
//    }
//  } on Exception {}
  return identifier;
}

List<TextInputFormatter> nameformatter() {
  List<TextInputFormatter> list = [];
  int nameLength = 50;
  list.add(LengthLimitingTextInputFormatter(nameLength));
  list.add(WhitelistingTextInputFormatter(RegExp("[a-z A-Z 0-9]")));
  list.add(
    BlacklistingTextInputFormatter(
      RegExp('/^[^* | \ " : < > [ ] { } ` \ ( ) '
          ' ; @ . & \$]+\$/'),
    ),
  );
  return list;
}

Future<bool> checkInternetConnection() async {
  bool result = await DataConnectionChecker().hasConnection;
  if (result) {
    return true;
  } else {
    return false;
  }
}

checkInternetMessage(context) {
  TopAlert.showAlert(
      context, AppLocalizations.of(context).translate('check_internet'), true);
}

String getDeviceType() {
  if (Platform.isAndroid)
    return '1';
  else if (Platform.isIOS)
    return '2';
  else
    return '3';
}

Future<String> checkLanguage(context) async {
//  String lang = await getStringDataLocally(key: language);
//  if (((lang == null || lang.isEmpty))) {
//    if (AppLocalizations.of(context).locale.languageCode == 'zh') {
//      return "zh";
//    } else if (AppLocalizations.of(context).locale.languageCode == 'tr') {
//      return "tr";
//    } else if (AppLocalizations.of(context).locale.languageCode == 'fr') {
//      return "fr";
//    } else {
//    }
  return "zh";
//  } else {
//    return lang;
//  }
}

String convertMilliToDate(int date, String format) {
  var _date = new DateTime.fromMillisecondsSinceEpoch(date);

  var timeFormatter = new DateFormat(format);
  return timeFormatter.format(_date);
}
