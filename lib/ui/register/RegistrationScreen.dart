import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:fm_fit/fm_fit.dart';
import 'package:footwork_chinese/constants/app_colors.dart';
import 'package:footwork_chinese/constants/app_constants.dart';
import 'package:footwork_chinese/constants/app_images_path.dart';
import 'package:footwork_chinese/custom_widget/ButtonWidget.dart';
import 'package:footwork_chinese/custom_widget/ImageViewer.dart';
import 'package:footwork_chinese/custom_widget/TextField/CustomInputField.dart';
import 'package:footwork_chinese/custom_widget/custom_progress_loader.dart';
import 'package:footwork_chinese/custom_widget/top_alert.dart';
import 'package:footwork_chinese/model/errorResponse/customeError.dart';
import 'package:footwork_chinese/model/errorResponse/error_reponse.dart';
import 'package:footwork_chinese/model/loginResponse/LoginResponseModel.dart';
import 'package:footwork_chinese/network/ApiConfiguration.dart';
import 'package:footwork_chinese/ui/login/WebViewTermsPrivacy.dart';
import 'package:footwork_chinese/ui/register/registrationBloc/RegistrationValidationBloc.dart';
import 'package:footwork_chinese/utils/DialogUtils.dart';
import 'package:footwork_chinese/utils/Utility.dart';
import 'package:footwork_chinese/utils/app_localizations.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  FmFit fit = FmFit(width: 750);
  var isHide = true;
  var isHideConfirm = true;
  var imagePath;
  var chkTerms = false;
  File userImageFile;
  var _scaffoldKey = new GlobalKey<ScaffoldState>();
  var _blankFocusNode = FocusNode();

  var _userNameFocusNode = FocusNode();
  var _userEmailFocusNode = FocusNode();
  var _userFirstNameFocusNode = FocusNode();
  var _userLastNameFocusNode = FocusNode();
  var _userPasswordFocusNode = FocusNode();
  var _userConfirmPasswordFocusNode = FocusNode();

  var _userNameController = TextEditingController();
  var _userEmailController = TextEditingController();
  var _userFirstNameController = TextEditingController();
  var _userLastNameController = TextEditingController();
  var _userPasswordController = TextEditingController();
  var _userConfirmPasswordController = TextEditingController();

  RegistrationValidationBloc validation;

  StreamController apiResponseController;

  @override
  void dispose() {
    apiResponseController.close();
    super.dispose();
  }

  @override
  void initState() {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
    apiResponseController = StreamController();
    _subscribeToApiResponse();
    validation = RegistrationValidationBloc(apiResponseController);
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
        backgroundColor: Colors.white,
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
        child: Stack(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(color: Color(0xFFFFFFFF)),
            ),
            _inputFields(),
            StreamBuilder<Object>(
                stream: validation.progressLoaderStream,
                builder: (context, snapshot) {
                  return ProgressLoader(
                    fit: fit,
                    isShowLoader: snapshot.hasData ? snapshot.data : false,
                    color: appColor,
                  );
                }),
          ],
        ),
      ),
    );
  }

  Widget _widgetAppLogo() {
    return Stack(
      children: <Widget>[
        GestureDetector(
          onTap: () => onImageClick(),
          child: imagePath == null
              ? Container(
                  width: fit.t(110.0),
                  height: fit.t(110.0),
                  decoration: BoxDecoration(
                    color: appColor,
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      fit: BoxFit.fill,
                      image: AssetImage(ic_user_place_holder),
                    ),
                  ),
                )
              : imagePath.contains('http://')
                  ? Container(
                      width: fit.t(110.0),
                      height: fit.t(110.0),
                      decoration: BoxDecoration(
                        color: appColor,
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            fit: BoxFit.fill, image: NetworkImage(imagePath)),
                      ),
                    )
                  : Container(
                      width: fit.t(110.0),
                      height: fit.t(110.0),
                      decoration: BoxDecoration(
                          color: appColor, shape: BoxShape.circle),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(fit.t(110.0)),
                        child: Image.file(
                          userImageFile,
                          fit: BoxFit.fill,
                          width: fit.t(110.0),
                          height: fit.t(110.0),
                        ),
                      ),
                    ),
        ),
        Positioned(
          bottom: 0,
          right: fit.t(10.0),
          child: GestureDetector(
            onTap: () => _optionsDialogBox(context),
            child: Container(
                height: fit.t(30.0),
                width: fit.t(30.0),
                decoration:
                    BoxDecoration(shape: BoxShape.circle, color: appColor),
                child: Image.asset(
                  ic_edit,
                  scale: fit.scale == 1 ? 4.0 : 3.0,
                  color: colorWhite,
                )),
          ),
        )
      ],
    );
  }

  Widget _bottomLine() {
    return Container(
      margin: EdgeInsets.only(left: fit.t(15.0), right: fit.t(15.0)),
      height: 1.0,
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

  Widget _widgetBackButton() {
    return Container(
      margin: EdgeInsets.only(left: 0.0, top: fit.t(5.0)),
      padding: EdgeInsets.only(top: 0.0, left: 0.0, right: 0.0),
      child: Row(
        children: <Widget>[
          IconButton(
            padding: EdgeInsets.all(fit.t(5.0)),
            onPressed: () => Navigator.pop(context),
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
    return StreamBuilder(
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
                  AppLocalizations.of(context).translate("user_name_labels"),
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
        AppLocalizations.of(context).translate("create_account_label"),
        fit.t(20.0),
        () => _buttonPress(),
        fontSize: fit.t(12.0),
        padding: EdgeInsets.only(
          top: fit.t(12.0),
          bottom: fit.t(12.0),
          right: fit.t(20.0),
          left: fit.t(20.0),
        ),
        textColor: colorWhite,
        buttonColor: Color(0xFF005A93),
      ),
    );
  }

  _buttonPress() {
    FocusScope.of(context).requestFocus(_blankFocusNode);
    if (validation.userNameValidation(
            _userNameController.text.toString().trim(), context, "username") ==
        null) {
      if (validation.emailValidation(
              _userEmailController.text.trim(), context) ==
          null) {
        if (validation.userNameValidation(
                _userFirstNameController.text.trim(), context, "first_name") ==
            null) {
          if (validation.userNameValidation(
                  _userLastNameController.text.trim(), context, "last_name") ==
              null) {
            if (validation.passValidation(
                    _userPasswordController.text.toString().trim(), context) ==
                null) {
              if (_userPasswordController.text.toString().trim() ==
                  _userConfirmPasswordController.text.toString().trim()) {
                if (chkTerms) {
                  Map map = Map<String, dynamic>();
                  map.putIfAbsent("username",
                      () => _userNameController.text.toString().trim());
                  if (userImageFile != null) {
                    map.putIfAbsent("profile_image", () => userImageFile);
                  }
                  map.putIfAbsent("first_name",
                      () => _userFirstNameController.text.toString().trim());
                  map.putIfAbsent("last_name",
                      () => _userLastNameController.text.toString().trim());
                  map.putIfAbsent("email",
                      () => _userEmailController.text.toString().trim());
                  map.putIfAbsent("user_pass",
                      () => _userPasswordController.text.toString().trim());
                  validation.submitRegistration(
                      map, _scaffoldKey.currentState.context);
                } else {
                  TopAlert.showAlert(
                      context,
                      AppLocalizations.of(context).translate("accept_terms"),
                      true);
                }
              } else {
                TopAlert.showAlert(context,
                    AppLocalizations.of(context).translate("pass_same"), true);
              }
            } else {
              TopAlert.showAlert(
                  context,
                  validation.passValidation(
                      _userPasswordController.text.toString(), context),
                  true);
            }
          } else {
            TopAlert.showAlert(
                context,
                validation.userNameValidation(
                    _userLastNameController.text.toString(),
                    context,
                    "last_name"),
                true);
          }
        } else {
          TopAlert.showAlert(
              context,
              validation.userNameValidation(
                  _userFirstNameController.text.toString(),
                  context,
                  "first_name"),
              true);
        }
      } else {
        TopAlert.showAlert(
            context,
            validation.emailValidation(
                _userEmailController.text.toString(), context),
            true);
      }
    } else {
      TopAlert.showAlert(
          context,
          validation.userNameValidation(
              _userNameController.text.toString(), context, "username"),
          true);
    }
  }

  Widget _userEmailField() {
    return StreamBuilder(
        stream: validation.emailStream,
        builder: (context, snapshot) {
          return Container(
            margin: EdgeInsets.only(
                top: fit.t(10.0), left: fit.t(15.0), right: fit.t(15.0)),
            child: CustomInputField(
              inputFormatters: [LengthLimitingTextInputFormatter(emailLength)],
              suffixIcon: null,
              icon: ic_email,
              imgHeight: fit.t(25.0),
              imgWidth: fit.t(30.0),
              iconColor: appColor,
              inputAction: TextInputAction.next,
              obscureText: false,
              controller: _userEmailController,
              focusNode: _userEmailFocusNode,
              enabled: true,
              textInputType: TextInputType.emailAddress,
              textStyle:
                  TextStyle(color: colorBlack, fontFamily: robotoBoldFont),
              hintText: AppLocalizations.of(context).translate("email_label"),
              hintStyle:
                  TextStyle(color: colorGrey, fontFamily: robotoBoldFont),
            ),
          );
        });
  }

  Widget _userFirstNameField() {
    return StreamBuilder(
        stream: validation.firstNameStream,
        builder: (context, snapshot) {
          return Container(
            margin: EdgeInsets.only(
                top: fit.t(10.0), left: fit.t(15.0), right: fit.t(15.0)),
            child: CustomInputField(
              inputFormatters: [
                LengthLimitingTextInputFormatter(userNameLength)
              ],
              suffixIcon: null,
              icon: ic_name,
              imgHeight: fit.t(22.0),
              imgWidth: fit.t(30.0),
              iconColor: appColor,
              inputAction: TextInputAction.next,
              obscureText: false,
              controller: _userFirstNameController,
              focusNode: _userFirstNameFocusNode,
              enabled: true,
              textInputType: TextInputType.text,
              textStyle:
                  TextStyle(color: colorBlack, fontFamily: robotoBoldFont),
              hintText: AppLocalizations.of(context).translate("first_name"),
              hintStyle:
                  TextStyle(color: colorGrey, fontFamily: robotoBoldFont),
            ),
          );
        });
  }

  Widget _userLastNameField() {
    return StreamBuilder(
        stream: validation.lastNameStream,
        builder: (context, snapshot) {
          return Container(
            margin: EdgeInsets.only(
                top: fit.t(10.0), left: fit.t(15.0), right: fit.t(15.0)),
            child: CustomInputField(
              inputFormatters: [
                LengthLimitingTextInputFormatter(userNameLength)
              ],
              suffixIcon: null,
              icon: ic_name,
              imgHeight: fit.t(22.0),
              imgWidth: fit.t(30.0),
              iconColor: appColor,
              inputAction: TextInputAction.next,
              obscureText: false,
              controller: _userLastNameController,
              focusNode: _userLastNameFocusNode,
              enabled: true,
              textInputType: TextInputType.text,
              textStyle:
                  TextStyle(color: colorBlack, fontFamily: robotoBoldFont),
              hintText: AppLocalizations.of(context).translate("last_name"),
              hintStyle:
                  TextStyle(color: colorGrey, fontFamily: robotoBoldFont),
            ),
          );
        });
  }

  Widget _userPasswordField() {
    return StreamBuilder(
        stream: validation.passStream,
        builder: (context, snapshot) {
          return Container(
            margin: EdgeInsets.only(
                top: fit.t(10.0), left: fit.t(15.0), right: fit.t(15.0)),
            child: CustomInputField(
              inputFormatters: [
                LengthLimitingTextInputFormatter(passwordLength)
              ],
              enabled: true,
              focusNode: _userPasswordFocusNode,
              icon: ic_passwords,
              imgHeight: fit.t(25.0),
              imgWidth: fit.t(30.0),
              controller: _userPasswordController,
              textStyle:
                  TextStyle(color: colorBlack, fontFamily: robotoBoldFont),
              obscureText: isHide,
              hintStyle:
                  TextStyle(color: colorGrey, fontFamily: robotoBoldFont),
              hintText:
                  AppLocalizations.of(context).translate("password_label"),
              iconColor: appColor,
              inputAction: TextInputAction.next,
              textInputType: TextInputType.visiblePassword,
              suffixIcon: IconButton(
                icon: !isHide
                    ? Image.asset(
                        view_on,
                        height: fit.t(16.0),
                        width: fit.t(22.0),
                        color: appColor,
                      )
                    : Image.asset(
                        view_off,
                        height: fit.t(20.0),
                        width: fit.t(25.0),
                        color: appColor,
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

  Widget _userConfirmPassField() {
    return StreamBuilder(
        stream: validation.confirmPassStream,
        builder: (context, snapshot) {
          return Container(
            margin: EdgeInsets.only(
                top: fit.t(10.0), left: fit.t(15.0), right: fit.t(15.0)),
            child: CustomInputField(
              inputFormatters: [
                LengthLimitingTextInputFormatter(passwordLength)
              ],
              enabled: true,
              focusNode: _userConfirmPasswordFocusNode,
              icon: ic_passwords,
              imgHeight: fit.t(25.0),
              imgWidth: fit.t(30.0),
              controller: _userConfirmPasswordController,
              textStyle:
                  TextStyle(color: colorBlack, fontFamily: robotoBoldFont),
              obscureText: isHideConfirm,
              hintStyle:
                  TextStyle(color: colorGrey, fontFamily: robotoBoldFont),
              hintText: AppLocalizations.of(context)
                  .translate("confirm_password_label"),
              iconColor: appColor,
              inputAction: TextInputAction.done,
              textInputType: TextInputType.visiblePassword,
              suffixIcon: IconButton(
                icon: !isHideConfirm
                    ? Image.asset(
                        view_on,
                        height: fit.t(16.0),
                        width: fit.t(22.0),
                        color: appColor,
                      )
                    : Image.asset(
                        view_off,
                        height: fit.t(20.0),
                        width: fit.t(25.0),
                        color: appColor,
                      ),
                onPressed: () {
                  isHideConfirm = !isHideConfirm;
                  setState(() {});
                },
              ),
            ),
          );
        });
  }

  //listen to api response
  void _subscribeToApiResponse() {
    StreamSubscription subscription;
    subscription = apiResponseController.stream.listen((data) {
      if (data is LoginResponseModel) {
        if (data.status == 200) {
          writeStringDataLocally(key: userId, value: data.user.id.toString());
          writeStringDataLocally(
              key: password,
              value: _userConfirmPasswordController.text.toString().trim());
          data.user.password =
              _userConfirmPasswordController.text.toString().trim();
//          db.saveUser(data.user);
          writeStringDataLocally(key: userData, value: json.encode(data.user));
          ApiConfiguration.createNullConfiguration(ConfigConfig("", true));
          Future.delayed(const Duration(microseconds: 200), () {
            Navigator.pushNamedAndRemoveUntil(
                context, '/dashboardScreen', ModalRoute.withName('/'),
                arguments: data);
          });
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

  Widget _inputFields() {
    return Container(
      padding: EdgeInsets.only(
          top: fit.t(10.0), left: fit.t(15.0), right: fit.t(15.0)),
      child: ListView(
        physics: BouncingScrollPhysics(),
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: fit.t(20.0),
              ),
              _widgetAppLogo(),
              SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    SizedBox(
                      height: fit.t(10.0),
                    ),
                    _userNameField(),
                    _bottomLine(),
                    _userEmailField(),
                    _bottomLine(),
                    _userFirstNameField(),
                    _bottomLine(),
                    _userLastNameField(),
                    _bottomLine(),
                    _userPasswordField(),
                    _bottomLine(),
                    _userConfirmPassField(),
                    _bottomLine(),
                    _confirmPrivacyWidget(),
                    _buttonWidget(),
                    SizedBox(
                      height: fit.t(10.0),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  onImageClick() {
    if (imagePath != null) {
      if (imagePath.toString().contains('http://')) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PhotoViewer(imagePath, fit)),
        );
      }
    }
  }

  _optionsDialogBox(context) {
    DialogUtils.showCustomDialog(context,
        fit: fit,
        okBtnText: AppLocalizations.of(context).translate("camera"),
        cancelBtnText: AppLocalizations.of(context).translate("gallery"),
        title: '',
        content: AppLocalizations.of(context).translate("choose_pic"),
        okBtnFunction: () {
      _captureImage(ImageSource.camera, context);
      Navigator.of(context).pop();
    }, cancelBtnFunction: () {
      _captureImage(ImageSource.gallery, context);
      Navigator.of(context).pop();
    });
  }

  _captureImage(ImageSource source, context) async {
    File _imageFile = await ImagePicker.pickImage(source: source);
    if (_imageFile != null) {
      String name = new DateTime.now().millisecondsSinceEpoch.toString();
      Directory dir = await getApplicationDocumentsDirectory();
      var ext = _imageFile.path
          .toString()
          .substring(_imageFile.path.length - 3, _imageFile.path.length);
      if (ext == 'jpg') {
        ext = 'jpeg';
      }
      var targetPath = dir.absolute.path + "/$name.$ext";
      var imgFile = await _compressFileCaptured(_imageFile, targetPath, ext);

      this.userImageFile = imgFile;
      this.imagePath = _imageFile.path;
      setState(() {});
    }
  }

  Future<File> _compressFileCaptured(
      File file, String targetPath, String ext) async {
    var result = await FlutterImageCompress.compressAndGetFile(
        file.absolute.path, targetPath,
        quality: 100,
        rotate: 0,
        format: ext == 'png' ? CompressFormat.png : CompressFormat.jpeg);
    return result;
  }

  Widget _confirmPrivacyWidget() {
    return Container(
      margin: EdgeInsets.only(
          top: fit.t(10.0), left: fit.t(10.0), right: fit.t(15.0)),
      padding: EdgeInsets.only(top: fit.t(8.0), bottom: fit.t(8.0)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          SizedBox(
            height: 30,
            width: 30,
            child: Checkbox(
              value: chkTerms,
              onChanged: (bool value) {
                chkTerms = value;
                setState(() {});
              },
            ),
          ),
          Expanded(
            child: RichText(
              softWrap: true,
              textAlign: TextAlign.justify,
              text: TextSpan(
                text: AppLocalizations.of(context).translate('agree_with'),
                style: TextStyle(
                  fontFamily: robotoBoldFont,
                  color: colorBlack,
                  decoration: TextDecoration.none,
                  fontSize: fit.t(14.0),
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: AppLocalizations.of(context).translate('terms'),
                    style: TextStyle(
                      fontFamily: robotoBoldFont,
                      color: colorRed,
                      decoration: TextDecoration.underline,
                      fontSize: fit.t(12.0),
                    ),
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
                  ),
                  TextSpan(
                    text: ' & ',
                    style: TextStyle(
                        fontFamily: robotoBoldFont,
                        color: colorRed,
                        decoration: TextDecoration.none,
                        fontSize: fit.t(12.0)),
                  ),
                  TextSpan(
                    text: AppLocalizations.of(context).translate('privacy'),
                    style: TextStyle(
                        fontFamily: robotoBoldFont,
                        color: colorRed,
                        decoration: TextDecoration.underline,
                        fontSize: fit.t(12.0)),
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
        ],
      ),
    );
  }

  _launchUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
