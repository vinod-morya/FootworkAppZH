import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fm_fit/fm_fit.dart';
import 'package:footwork_chinese/constants/app_colors.dart';
import 'package:footwork_chinese/constants/app_constants.dart';
import 'package:footwork_chinese/constants/app_images_path.dart';
import 'package:footwork_chinese/custom_widget/ButtonWidget.dart';
import 'package:footwork_chinese/custom_widget/TextField/CustomInputField.dart';
import 'package:footwork_chinese/custom_widget/custom_progress_loader.dart';
import 'package:footwork_chinese/custom_widget/top_alert.dart';
import 'package:footwork_chinese/model/errorResponse/customeError.dart';
import 'package:footwork_chinese/model/errorResponse/error_reponse.dart';
import 'package:footwork_chinese/model/loginResponse/LoginResponseModel.dart';
import 'package:footwork_chinese/network/ApiConfiguration.dart';
import 'package:footwork_chinese/ui/login/WebViewTermsPrivacy.dart';
import 'package:footwork_chinese/ui/login/loginbloc/LoginValidationBloc.dart';
import 'package:footwork_chinese/utils/Utility.dart';
import 'package:footwork_chinese/utils/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var _scaffoldKey = GlobalKey<ScaffoldState>();

  //focus nodes of input fields
  var _screenFocusNode = FocusNode();
  var _passFocusNode = FocusNode();
  var _userNameFocusNode = FocusNode();

  //text controllers for input fields
  var _userNameController = TextEditingController();
  var _passwordController = TextEditingController();

  var isHide = true;
  FmFit fit = FmFit(width: 750);

  //video controller
