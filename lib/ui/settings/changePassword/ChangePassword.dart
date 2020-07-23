import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fm_fit/fm_fit.dart';
import 'package:footwork_chinese/constants/app_colors.dart';
import 'package:footwork_chinese/constants/app_constants.dart';
import 'package:footwork_chinese/constants/app_images_path.dart';
import 'package:footwork_chinese/custom_widget/custom_progress_loader.dart';
import 'package:footwork_chinese/custom_widget/top_alert.dart';
import 'package:footwork_chinese/model/commonReponse/commonResponse.dart';
import 'package:footwork_chinese/model/errorResponse/customeError.dart';
import 'package:footwork_chinese/model/errorResponse/error_reponse.dart';
import 'package:footwork_chinese/model/loginResponse/LoginResponseModel.dart';
import 'package:footwork_chinese/network/ApiConfiguration.dart';
import 'package:footwork_chinese/network/ApiUrls.dart';
import 'package:footwork_chinese/style/theme.dart';
import 'package:footwork_chinese/utils/Utility.dart';
import 'package:footwork_chinese/utils/app_localizations.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';

import 'changePassBloc/ChangePasswordBloc.dart';

class ChangePassword extends StatefulWidget {
  ChangePassword({
    Key key,
  });

  @override
  ChangePasswordState createState() => new ChangePasswordState();
}

class ChangePasswordState extends State<ChangePassword> {
  UserBean userDataModel;
  var _scaffoldKey = GlobalKey<ScaffoldState>();
  var _blankFocusNode = FocusNode();
  var _newFocusNode = FocusNode();
  var _confirmFocusNode = FocusNode();

  var oldPassController = TextEditingController();
  var newPasswordController = TextEditingController();
  var confirmPasswordController = TextEditingController();
  var oldPass = '';
  StreamController apiResponseController;
  ChangePasswordBloc bloc;
  bool isHideOld = true;
  bool isHideNew = true;
  bool isHideConfirm = true;

  String cookies;

  FmFit fit = FmFit(width: 750);

