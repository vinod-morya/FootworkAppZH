import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fm_fit/fm_fit.dart';
import 'package:footwork_chinese/constants/app_colors.dart';
import 'package:footwork_chinese/constants/app_constants.dart';
import 'package:footwork_chinese/constants/app_images_path.dart';
import 'package:footwork_chinese/custom_widget/custom_dilaog.dart';
import 'package:footwork_chinese/database/data_base_helper.dart';
import 'package:footwork_chinese/model/loginResponse/LoginResponseModel.dart';
import 'package:footwork_chinese/ui/settings/changePassword/ChangePassword.dart';
import 'package:footwork_chinese/utils/DialogUtils.dart';
import 'package:footwork_chinese/utils/Utility.dart';
import 'package:footwork_chinese/utils/app_localizations.dart';

class SettingsView extends StatefulWidget {
  @override
  _SettingsViewState createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  var isSwitched = true;
  var db = DataBaseHelper();
  var userIdValue = "";
  var lang = '';
  UserBean userDataModel;
  FmFit fit = FmFit(width: 750);

  @override
  void initState() {
    getStringDataLocally(key: userData).then((onUserModel) {
      userDataModel = UserBean.fromJson(jsonDecode(onUserModel));
    });
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
    getStringDataLocally(key: userId).then((userIds) {
      userIdValue = userIds;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {});
    });
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
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Colors.transparent,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            userDataModel != null
                ? userDataModel.userRole == 2
                    ? Container(
                        margin: EdgeInsets.only(
                            top: fit.t(4.0), bottom: fit.t(4.0)),
                        padding: EdgeInsets.only(
                            left: fit.t(8.0), right: fit.t(12.0)),
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
                              AppLocalizations.of(context)
                                  .translate("invite_user"),
                              style: TextStyle(
                                color: appColor,
                                fontFamily: robotoMediumFont,
                                fontSize: fit.t(16.0),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      )
                    : Container()
                : Container(),
            userDataModel != null
                ? userDataModel.userRole == 2
                    ? Divider(
                        height: fit.t(0.5),
                        endIndent: fit.t(20.0),
                        indent: fit.t(20.0),
                        color: appColor,
                      )
                    : Container()
                : Container(),
            Container(
              margin: EdgeInsets.only(top: fit.t(4.0), bottom: fit.t(4.0)),
              padding: EdgeInsets.only(left: fit.t(6.0)),
              child: ListTile(
                onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => ChangePassword())),
                leading: Image.asset(
                  ic_password,
                  height: fit.t(35.0),
                  width: fit.t(30.0),
                  color: appColor,
                ),
                title: Padding(
                  padding: EdgeInsets.only(left: fit.t(2.0)),
                  child: Text(
                    AppLocalizations.of(context).translate("change_password"),
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
                trailing: Switch(
                  value: isSwitched,
                  onChanged: (value) {
                    setState(() {
                      isSwitched = value;
                    });
                  },
                  activeTrackColor: Color(0x40D50A30),
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
                  DialogUtils.showCustomDialog(context,
                      fit: fit,
                      okBtnText: AppLocalizations.of(context).translate("ok"),
                      cancelBtnText:
                          AppLocalizations.of(context).translate("cancel"),
                      title: '',
                      content: AppLocalizations.of(context)
                          .translate("sure_to_logout"), okBtnFunction: () {
//                    db.deleteUser(int.parse(userIdValue));
                    clearDataLocally();
                    Navigator.pushNamedAndRemoveUntil(
                        context, '/login', ModalRoute.withName('/'));
                  });
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

  void _callApiInviteUser(String email) {}
}