//  VideoPlayerController _controller;

  LoginValidationBloc validation;

  StreamController apiResponseController;

  @override
  void initState() {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
    apiResponseController = StreamController();
    _subscribeToApiResponse();
    validation = LoginValidationBloc(apiResponseController);
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
      backgroundColor: colorWhite,
      appBar: AppBar(
        backgroundColor: colorWhite,
        bottomOpacity: 0.0,
        centerTitle: true,
        title: _widgetLoginText(),
        elevation: 0,
      ),
      body: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            FocusScope.of(context).requestFocus(_screenFocusNode);
          },
          child: Stack(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(color: Color(0xFFFFFFFF)),
              ),
              _mainWidget(),
              StreamBuilder<Object>(
                  stream: validation.progressLoaderStream,
                  builder: (context, snapshot) {
                    return ProgressLoader(
                      fit: fit,
                      isShowLoader: snapshot.hasData ? snapshot.data : false,
                      color: colorGrey,
                    );
                  }),
            ],
          )),
    );
  }

  Widget _widgetBackButton() {
    return Container(
      child: Row(
        children: <Widget>[
          IconButton(
            padding: EdgeInsets.all(fit.t(5.0)),
            onPressed: () => null,
            enableFeedback: false,
            icon: Icon(
              Platform.isAndroid == true
                  ? Icons.arrow_back
                  : Icons.arrow_back_ios,
              color: Colors.transparent,
              size: fit.t(30.0),
            ),
          ),
        ],
      ),
    );
  }

  // Parent widget of screen
  Widget _mainWidget() {
    return ListView(
      physics: BouncingScrollPhysics(),
      children: <Widget>[
        Container(
          height: MediaQuery.of(context).size.height + 20,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: <Widget>[
              _widgetAppLogo(),
              Platform.isIOS ? _widgetAppTextLogo() : Container(),
              _inputFields(),
              _forgotPassWidget(),
              _loginButtonWidget(),
              Platform.isIOS ? _termsOfUse() : _newRegistrationText(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _termsOfUse() {
    return Flexible(
      fit: FlexFit.tight,
      flex: 1,
      child: Container(
        margin: EdgeInsets.only(
            bottom: Platform.isAndroid ? fit.t(10.0) : fit.t(50.0)),
        child: Align(
          alignment: Alignment.lerp(Alignment.center, Alignment.center, 0.2),
          child: Container(
            margin: EdgeInsets.only(top: fit.t(20.0)),
            child: RichText(
              softWrap: true,
              textAlign: TextAlign.center,
              text: TextSpan(
                text: AppLocalizations.of(context).translate('terms'),
                style: TextStyle(
                    fontFamily: robotoBoldFont,
                    color: appColor,
                    fontWeight: FontWeight.w500,
                    decoration: TextDecoration.underline,
                    fontSize: fit.t(14.0)),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => WebViewTermsPrivacy(
                                url: '$TERMS_OF_USE',
                                title: AppLocalizations.of(context)
                                    .translate('terms'))));
                  },
                children: <TextSpan>[
                  TextSpan(
                      text: ' | ',
                      style: TextStyle(
                          fontFamily: robotoBoldFont,
                          color: appColor,
                          decoration: TextDecoration.none,
                          fontSize: fit.t(14.0))),
                  TextSpan(
                    text:
                        '${AppLocalizations.of(context).translate('privacy')}',
                    style: TextStyle(
                        fontFamily: robotoBoldFont,
                        color: appColor,
                        decoration: TextDecoration.underline,
                        fontWeight: FontWeight.w500,
                        fontSize: fit.t(14.0)),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    WebViewTermsPrivacy(
                                        url: '$PRIVACY_USE',
                                        title:
                                        AppLocalizations.of(context).translate(
                                            'privacy')))
                        );
                      },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _widgetAppTextLogo() {
    return Container(
        padding: EdgeInsets.only(top: fit.t(30.0)),
        child: Text(
          AppLocalizations.of(context).translate("login_signup_up"),
          style: TextStyle(
              color: appColor,
              fontWeight: FontWeight.bold,
              fontFamily: robotoBoldCondenseFont),
        ));
  }

  //App Logo widget
  Widget _widgetAppLogo() {
    return Container(
      padding: EdgeInsets.only(top: fit.t(50.0)),
      child: Image.asset(
        appLogo,
        width: fit.t(100.0),
        height: fit.t(100.0),
      ),
    );
  }

  // App name widget
  Widget _widgetLoginText() {
    return Container(
      margin: EdgeInsets.only(
          left: fit.t(10.0), top: fit.t(10.0), bottom: fit.t(0.0)),
      child: Image.asset(
        ic_app_icon,
        scale: fit.scale == 1 ? 2.5 : 1.8,
        color: appColor,
      ),
    );
  }

  // Input fields container
  Widget _inputFields() {
    return Container(
      margin: EdgeInsets.only(
          top: fit.t(0.0), left: fit.t(15.0), right: fit.t(15.0)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          _getUserNameInputFieldWidget(),
          _bottomLine(),
          _getPasswordInputFieldWidget(),
          _bottomLine(),
        ],
      ),
    );
  }

  // Straight line widget
  Widget _bottomLine() {
    return Container(
      margin: EdgeInsets.only(left: fit.t(15.0), right: fit.t(15.0)),
      height: fit.t(1.0),
      width: MediaQuery.of(context).size.width,
      color: colorRed,
    );
  }

  // Username input widget
  Widget _getUserNameInputFieldWidget() {
    return StreamBuilder(
        stream: validation.userNameStream,
        builder: (context, snapshot) {
          return Container(
            margin: EdgeInsets.only(
                top: fit.t(50.0), left: fit.t(15.0), right: fit.t(15.0)),
            child: CustomInputField(
              inputFormatters: [
                LengthLimitingTextInputFormatter(userNameLength)
              ],
              suffixIcon: null,
              icon: ic_user_name,
              imgHeight: fit.t(25.0),
              imgWidth: fit.t(30.0),
              iconColor: colorRed,
              inputAction: TextInputAction.next,
              obscureText: false,
              controller: _userNameController,
              focusNode: _userNameFocusNode,
              enabled: true,
              textInputType: TextInputType.text,
              textStyle:
                  TextStyle(color: colorBlack, fontFamily: robotoBoldFont),
              hintText:
                  AppLocalizations.of(context).translate("user_name_label"),
            ),
          );
        });
  }

  // Password input widget
  Widget _getPasswordInputFieldWidget() {
    return StreamBuilder(
        stream: validation.passStream,
        builder: (context, snapshot) {
          return Container(
            margin: EdgeInsets.only(
                top: fit.t(15.0), left: fit.t(15.0), right: fit.t(15.0)),
            child: CustomInputField(
              inputFormatters: [
                LengthLimitingTextInputFormatter(passwordLength)
              ],
              enabled: true,
              focusNode: _passFocusNode,
              icon: ic_passwords,
              imgHeight: fit.t(25.0),
              imgWidth: fit.t(30.0),
              controller: _passwordController,
              textStyle:
                  TextStyle(color: colorBlack, fontFamily: robotoBoldFont),
              obscureText: isHide,
              hintText:
                  AppLocalizations.of(context).translate("password_label"),
              iconColor: colorRed,
              inputAction: TextInputAction.done,
              textInputType: TextInputType.visiblePassword,
              suffixIcon: IconButton(
                icon: !isHide
                    ? Image.asset(
                        view_on,
                        height: fit.t(16.0),
                        width: fit.t(22.0),
                        color: colorRed,
                      )
                    : Image.asset(
                        view_off,
                        height: fit.t(20.0),
                        width: fit.t(25.0),
                        color: colorRed,
                      ),
                onPressed: () {
                  isHide = !isHide;
                  setState(() {});
                },
              ),
            ),
          );
        });
  }

  // Forget password widget and navigation
  Widget _forgotPassWidget() {
    return Container(
      margin: EdgeInsets.only(
          top: fit.t(10.0), left: fit.t(15.0), right: fit.t(30.0)),
      child: Align(
        alignment: Alignment.centerRight,
        child: GestureDetector(
          child: Text(
            AppLocalizations.of(context).translate("forget_pass"),
            style: TextStyle(
                fontSize: fit.t(15.0),
                decoration: TextDecoration.underline,
                fontFamily: robotoBoldFont,
                color: colorRed),
          ),
          onTap: () => Navigator.of(context).pushNamed("/forgotPass"),
        ),
      ),
    );
  }

  // Login button widget and action
  Widget _loginButtonWidget() {
    return Container(
      margin: EdgeInsets.only(
        top: fit.t(25.0),
      ),
      child: ButtonWidget(
        Platform.isAndroid ? AppLocalizations.of(context).translate(
            "login_label") : AppLocalizations.of(context).translate(
            "login_signup"),
        fit.t(20),
            () => _onLoginClick(_scaffoldKey.currentState.context),
        fontSize: fit.t(20),
        padding: EdgeInsets.only(
          top: fit.t(12.0),
          bottom: fit.t(12.0),
          right: fit.t(80.0),
          left: fit.t(80.0),
        ),
        textColor: colorWhite,
        buttonColor: Color(0xFF3864a1),
      ),
    );
  }

  // Registration widget and navigation to registration page
  Widget _newRegistrationText() {
    return Flexible(
      fit: FlexFit.tight,
      flex: 1,
      child: Container(
        margin: EdgeInsets.only(
            bottom: Platform.isAndroid ? fit.t(10.0) : fit.t(50.0)),
        child: Align(
          alignment: Alignment.lerp(Alignment.center, Alignment.center, 0.2),
          child: Container(
            margin: EdgeInsets.only(top: fit.t(20.0)),
            child: RichText(
              softWrap: true,
              textAlign: TextAlign.center,
              text: TextSpan(
                text: AppLocalizations.of(context).translate("new_user"),
                style: TextStyle(
                  color: colorBlack,
                  fontSize: fit.t(18.0),
                  fontFamily: robotoBoldFont,
                ),
                children: <TextSpan>[
                  TextSpan(
                    text:
                        AppLocalizations.of(context).translate("sign_up_label"),
                    style: TextStyle(
                        fontFamily: robotoBoldFont,
                        color: colorRed,
                        decoration: TextDecoration.none,
                        fontSize: fit.t(18.0)),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.pushNamed(context, "/registrationScreen");
                      },
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    apiResponseController.close();
    validation.dispose();
    super.dispose();
  }

  //login Validation check
  _onLoginClick(BuildContext context) {
    FocusScope.of(context).requestFocus(_screenFocusNode);
    if (validation.userNameValidation(
            _userNameController.text.toString().trim(), context) ==
        null) {
      if (validation.passValidation(
              _passwordController.text.toString().trim(), context) ==
          null) {
        Map map = Map<String, dynamic>();
        validation.submitLogin(map, _scaffoldKey.currentState.context);
      } else {
        TopAlert.showAlert(
            context,
            validation.passValidation(
                _passwordController.text.toString(), context),
            true);
      }
    } else {
      TopAlert.showAlert(
          context,
          validation.userNameValidation(
              _userNameController.text.toString(), context),
          true);
    }
  }

  //listen to api response
  void _subscribeToApiResponse() {
    StreamSubscription subscription;
    subscription = apiResponseController.stream.listen((data) {
      if (data is LoginResponseModel) {
        if (data.status == 200) {
          if (Platform.isIOS) {
            if (data.from == "1") {
              TopAlert.showAlert(
                  context,
                  AppLocalizations.of(context).translate("new_account_msg"),
                  false);
            }
          }
          writeStringDataLocally(key: cookie, value: data.cookie);
          writeStringDataLocally(key: userId, value: data.user.id.toString());
          writeStringDataLocally(
              key: password, value: _passwordController.text.toString().trim());
          data.user.password = _passwordController.text.toString().trim();
          writeStringDataLocally(key: userData, value: json.encode(data.user));
          ApiConfiguration.createNullConfiguration(ConfigConfig("", true));
          Future.delayed(const Duration(microseconds: 200), () {
            Navigator.pushNamedAndRemoveUntil(
                context, '/dashboardScreen', ModalRoute.withName('/'),
                arguments: data.user);
          });
        }
      } else if (data is ErrorResponse) {
        if (Platform.isIOS) {
          if (data.error.contains("Username does not exist.")) {
            var isEmail = false;
            if (validateEmail(
                _userNameController.text.toString().trim(), context) == null) {
              isEmail = true;
            }

            var userName = _userNameController.text
                .toString()
                .trim()
                .replaceAll(" ", "")
                .replaceAll("\@", "")
                .replaceAll("\#", "")
                .replaceAll("\%", "")
                .replaceAll("\^", "")
                .replaceAll(".", "")
                .replaceAll("\&", "")
                .replaceAll("\`", "")
                .replaceAll("\~", "")
                .replaceAll("\$", "")
                .replaceAll("\*", "")
                .replaceAll("\(", "")
                .replaceAll("\)", "")
                .replaceAll("\-", "")
                .replaceAll("\_", "")
                .replaceAll("\+", "")
                .replaceAll("\=", "");

            try {
              if (isEmail) {
                var userValue = _userNameController.text.toString()
                    .trim()
                    .split(
                    '@');
                if (userValue.length > 0) {
                  userName = userValue[0];
                }
              }
            } catch (e) {}

            var userEmail = _userNameController.text
                .toString()
                .trim()
                .replaceAll(" ", "")
                .replaceAll("\@", "")
                .replaceAll("\#", "")
                .replaceAll("\%", "")
                .replaceAll("\^", "")
                .replaceAll(".", "")
                .replaceAll("\&", "")
                .replaceAll("\`", "")
                .replaceAll("\~", "")
                .replaceAll("\$", "")
                .replaceAll("\*", "")
                .replaceAll("\(", "")
                .replaceAll("\)", "")
                .replaceAll("\-", "")
                .replaceAll("\_", "")
                .replaceAll("\+", "")
                .replaceAll("\=", "") +
                "@1micahlancaster.com";

            if (validateEmail(
                _userNameController.text.toString().trim(), context) == null) {
              userEmail = _userNameController.text.toString().trim();
            }

            Map map = Map<String, dynamic>();
            map.putIfAbsent(
                "username", () => _userNameController.text.toString().trim());
            map.putIfAbsent(
                "first_name", () => userName);
            map.putIfAbsent(
                "last_name", () => userName);
            map.putIfAbsent("email", () => userEmail);
            map.putIfAbsent(
                "user_pass", () => _passwordController.text.toString().trim());
            validation.submitRegistration(
                map, _scaffoldKey.currentState.context);
          } else {
            final action = CupertinoAlertDialog(
              title: Text(AppLocalizations.of(context).translate("app_name")),
              content: Text("${data.error}"),
              actions: <Widget>[
                CupertinoDialogAction(
                    isDefaultAction: true,
                    child: Text(AppLocalizations.of(context).translate("ok")),
                    onPressed: () {
                      Navigator.of(context).pop();
                    }),
              ],
            );
            showCupertinoModalPopup(
                context: context, builder: (context) => action);
          }
        } else {
          TopAlert.showAlert(
              _scaffoldKey.currentState.context, data.error, true);
        }
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

  String validateEmail(String value, context) {
    if (value.isEmpty)
      return AppLocalizations.of(context).translate("email_empty");
    final RegExp nameExp = new RegExp(
        r'^([A-Za-z0-9+_\-\.])+\@([A-Za-z0-9_\-\.])+\.([A-Za-z]{2,63})$');
    if (!nameExp.hasMatch(value))
      return AppLocalizations.of(context).translate("email_invalid");
    return null;
  }

  _launchUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
