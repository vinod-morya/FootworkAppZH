import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fm_fit/fm_fit.dart';
import 'package:footwork_chinese/constants/app_colors.dart';
import 'package:footwork_chinese/constants/app_constants.dart';
import 'package:footwork_chinese/constants/app_images_path.dart';
import 'package:footwork_chinese/custom_widget/custom_dilaog.dart';
import 'package:footwork_chinese/custom_widget/custom_progress_loader.dart';
import 'package:footwork_chinese/custom_widget/top_alert.dart';
import 'package:footwork_chinese/model/commonReponse/commonResponse.dart';
import 'package:footwork_chinese/model/loginResponse/LoginResponseModel.dart';
import 'package:footwork_chinese/network/ApiConfiguration.dart';
import 'package:footwork_chinese/network/ApiUrls.dart';
import 'package:footwork_chinese/ui/settings/WebViewSupport.dart';
import 'package:footwork_chinese/ui/settings/changePassword/ChangePassword.dart';
import 'package:footwork_chinese/utils/DialogUtils.dart';
import 'package:footwork_chinese/utils/Utility.dart';
import 'package:footwork_chinese/utils/app_localizations.dart';

class SettingsView extends StatefulWidget {
  @override
  _SettingsViewState createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  var _blankFocusNode = FocusNode();
  var isSwitched = true;
  var lang = '';
  UserBean userDataModel;
  FmFit fit = FmFit(width: 750);
  bool isShowProgress = false;