  @override
  void initState() {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
    getStringDataLocally(key: userData).then((onUserModel) {
      userDataModel = UserBean.fromJson(jsonDecode(onUserModel));
    });
    getStringDataLocally(key: password).then((oldPassword) {
      oldPass = oldPassword;
    });
    apiResponseController = StreamController();
    _subscribeToApiResponse();
    bloc = ChangePasswordBloc(apiResponseController);
    getStringDataLocally(key: cookie).then((receivedCookie) {
      cookies = receivedCookie;
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
    return Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomPadding: true,
        appBar: _gradientAppBarWidget(),
        body: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            FocusScope.of(context).requestFocus(_blankFocusNode);
          },
          child: _mainWidget(),
        ));
  }

  Widget _gradientAppBarWidget() {
    return GradientAppBar(
      gradient: ColorsTheme.dashBoardGradient,
      centerTitle: true,
      title: Text(AppLocalizations.of(context).translate("change_password")),
      actions: <Widget>[
        InkWell(
          onTap: () => callApiChangePassword(),
          child: Padding(
            padding: EdgeInsets.all(fit.t(8.0)),
            child: Icon(
              Icons.check,
              color: Colors.white,
              size: fit.t(32.0),
            ),
          ),
        )
      ],
    );
  }

  Widget _mainWidget() {
    return Stack(
      children: <Widget>[
        SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.symmetric(
                vertical: fit.t(40.0), horizontal: fit.t(30.0)),
            child: _bodyWidget(),
          ),
        ),
        StreamBuilder<Object>(
            stream: bloc.progressLoaderStream,
            builder: (context, snapshot) {
              return ProgressLoader(
                fit: fit,
                isShowLoader: snapshot.hasData ? snapshot.data : false,
                color: appColor,
              );
            }),
      ],
    );
  }

  Widget _bodyWidget() {
    return Column(
      children: [
        _oldPasswordWidget(),
        SizedBox(height: fit.t(15.0)),
        _newPasswordWidget(),
        SizedBox(height: fit.t(15.0)),
        _confirmPassWidget(),
      ],
    );
  }

  Widget _oldPasswordWidget() {
    return StreamBuilder(
      stream: bloc.oldPassStream,
      builder: (context, snapshot) {
        return TextField(
          cursorColor: colorGrey,
          controller: oldPassController,
          keyboardAppearance: Brightness.light,
          style: _inputTextStyle(),
          textInputAction: TextInputAction.next,
          onEditingComplete: () =>
              FocusScope.of(context).requestFocus(_newFocusNode),
          obscureText: isHideOld,
          inputFormatters: [LengthLimitingTextInputFormatter(passwordLength)],
          decoration: InputDecoration(
            hintText: '',
            labelText: AppLocalizations.of(context).translate("old_pass_label"),
            suffixIcon: IconButton(
              icon: !isHideOld
                  ? Image.asset(
                      view_on,
                      height: fit.t(16.0),
                      width: fit.t(22.0),
                      color: colorGrey,
                    )
                  : Image.asset(
                      view_off,
                      height: fit.t(20.0),
                      width: fit.t(35.0),
                      color: colorGrey,
                    ),
              onPressed: () {
                isHideOld = !isHideOld;
                setState(() {});
              },
            ),
            hintStyle: TextStyle(color: colorGrey),
            labelStyle: TextStyle(color: colorGrey),
          ),
        );
      },
    );
  }

  Widget _newPasswordWidget() {
    return StreamBuilder(
      stream: bloc.newPasswordStream,
      builder: (context, snapshot) {
        return TextField(
          cursorColor: colorGrey,
          controller: newPasswordController,
          keyboardAppearance: Brightness.light,
          onChanged: null,
          style: _inputTextStyle(),
          focusNode: _newFocusNode,
          obscureText: isHideNew,
          onEditingComplete: () =>
              FocusScope.of(context).requestFocus(_confirmFocusNode),
          textInputAction: TextInputAction.next,
          inputFormatters: [LengthLimitingTextInputFormatter(passwordLength)],
          decoration: InputDecoration(
            hintText: '',
            labelText: AppLocalizations.of(context).translate("new_pass_label"),
            suffixIcon: IconButton(
              icon: !isHideNew
                  ? Image.asset(
                      view_on,
                      height: fit.t(16.0),
                      width: fit.t(22.0),
                      color: colorGrey,
                    )
                  : Image.asset(
                      view_off,
                      height: fit.t(20.0),
                      width: fit.t(35.0),
                      color: colorGrey,
                    ),
              onPressed: () {
                isHideNew = !isHideNew;
                setState(() {});
              },
            ),
            hintStyle: TextStyle(color: colorGrey),
            labelStyle: TextStyle(color: colorGrey),
          ),
        );
      },
    );
  }

  Widget _confirmPassWidget() {
    return StreamBuilder(
      stream: bloc.confirmPassWordStream,
      builder: (context, snapshot) {
        return TextField(
          cursorColor: colorGrey,
          controller: confirmPasswordController,
          onChanged: null,
          keyboardAppearance: Brightness.light,
          style: _inputTextStyle(),
          obscureText: isHideConfirm,
          textInputAction: TextInputAction.done,
          focusNode: _confirmFocusNode,
          inputFormatters: [LengthLimitingTextInputFormatter(passwordLength)],
          decoration: InputDecoration(
            hintText: '',
            labelText:
                AppLocalizations.of(context).translate("confirm_pass_label"),
            suffixIcon: IconButton(
              icon: !isHideConfirm
                  ? Image.asset(
                      view_on,
                      height: fit.t(16.0),
                      width: fit.t(22.0),
                      color: colorGrey,
                    )
                  : Image.asset(
                      view_off,
                      height: fit.t(20.0),
                      width: fit.t(35.0),
                      color: colorGrey,
                    ),
              onPressed: () {
                isHideConfirm = !isHideConfirm;
                setState(() {});
              },
            ),
            hintStyle: TextStyle(color: colorGrey),
            labelStyle: TextStyle(color: colorGrey),
          ),
        );
      },
    );
  }

  TextStyle _inputTextStyle() {
    return TextStyle(color: colorGrey, fontFamily: regularFont);
  }

  callApiChangePassword() {
    FocusScope.of(context).requestFocus(_blankFocusNode);
    if (oldPassController.text.toString().trim().isNotEmpty) {
      if (oldPassController.text.toString() == oldPass) {
        if (bloc.newPassValidation(
                newPasswordController.text.toString().trim(), context) ==
            null) {
          if (newPasswordController.text.toString().trim() ==
              oldPassController.text.toString().trim()) {
            TopAlert.showAlert(_scaffoldKey.currentState.context,
                AppLocalizations.of(context).translate("new_old_same"), true);
          } else {
            if (bloc.confirmPassValidation(
                    confirmPasswordController.text.toString().trim(),
                    context) ==
                null) {
              Map<String, dynamic> map = Map();
              map.putIfAbsent(
                  'old_pass', () => oldPassController.text.toString().trim());
              map.putIfAbsent('cookie', () => cookies);
              map.putIfAbsent(
                  'password', () => newPasswordController.text.toString());
              bloc.callApiChangePass(map, _scaffoldKey.currentState.context);
            } else {
              TopAlert.showAlert(
                  _scaffoldKey.currentState.context,
                  bloc.confirmPassValidation(
                      confirmPasswordController.text.toString().trim(),
                      context),
                  true);
            }
          }
        } else {
          TopAlert.showAlert(
              _scaffoldKey.currentState.context,
              bloc.newPassValidation(
                  newPasswordController.text.toString().trim(), context),
              true);
        }
      } else {
        TopAlert.showAlert(
            _scaffoldKey.currentState.context,
            AppLocalizations.of(context).translate("old_pass_validation"),
            true);
      }
    } else {
      TopAlert.showAlert(_scaffoldKey.currentState.context,
          AppLocalizations.of(context).translate("old_pass"), true);
    }
  }

  void _subscribeToApiResponse() {
    StreamSubscription subscription;
    subscription = apiResponseController.stream.listen((data) {
      if (data is CommonResponse) {
        if (data.status == 200) {
          writeStringDataLocally(
              key: password,
              value: newPasswordController.text.toString().trim());
          Map<String, String> mapData = Map();
          _onLogin(mapData, context, data.message);
          newPasswordController.text = '';
          oldPassController.text = '';
          confirmPasswordController.text = '';
        }
      } else if (data is ErrorResponse) {
        TopAlert.showAlert(_scaffoldKey.currentState.context, data.error, true);
      } else if (data is CustomError) {
        TopAlert.showAlert(
            _scaffoldKey.currentState.context, data.errorMessage, true);
      } else if (data is Exception) {
        TopAlert.showAlert(
            _scaffoldKey.currentState.context,
            AppLocalizations.of(context).translate("something_went_wrong"),
            true);
      }
    }, onError: (error) {
      if (error is CustomError) {
        TopAlert.showAlert(
            _scaffoldKey.currentState.context, error.errorMessage, true);
      } else {
        TopAlert.showAlert(
            _scaffoldKey.currentState.context, error.toString(), true);
      }
    });
  }

  void _onLogin(Map data, context, String message) async {
    String userPassword = await getStringDataLocally(key: password);

    data.putIfAbsent('username', () => userDataModel.username);
    data.putIfAbsent('password', () => userPassword);
    var url = '$baseUrl$loginUrl';
    var language =  checkLanguage();
    data.putIfAbsent('lang', () => language);
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
          if (map['status'] == 200) {
            try {
              var url2 = '';
              if (!baseUrl.contains('https://')) {
                url2 =
                    '$baseUrl$getUserCurrentInfo?insecure=cool&cookie=${map['cookie']}&lang=$language';
              } else {
                url2 =
                    '$baseUrl$getUserCurrentInfo?cookie=${map['cookie']}&lang=$language';
              }
              ApiConfiguration.getInstance()
                  .apiClient
                  .liveService
                  .apiPostRequest(context, '$url2')
                  .then((response) {
                try {
                  Map userResponseMap = jsonDecode(response.body);
                  if (userResponseMap['status'] == 200) {
//                    db.deleteUser(userDataModel.id);
                    userResponseMap.putIfAbsent("cookie", () => map['cookie']);
                    var data = LoginResponseModel.fromJson(userResponseMap);
                    writeBoolDataLocally(key: session, value: true);
                    writeStringDataLocally(key: cookie, value: data.cookie);
                    writeStringDataLocally(
                        key: userId, value: data.user.id.toString());
                    writeStringDataLocally(
                        key: password, value: userPassword.toString().trim());
                    data.user.password = userPassword.toString().trim();
//                    db.saveUser(data.user);
                    writeStringDataLocally(
                        key: userData, value: json.encode(data.user));
                    ApiConfiguration.createNullConfiguration(
                        ConfigConfig("", true));
                    TopAlert.showAlert(context, '$message', false);
                  } else {}
                } catch (error) {
                  clearDataLocally();
                  Navigator.pushReplacementNamed(context, '/login');
                }
              });
            } catch (error) {
              clearDataLocally();
              Navigator.pushReplacementNamed(context, '/login');
            }
          } else {
            clearDataLocally();
            Navigator.pushReplacementNamed(context, '/login');
          }
        } catch (error) {
          clearDataLocally();
          Navigator.pushReplacementNamed(context, '/login');
        }
      });
    } catch (error) {
      clearDataLocally();
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  void dispose() {
    apiResponseController.close();
    super.dispose();
  }
}
