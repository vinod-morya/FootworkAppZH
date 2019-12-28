import 'dart:async';
import 'dart:io';

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
import 'package:footwork_chinese/model/commonReponse/commonResponse.dart';
import 'package:footwork_chinese/model/errorResponse/customeError.dart';
import 'package:footwork_chinese/model/errorResponse/error_reponse.dart';
import 'package:footwork_chinese/ui/forgetPass/forgetPassBloc/ForgetPassValidationBloc.dart';
import 'package:footwork_chinese/utils/app_localizations.dart';

class ForgotPassScreen extends StatefulWidget {
  @override
  _ForgotPassScreenState createState() => _ForgotPassScreenState();
}

class _ForgotPassScreenState extends State<ForgotPassScreen> {
  var _scaffoldKey = new GlobalKey<ScaffoldState>();
  var _blankFocusNode = FocusNode();

  var _userNameFocusNode = FocusNode();
  var _userNameController = TextEditingController();

  ForgetPassValidationBloc validation;

  StreamController apiResponseController;

  FmFit fit = FmFit(width: 750);

  @override
  void initState() {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
    apiResponseController = StreamController();
    validation = ForgetPassValidationBloc(apiResponseController);
    _subscribeToApiResponse();
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
      appBar: AppBar(
        backgroundColor: colorWhite,
        bottomOpacity: 0.0,
        centerTitle: true,
        title: _widgetLoginText(),
        leading: _widgetBackButton(),
        elevation: 0,
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          FocusScope.of(context).requestFocus(_blankFocusNode);
        },
        child: Stack(children: <Widget>[
          Container(
            decoration: BoxDecoration(color: Color(0xFFFFFFFF)),
          ),
          Container(
            padding: EdgeInsets.only(left: fit.t(15.0), right: fit.t(15.0)),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  _widgetAppLogo(),
                  _widgetForgotText(),
                  SizedBox(
                    height: fit.t(40.0),
                  ),
                  _userNameField(),
                  _bottomLine(),
                  _buttonWidget(),
                  SizedBox(
                    height: fit.t(10.0),
                  ),
                ],
              ),
            ),
          ),
          StreamBuilder<Object>(
              stream: validation.progressLoaderStream,
              builder: (context, snapshot) {
                return ProgressLoader(
                  fit: fit,
                  isShowLoader: snapshot.hasData ? snapshot.data : false,
                  color: appColor,
                );
              }),
        ]),
      ),
    );
  }

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

  Widget _bottomLine() {
    return Container(
      margin: EdgeInsets.only(left: fit.t(15.0), right: fit.t(15.0)),
      height: fit.t(1.0),
      width: MediaQuery.of(context).size.width,
      color: appColor,
    );
  }

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

  Widget _widgetForgotText() {
    return Container(
      margin: EdgeInsets.only(
          top: fit.t(40.0), left: fit.t(25.0), right: fit.t(25.0)),
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          text:
              '${AppLocalizations.of(context).translate("forgot_pass_heading")}',
          style: TextStyle(
              fontSize: fit.t(18.0),
              color: Color(0XFF000000),
              fontFamily: robotoMediumFont,
              fontWeight: FontWeight.bold),
          children: <TextSpan>[
            TextSpan(
              text:
                  '\n${AppLocalizations.of(context).translate("forgot_pass_text")}',
              style: TextStyle(
                  color: Color(0XFF000000),
                  fontSize: fit.t(16.0),
                  fontFamily: regularFont,
                  fontWeight: FontWeight.w400),
            ),
          ],
        ),
      ),
    );
  }

  Widget _widgetBackButton() {
    return Container(
      child: Row(
        children: <Widget>[
          IconButton(
            padding: EdgeInsets.all(fit.t(5.0)),
            onPressed: () => Navigator.of(_scaffoldKey.currentContext).pop(),
            icon: Icon(
              Platform.isAndroid == true
                  ? Icons.arrow_back
                  : Icons.arrow_back_ios,
              color: appColor,
              size: fit.t(30.0),
            ),
          ),
        ],
      ),
    );
  }

  Widget _userNameField() {
    return StreamBuilder<Object>(
        stream: validation.userNameStream,
        builder: (context, snapshot) {
          return Container(
            margin: EdgeInsets.only(
                top: fit.t(10.0), left: fit.t(15.0), right: fit.t(15.0)),
            child: CustomInputField(
              inputFormatters: [
                LengthLimitingTextInputFormatter(userNameLength)
              ],
              suffixIcon: null,
              icon: ic_user_name,
              imgHeight: fit.t(25.0),
              imgWidth: fit.t(30.0),
              iconColor: appColor,
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
              hintStyle:
                  TextStyle(color: colorGrey, fontFamily: robotoBoldFont),
            ),
          );
        });
  }

  Widget _buttonWidget() {
    return Container(
      margin: EdgeInsets.only(top: fit.t(30.0)),
      child: ButtonWidget(
        AppLocalizations.of(context).translate("reset_label"),
        fit.t(30.0),
        () => _buttonPress(),
        fontSize: fit.t(20.0),
        padding: EdgeInsets.only(
            top: fit.t(12.0),
            bottom: fit.t(12.0),
            right: fit.t(9.0),
            left: fit.t(9.0)),
        textColor: colorWhite,
        buttonColor: Color(0xFF3864a1),
      ),
    );
  }

  _buttonPress() {
    FocusScope.of(context).requestFocus(_blankFocusNode);
    if (validation.userNameValidation(
            _userNameController.text.toString().trim(), context) ==
        null) {
      Map map = Map<String, dynamic>();
      map.putIfAbsent(
          'user_name', () => _userNameController.text.toString().trim());
      validation.submitForgetPass(map, _scaffoldKey.currentState.context);
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
      if (data is CommonResponse) {
        if (data.status == 200) {
          TopAlert.showAlert(
              context, data.message == null ? data.msg : data.message, false);
          Future.delayed(const Duration(microseconds: 200), () {
            Navigator.of(context).pop();
          });
        }
      } else if (data is ErrorResponse) {
        TopAlert.showAlert(context, data.error, true);
      } else if (data is CustomError) {
        TopAlert.showAlert(context, data.errorMessage, true);
      } else if (data is Exception) {
        TopAlert.showAlert(
            context,
            AppLocalizations.of(context).translate("something_went_wrong"),
            true);
      }
    }, onError: (error) {
      if (error is CustomError) {
        TopAlert.showAlert(context, error.errorMessage, true);
      } else {
        TopAlert.showAlert(context, error.toString(), true);
      }
    });
  }

  @override
  void dispose() {
    apiResponseController.close();
    super.dispose();
  }
}
