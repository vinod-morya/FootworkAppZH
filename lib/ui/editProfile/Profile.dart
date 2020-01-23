import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:fm_fit/fm_fit.dart';
import 'package:footwork_chinese/constants/app_colors.dart';
import 'package:footwork_chinese/constants/app_constants.dart';
import 'package:footwork_chinese/constants/app_images_path.dart';
import 'package:footwork_chinese/custom_widget/ImageViewer.dart';
import 'package:footwork_chinese/custom_widget/TextField/CustomInputField.dart';
import 'package:footwork_chinese/custom_widget/custom_progress_loader.dart';
import 'package:footwork_chinese/custom_widget/top_alert.dart';
import 'package:footwork_chinese/database/data_base_helper.dart';
import 'package:footwork_chinese/model/CountryListResponse.dart';
import 'package:footwork_chinese/model/StateListResponse.dart';
import 'package:footwork_chinese/model/errorResponse/customeError.dart';
import 'package:footwork_chinese/model/errorResponse/error_reponse.dart';
import 'package:footwork_chinese/model/loginResponse/LoginResponseModel.dart';
import 'package:footwork_chinese/style/theme.dart';
import 'package:footwork_chinese/ui/editProfile/SearchCountry.dart';
import 'package:footwork_chinese/ui/editProfile/SearchState.dart';
import 'package:footwork_chinese/ui/editProfile/profileBloc/EditProfileValidationBloc.dart';
import 'package:footwork_chinese/utils/DialogUtils.dart';
import 'package:footwork_chinese/utils/Utility.dart';
import 'package:footwork_chinese/utils/app_localizations.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class ProfileScreen extends StatefulWidget {
  final title;

  ProfileScreen(this.title);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  FmFit fit = FmFit(width: 750);
  var _scaffoldKey = new GlobalKey<ScaffoldState>();
  var _blankFocusNode = FocusNode();

  var _userEmailFocusNode = FocusNode();
  var _userFirstNameFocusNode = FocusNode();
  var _userLastNameFocusNode = FocusNode();
  var _userPhoneFocusNode = FocusNode();
  var _userAddressFocusNode = FocusNode();
  var _userStateFocusNode = FocusNode();
  var _userPincodeFocusNode = FocusNode();

  var _userEmailController = TextEditingController();
  var _userFirstNameController = TextEditingController();
  var _userLastNameController = TextEditingController();
  var _userPhoneController = TextEditingController();
  var _userPincodeController = TextEditingController();
  var _userAddressController = TextEditingController();
  var _userStateController = TextEditingController();

  List<CountriesListBean> countryList = List();
  List<StateListBean> stateList = List();
  bool editable = false;
  var db = DataBaseHelper();
  var actionButton = Icons.edit;
  var cookies, userIdValue;
  EditProfileValidationBloc validation;
  StreamController _controller;

  UserBean userDataModel;

  File userImageFile;

  String imagePath;

  var countryName;
  var stateName;
  var countryId;
  var stateId;

  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }

  @override
  void initState() {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
    getStringDataLocally(key: userData).then((onUserModel) {
      userDataModel = UserBean.fromJson(jsonDecode(onUserModel));
      if (userDataModel.avatar != null && userDataModel.avatar.isNotEmpty) {
        imagePath = userDataModel.avatar;
      }
      getStringDataLocally(key: countries).then((onFetchCountries) {
        countryList.addAll(
            CountryListResponse.fromJson(json.decode(onFetchCountries))
                .countries);
        setUserData();
      });
    });

    _controller = StreamController();
    validation = EditProfileValidationBloc(_controller);
    _listenApiResponse();
    getStringDataLocally(key: cookie).then((receivedCookie) {
      cookies = receivedCookie;
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
    return Scaffold(
      key: _scaffoldKey,
      appBar: _gradientAppBarWidget(),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          FocusScope.of(context).requestFocus(_blankFocusNode);
        },
        child: Stack(
          children: <Widget>[
            Container(
              color: Color(0xFFebebec),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              color: Colors.transparent,
              child: _inputFields(),
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
          ],
        ),
      ),
    );
  }

  _buttonPress() {
    FocusScope.of(context).requestFocus(_blankFocusNode);
    if (validation.userNameValidation(
        _userFirstNameController.text.toString().trim(),
        context,
        "first_name") ==
        null) {
      if (validation.userNameValidation(
          _userLastNameController.text.trim(), context, "last_name") ==
          null) {
        if (validation.emailValidation(
            _userEmailController.text.trim(), context) ==
            null) {
          Map map = Map<String, dynamic>();
          map.putIfAbsent("cookie", () => cookies);
          if (userImageFile != null) {
            map.putIfAbsent("profile_image", () => userImageFile);
          }
          map.putIfAbsent("first_name",
                  () => _userFirstNameController.text.toString().trim());
          map.putIfAbsent("last_name",
                  () => _userLastNameController.text.toString().trim());
          map.putIfAbsent(
              "email", () => _userEmailController.text.toString().trim());

          map.putIfAbsent("billing_phone",
                  () => _userPhoneController.text.toString().trim());
          map.putIfAbsent("billing_country", () => countryId);
          map.putIfAbsent(
              "billing_state",
                  () => stateId == null
                  ? _userStateController.text.toString().trim()
                  : stateId);
          map.putIfAbsent("billing_city", () => "");
          map.putIfAbsent("billing_address_1",
                  () => _userAddressController.text.toString().trim());
          map.putIfAbsent("billing_postcode",
                  () => _userPincodeController.text.toString().trim());
          validation.updateData(map, _scaffoldKey.currentState.context);
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
                _userLastNameController.text.toString(), context, "last_name"),
            true);
      }
    } else {
      TopAlert.showAlert(
          context,
          validation.userNameValidation(
              _userFirstNameController.text.toString(), context, "first_name"),
          true);
    }
  }

  Widget _userEmailField() {
    return StreamBuilder(builder: (context, snapshot) {
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
          enabled: false,
          textInputType: TextInputType.emailAddress,
          textStyle: TextStyle(color: appColor, fontFamily: robotoMediumFont),
          hintText: AppLocalizations.of(context).translate("email_label"),
          hintStyle: TextStyle(color: colorGrey, fontFamily: robotoMediumFont),
        ),
      );
    });
  }

  Widget _userFirstNameField() {
    return StreamBuilder(builder: (context, snapshot) {
      return Container(
        margin: EdgeInsets.only(
            top: fit.t(10.0), left: fit.t(15.0), right: fit.t(15.0)),
        child: CustomInputField(
          inputFormatters: [LengthLimitingTextInputFormatter(userNameLength)],
          suffixIcon: null,
          icon: ic_name,
          imgHeight: fit.t(22.0),
          imgWidth: fit.t(30.0),
          iconColor: appColor,
          inputAction: TextInputAction.next,
          obscureText: false,
          controller: _userFirstNameController,
          focusNode: _userFirstNameFocusNode,
          enabled: editable,
          textInputType: TextInputType.text,
          textStyle: TextStyle(color: appColor, fontFamily: robotoMediumFont),
          hintText: AppLocalizations.of(context).translate("first_name"),
          hintStyle: TextStyle(color: colorGrey, fontFamily: robotoMediumFont),
        ),
      );
    });
  }

  Widget _userLastNameField() {
    return StreamBuilder(builder: (context, snapshot) {
      return Container(
        margin: EdgeInsets.only(
            top: fit.t(10.0), left: fit.t(15.0), right: fit.t(15.0)),
        child: CustomInputField(
          inputFormatters: [LengthLimitingTextInputFormatter(userNameLength)],
          suffixIcon: null,
          icon: ic_name,
          imgHeight: fit.t(22.0),
          imgWidth: fit.t(30.0),
          iconColor: appColor,
          inputAction: TextInputAction.next,
          obscureText: false,
          controller: _userLastNameController,
          focusNode: _userLastNameFocusNode,
          enabled: editable,
          textInputType: TextInputType.text,
          textStyle: TextStyle(color: appColor, fontFamily: robotoMediumFont),
          hintText: AppLocalizations.of(context).translate("last_name"),
          hintStyle: TextStyle(color: colorGrey, fontFamily: robotoMediumFont),
        ),
      );
    });
  }

  Widget _gradientAppBarWidget() {
    return GradientAppBar(
      gradient: ColorsTheme.dashBoardGradient,
      centerTitle: true,
      title: Text(AppLocalizations.of(context).translate("profile")),
      actions: <Widget>[
        GestureDetector(
          onTap: () {
            editable = !editable;
            if (editable) {
              actionButton = Icons.check;
            } else {
              actionButton = Icons.edit;
              _buttonPress();
            }
            setState(() {});
          },
          child: Container(
            width: fit.t(50.0),
            height: fit.t(50.0),
            child: Icon(
              actionButton,
              color: colorWhite,
            ),
          ),
        ),
      ],
    );
  }

  Widget _userPhoneNumberField() {
    return Container(
      margin: EdgeInsets.only(
          top: fit.t(10.0), left: fit.t(15.0), right: fit.t(15.0)),
      child: CustomInputField(
        inputFormatters: [LengthLimitingTextInputFormatter(userNameLength)],
        suffixIcon: null,
        icon: ic_call,
        imgHeight: fit.t(40.0),
        imgWidth: fit.t(30.0),
        iconColor: appColor,
        inputAction: TextInputAction.next,
        obscureText: false,
        controller: _userPhoneController,
        focusNode: _userPhoneFocusNode,
        enabled: editable,
        textInputType: TextInputType.phone,
        textStyle: TextStyle(color: appColor, fontFamily: robotoMediumFont),
        hintText: AppLocalizations.of(context).translate("phone_number"),
        hintStyle: TextStyle(color: colorGrey, fontFamily: robotoMediumFont),
      ),
    );
  }

  Widget _userCityField() {
    return GestureDetector(
      onTap: () => editable ? _openSearchScreen() : null,
      child: Container(
        margin: EdgeInsets.only(top: fit.t(10.0)),
        child: Stack(
          children: <Widget>[
            Positioned(
              left: fit.t(60.0),
              top: fit.t(15.0),
              child: Container(
                child: Text(
                  countryName == null
                      ? AppLocalizations.of(context).translate("city")
                      : countryName,
                  softWrap: true,
                  style: TextStyle(
                      color: countryName == null ? Color(0x96464649) : appColor,
                      fontFamily: robotoMediumFont,
                      fontSize: fit.t(16.0)),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: fit.t(15.0)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                    ic_city,
                    height: fit.t(40.0),
                    width: fit.t(30.0),
                  ),
                  Row(
                    children: <Widget>[
                      IconButton(
                        icon: Icon(
                          Icons.keyboard_arrow_down,
                          color: Color(0x80464649),
                        ),
                        onPressed: () {
                          if (editable) {
                            _openSearchScreen();
                          }
                        },
                      )
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _userStateField() {
    return stateList.length > 0
        ? GestureDetector(
      onTap: () => editable ? _openStateList() : null,
      child: Container(
        margin: EdgeInsets.only(top: fit.t(10.0)),
        child: Stack(
          children: <Widget>[
            Positioned(
              left: fit.t(60.0),
              top: fit.t(15.0),
              child: Container(
                child: Text(
                  stateName == null
                      ? AppLocalizations.of(context).translate("state")
                      : stateName,
                  softWrap: true,
                  style: TextStyle(
                      color: stateName == null
                          ? Color(0x80464649)
                          : appColor,
                      fontFamily: robotoMediumFont,
                      fontSize: fit.t(16.0)),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: fit.t(15.0)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                    ic_city,
                    height: fit.t(40.0),
                    width: fit.t(30.0),
                  ),
                  Row(
                    children: <Widget>[
                      IconButton(
                        icon: Icon(
                          Icons.keyboard_arrow_down,
                          color: Color(0x80464649),
                        ),
                        onPressed: () {
                          if (editable) {
                            _openStateList();
                          }
                        },
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    )
        : _userStateFreeField();
  }

  Widget _userStateFreeField() {
    return Container(
      margin: EdgeInsets.only(
          top: fit.t(10.0), left: fit.t(15.0), right: fit.t(15.0)),
      child: CustomInputField(
        inputFormatters: [LengthLimitingTextInputFormatter(userNameLength)],
        suffixIcon: null,
        icon: ic_city,
        imgHeight: fit.t(40.0),
        imgWidth: fit.t(30.0),
        iconColor: appColor,
        inputAction: TextInputAction.next,
        obscureText: false,
        controller: _userStateController,
        focusNode: _userStateFocusNode,
        enabled: editable,
        textInputType: TextInputType.text,
        textStyle: TextStyle(color: appColor, fontFamily: robotoMediumFont),
        hintText: AppLocalizations.of(context).translate("state"),
        hintStyle: TextStyle(color: colorGrey, fontFamily: robotoMediumFont),
      ),
    );
  }

  Widget _userAddressField() {
    return Container(
      margin: EdgeInsets.only(
          top: fit.t(10.0), left: fit.t(15.0), right: fit.t(15.0)),
      child: CustomInputField(
        inputFormatters: [LengthLimitingTextInputFormatter(userNameLength)],
        suffixIcon: null,
        icon: ic_address,
        imgHeight: fit.t(40.0),
        imgWidth: fit.t(30.0),
        iconColor: appColor,
        inputAction: TextInputAction.next,
        obscureText: false,
        controller: _userAddressController,
        focusNode: _userAddressFocusNode,
        enabled: editable,
        textInputType: TextInputType.text,
        textStyle: TextStyle(color: appColor, fontFamily: robotoMediumFont),
        hintText: AppLocalizations.of(context).translate("address"),
        hintStyle: TextStyle(color: colorGrey, fontFamily: robotoMediumFont),
      ),
    );
  }

  Widget _userPinCodeField() {
    return Container(
      margin: EdgeInsets.only(
          top: fit.t(10.0), left: fit.t(15.0), right: fit.t(15.0)),
      child: CustomInputField(
        inputFormatters: [LengthLimitingTextInputFormatter(zipCodeLength)],
        suffixIcon: null,
        icon: ic_address,
        imgHeight: fit.t(40.0),
        imgWidth: fit.t(30.0),
        iconColor: appColor,
        inputAction: TextInputAction.next,
        obscureText: false,
        controller: _userPincodeController,
        focusNode: _userPincodeFocusNode,
        enabled: editable,
        textInputType: TextInputType.number,
        textStyle: TextStyle(color: appColor, fontFamily: robotoMediumFont),
        hintText: AppLocalizations.of(context).translate("pin_code"),
        hintStyle: TextStyle(color: colorGrey, fontFamily: robotoMediumFont),
      ),
    );
  }

  // Straight line widget
  Widget _bottomLine() {
    return Divider(
      height: fit.t(0.5),
      endIndent: fit.t(20.0),
      indent: fit.t(20.0),
      color: appColor,
    );
  }

  Widget _inputFields() {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          SizedBox(
            height: fit.t(20.0),
          ),
          Container(
            height: fit.t(100.0),
            width: fit.t(100.0),
            margin: EdgeInsets.only(
              left: fit.t(110.0),
              right: fit.t(110.0),
            ),
            child: Stack(
              children: <Widget>[
                GestureDetector(
                  onTap: () => onImageClick(),
                  child: CircleAvatar(
                    radius: fit.t(50.0),
                    backgroundImage: imagePath == null
                        ? AssetImage(ic_user_place_holder)
                        : imagePath.contains('https://')
                        ? NetworkImage(imagePath)
                        : AssetImage(imagePath),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: fit.t(10.0),
                  child: editable
                      ? GestureDetector(
                    onTap: () => _optionsDialogBox(context),
                    child: Container(
                        height: fit.t(30.0),
                        width: fit.t(30.0),
                        decoration: BoxDecoration(
                            shape: BoxShape.circle, color: Colors.red),
                        child: Image.asset(
                          ic_edit,
                          scale: fit.scale == 1 ? 4.0 : 3.0,
                          color: colorWhite,
                        )),
                  )
                      : Container(),
                )
              ],
            ),
          ),
          SizedBox(
            height: fit.t(10.0),
          ),
          _userFirstNameField(),
          SizedBox(
            child: _bottomLine(),
          ),
          _userLastNameField(),
          SizedBox(
            child: _bottomLine(),
          ),
          _userEmailField(),
          SizedBox(
            child: _bottomLine(),
          ),
          _userPhoneNumberField(),
          SizedBox(
            child: _bottomLine(),
          ),
          _userCityField(),
          SizedBox(
            child: _bottomLine(),
          ),
          _userStateField(),
          SizedBox(
            child: _bottomLine(),
          ),
          _userAddressField(),
          SizedBox(
            child: _bottomLine(),
          ),
          _userPinCodeField(),
          SizedBox(
            child: _bottomLine(),
          ),
          SizedBox(
            height: fit.t(10.0),
          ),
        ],
      ),
    );
  }

  void setUserData() {
    _userFirstNameController.text = userDataModel.firstname;
    _userLastNameController.text = userDataModel.lastname;
    _userEmailController.text = userDataModel.email;
    _userPhoneController.text = userDataModel.phone;
    for (int i = 0; i < countryList.length; i++) {
      if (countryList[i].code == userDataModel.country) {
        countryName = countryList[i].name;
        callApiGetState(countryList[i].code);
        break;
      }
    }
    countryId = userDataModel.country;
    stateId = userDataModel.state;
    _userAddressController.text = userDataModel.address.toString();
    _userPincodeController.text = userDataModel.postcode;
  }

  void _listenApiResponse() {
    StreamSubscription subscription;
    subscription = _controller.stream.listen((data) {
      if (data is LoginResponseModel) {
        if (data.status == 200) {
          writeStringDataLocally(key: userData, value: json.encode(data.user));
          TopAlert.showAlert(_scaffoldKey.currentState.context,
              AppLocalizations.of(context).translate("profile_updated"), false);
        }
      } else if (data is StateListResponse) {
        if (data.status == 200) {
          setState(() {
            stateList.clear();
            if (data.state.length > 0) {
              stateList.addAll(data.state);
              for (int i = 0; i < stateList.length; i++) {
                if (stateId == stateList[i].code) {
                  stateName = stateList[i].name;
                  _userStateController.text = stateName;
                  break;
                }
              }
            } else {
              stateName = userDataModel.state;
              _userStateController.text = stateName;
            }
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

  onImageClick() {
    if (imagePath != null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => PhotoViewer(imagePath, fit)),
      );
    }
  }

  void _openSearchScreen() async {
    var result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SearchCountry(countryList),
        ));
    if (result != null) {
      countryName = result.name;
      countryId = result.code;
      stateName = '';
      stateId = '';
      _userStateController.text = '';
      callApiGetState(countryId);
    }
  }

  void callApiGetState(countryId) {
    stateName = null;
    stateId = null;
    Map<dynamic, dynamic> mapName = Map();
    mapName.putIfAbsent('cookie', () => '$cookies');
    mapName.putIfAbsent('country_code', () => countryId);
    validation.stateApiCall(mapName, context);
  }

  _openStateList() async {
    var result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SearchState(stateList),
        ));
    if (result != null) {
      stateName = result.name;
      stateId = result.code;
    }
  }
}