  @override
  void initState() {
    getStringDataLocally(key: userData).then((onUserModel) {
      userDataModel = UserBean.fromJson(jsonDecode(onUserModel));
      if (userDataModel.notificationStatus != null &&
          userDataModel.notificationStatus.isNotEmpty) {
        isSwitched = userDataModel.notificationStatus == "1" ? true : false;
        if (mounted) setState(() {});
      } else {
        if (mounted)
          setState(() {
            isSwitched = false;
          });
      }
    });
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
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
    checkLanguage(context).then((onValue) {
      lang = onValue;
    });
    return Container(
      color: Color(0xFFebebec),
      child: Stack(
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            color: Colors.transparent,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: fit.t(4.0), bottom: fit.t(4.0)),
                  padding:
                      EdgeInsets.only(left: fit.t(8.0), right: fit.t(12.0)),
                  child: ListTile(
                    onTap: () => _onInviteUser(context),
                    leading: Image.asset(
                      ic_invite_user,
                      height: fit.t(25.0),
                      width: fit.t(25.0),
                      color: appColor,
                    ),
                    title: Padding(
                      padding: EdgeInsets.only(left: fit.t(8.0)),
                      child: Text(
                        AppLocalizations.of(context).translate("invite_user"),
                        style: TextStyle(
                          color: appColor,
                          fontFamily: robotoMediumFont,
                          fontSize: fit.t(16.0),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
                Divider(
                  height: fit.t(0.5),
                  endIndent: fit.t(20.0),
                  indent: fit.t(20.0),
                  color: appColor,
                ),
                Container(
                  margin: EdgeInsets.only(top: fit.t(4.0), bottom: fit.t(4.0)),
                  padding: EdgeInsets.only(left: fit.t(6.0)),
                  child: ListTile(
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ChangePassword())),
                    leading: Image.asset(
                      ic_password,
                      height: fit.t(35.0),
                      width: fit.t(30.0),
                      color: appColor,
                    ),
                    title: Padding(
                      padding: EdgeInsets.only(left: fit.t(2.0)),
                      child: Text(
                        AppLocalizations.of(context)
                            .translate("change_password"),
                        style: TextStyle(
                          color: appColor,
                          fontFamily: robotoMediumFont,
                          fontSize: fit.t(16.0),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
                Divider(
                  height: fit.t(0.5),
                  endIndent: fit.t(20.0),
                  indent: fit.t(20.0),
                  color: appColor,
                ),
                Container(
                  margin: EdgeInsets.only(top: fit.t(4.0), bottom: fit.t(4.0)),
                  padding: EdgeInsets.only(left: fit.t(4.0)),
                  child: ListTile(
                    leading: Image.asset(
                      ic_notification,
                      height: fit.t(35.0),
                      width: fit.t(30.0),
                      color: appColor,
                    ),
                    title: Padding(
                      padding: EdgeInsets.only(left: fit.t(4.0)),
                      child: Text(
                        AppLocalizations.of(context).translate("notification"),
                        style: TextStyle(
                          color: appColor,
                          fontFamily: robotoMediumFont,
                          fontSize: fit.t(16.0),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    trailing: Platform.isAndroid
                        ? Switch(
                            value: isSwitched,
                            onChanged: (value) {
                              setState(() {
                                isSwitched = value;
                                if (value) {
                                  _callApiNotificationStatus(value);
                                } else {
                                  _showDialogNotification(value);
                                }
                              });
                            },
                            activeTrackColor: Color(0x40D50A30),
                            activeColor: appColor,
                          )
                        : CupertinoSwitch(
                            value: isSwitched,
                            onChanged: (value) {
                              setState(() {
                                isSwitched = value;
                                if (value) {
                                  _callApiNotificationStatus(value);
                                } else {
                                  _showDialogNotification(value);
                                }
                              });
                            },
                            trackColor: Color(0x40D50A30),
                            activeColor: appColor,
                          ),
                  ),
                ),
                Divider(
                  height: fit.t(0.5),
                  endIndent: fit.t(20.0),
                  indent: fit.t(20.0),
                  color: appColor,
                ),
                Container(
                  margin: EdgeInsets.only(top: fit.t(4.0), bottom: fit.t(4.0)),
                  padding: EdgeInsets.only(left: fit.t(4.0)),
                  child: ListTile(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (BuildContext context) => WebViewSupport()));
                    },
                    leading: Padding(
                      padding: EdgeInsets.only(left: fit.t(4.0)),
                      child: Icon(
                        Icons.contact_mail,
                        size: fit.t(30.0),
                        color: appColor,
                      ),
                    ),
                    title: Padding(
                      padding: EdgeInsets.only(left: fit.t(0.0)),
                      child: Text(
                        AppLocalizations.of(context).translate("contact_us"),
                        style: TextStyle(
                          color: appColor,
                          fontFamily: robotoMediumFont,
                          fontSize: fit.t(16.0),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
                Divider(
                  height: fit.t(0.5),
                  endIndent: fit.t(20.0),
                  indent: fit.t(20.0),
                  color: appColor,
                ),
                Container(
                  margin: EdgeInsets.only(top: fit.t(4.0), bottom: fit.t(4.0)),
                  padding: EdgeInsets.only(left: fit.t(4.0)),
                  child: ListTile(
                    onTap: () {
                      DialogUtils.showCustomDialog(context,
                          fit: fit,
                          okBtnText:
                              AppLocalizations.of(context).translate("ok"),
                          cancelBtnText:
                              AppLocalizations.of(context).translate("cancel"),
                          title: '',
                          content: AppLocalizations.of(context)
                              .translate("sure_to_logout"),
                          okBtnFunction: _onLogout);
                    },
                    leading: Padding(
                      padding: EdgeInsets.only(left: fit.t(4.0)),
                      child: Image.asset(
                        ic_logout,
                        height: fit.t(35.0),
                        width: fit.t(30.0),
                        color: appColor,
                      ),
                    ),
                    title: Padding(
                      padding: EdgeInsets.only(left: fit.t(0.0)),
                      child: Text(
                        AppLocalizations.of(context).translate("logout"),
                        style: TextStyle(
                          color: appColor,
                          fontFamily: robotoMediumFont,
                          fontSize: fit.t(16.0),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
                Divider(
                  height: fit.t(0.5),
                  endIndent: fit.t(20.0),
                  indent: fit.t(20.0),
                  color: appColor,
                ),
              ],
            ),
          ),
          ProgressLoader(
            fit: fit,
            isShowLoader: isShowProgress,
            color: appColor,
          ),
        ],
      ),
    );
  }

  _onchangeLanguage(BuildContext context) {
    DialogUtils.showCustomDialog(context,
        fit: fit,
        okBtnText: AppLocalizations.of(context).translate("yes"),
        cancelBtnText: AppLocalizations.of(context).translate("no"),
        title: '',
        content: lang == 'en'
            ? 'Are you sure you want to change language from English to Chinese?'
            : '您确定要将语言从中文更改为英语吗？', okBtnFunction: () {
      String data = lang == 'en' ? 'zh' : 'en';
      writeStringDataLocally(key: language, value: data);
      AppLocalizations(Locale(data));
      AppLocalizations.of(context).load();
      Navigator.of(context).pop();
      setState(() {});
    });
  }

  _onInviteUser(BuildContext context) {
    showDialogInviteUser(context,
        okBtnFunction: (email) => _callApiInviteUser(email),
        inviteText: AppLocalizations.of(context).translate('invite_label'),
        okBtnText: AppLocalizations.of(context).translate('invite_user_text'));
  }

  void _callApiInviteUser(String email) async {
    FocusScope.of(context).requestFocus(_blankFocusNode);
    if (validateEmail(email, context) != null) {
      TopAlert.showAlert(context, validateEmail(email, context), true);
    } else {
      if (mounted) {
        setState(() {
          isShowProgress = true;
        });
      }
      Navigator.of(context).pop();
      var language = await checkLanguage(context);
      getStringDataLocally(key: cookie).then((onCookie) {
        Map<String, dynamic> data = Map();
        data.putIfAbsent('cookie', () => onCookie);
        data.putIfAbsent('lang', () => language == null ? "en" : language);
        data.putIfAbsent('email', () => email);
        var url = '$baseUrl$apiInviteUser';
        if (!baseUrl.contains('https://')) {
          data.putIfAbsent('insecure', () => "cool");
        }
        try {
          ApiConfiguration.getInstance()
              .apiClient
              .liveService
              .apiMultipartRequest(context, '$url', data, 'POST')
              .then((response) {
            try {
              Map map = jsonDecode(response.body);
              if (mounted)
                setState(() {
                  isShowProgress = false;
                });
              if (map['status'] == 200) {
                CommonResponse data = CommonResponse.fromJson(map);
                TopAlert.showAlert(
                    context,
                    data.message != null
                        ? data.message
                        : data.msg != null
                            ? data.msg
                            : AppLocalizations.of(context)
                                .translate("something_went_wrong"),
                    false);
              }
            } on Exception catch (error) {
              if (mounted)
                setState(() {
                  isShowProgress = false;
                });
              TopAlert.showAlert(
                  context,
                  AppLocalizations.of(context)
                      .translate("something_went_wrong"),
                  true);
            }
          });
        } catch (error) {
          if (mounted)
            setState(() {
              isShowProgress = false;
            });
          if (error != null) {
            TopAlert.showAlert(context, error, true);
          } else {
            TopAlert.showAlert(
                context,
                AppLocalizations.of(context).translate("something_went_wrong"),
                true);
          }
        }
      });
    }
  }

  void _onLogout() async {
    if (mounted) {
      setState(() {
        isShowProgress = true;
      });
    }
    Navigator.of(context).pop();
    var language = await checkLanguage(context);
    getStringDataLocally(key: cookie).then((onCookie) {
      Map<String, dynamic> data = Map();
      data.putIfAbsent('cookie', () => onCookie);
      data.putIfAbsent('lang', () => language == null ? "en" : language);
      var url = '$baseUrl$apiLogout';
      if (!baseUrl.contains('https://')) {
        data.putIfAbsent('insecure', () => "cool");
      }
      try {
        ApiConfiguration.getInstance()
            .apiClient
            .liveService
            .apiMultipartRequest(context, '$url', data, 'POST')
            .then((response) {
          clearDataLocally();
          Navigator.pushNamedAndRemoveUntil(
              context, '/login', ModalRoute.withName('/'));
        });
      } catch (error) {
        clearDataLocally();
        Navigator.pushNamedAndRemoveUntil(
            context, '/login', ModalRoute.withName('/'));
      }
    });
  }

  String validateEmail(String value, context) {
    if (value.isEmpty)
      return AppLocalizations.of(context).translate("email_empty");
    final RegExp nameExp = new RegExp(
        r'^([A-Za-z0-9+_\-\.])+\@([A-Za-z0-9_\-\.])+\.([A-Za-z]{2,63})$');
    if (!nameExp.hasMatch(value))
      return AppLocalizations.of(context).translate("email_invalid");
    return null;
  }

  void _showDialogNotification(bool value) {
    DialogUtils.showCustomDialogNotification(context,
        fit: fit,
        okBtnText: AppLocalizations.of(context).translate("yes"),
        cancelBtnText: AppLocalizations.of(context).translate("no"),
        icon: ic_notification,
        cancelBtnFunction: () {
          setState(() {
            isSwitched = true;
          });
          Navigator.of(context).pop();
        },
        title: '',
        content:
            AppLocalizations.of(context).translate("sure_disable_notification"),
        okBtnFunction: () {
          _callApiNotificationStatus(value);
          Navigator.of(context).pop();
        });
  }

  _callApiNotificationStatus(bool value) async {
    if (mounted) {
      setState(() {
        isShowProgress = true;
      });
    }
    var language = await checkLanguage(context);
    getStringDataLocally(key: cookie).then((onCookie) {
      Map<String, dynamic> data = Map();
      data.putIfAbsent('cookie', () => onCookie);
      data.putIfAbsent('status', () => value ? "1" : "0");
      data.putIfAbsent('lang', () => language == null ? "en" : language);
      var url = '$baseUrl$notificationApi';
      if (!baseUrl.contains('https://')) {
        data.putIfAbsent('insecure', () => "cool");
      }
      try {
        ApiConfiguration.getInstance()
            .apiClient
            .liveService
            .apiMultipartRequest(context, '$url', data, 'POST')
            .then((response) {
          try {
            Map map = jsonDecode(response.body);
            if (mounted)
              setState(() {
                isShowProgress = false;
              });
            if (map['status'] == 200) {
              userDataModel.notificationStatus = value ? "1" : "0";
              writeStringDataLocally(
                  key: userData, value: jsonEncode(userDataModel));
              CommonResponse data = CommonResponse.fromJson(map);
              TopAlert.showAlert(
                  context,
                  data.message != null
                      ? data.message
                      : data.msg != null
                          ? data.msg
                          : AppLocalizations.of(context)
                              .translate("something_went_wrong"),
                  false);
            }
          } on Exception catch (error) {
            if (mounted)
              setState(() {
                isShowProgress = false;
              });
            TopAlert.showAlert(
                context,
                AppLocalizations.of(context).translate("something_went_wrong"),
                true);
          }
        });
      } catch (error) {
        if (mounted)
          setState(() {
            isShowProgress = false;
          });
        if (error != null) {
          TopAlert.showAlert(context, error, true);
        } else {
          TopAlert.showAlert(
              context,
              AppLocalizations.of(context).translate("something_went_wrong"),
              true);
        }
      }
    });
  }
}
