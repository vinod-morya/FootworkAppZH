import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:fm_fit/fm_fit.dart';
import 'package:footwork_chinese/constants/app_colors.dart';
import 'package:footwork_chinese/constants/app_constants.dart';
import 'package:footwork_chinese/constants/app_images_path.dart';
import 'package:footwork_chinese/custom_widget/TextField/CustomInputField.dart';
import 'package:footwork_chinese/utils/app_localizations.dart';

class InviteUser extends StatefulWidget {
  final okBtnFunction;
  final okBtnTxt;
  final inviteText;

  InviteUser(this.okBtnFunction, this.okBtnTxt, this.inviteText);

  @override
  _AddEditNotesState createState() => _AddEditNotesState();
}

class _AddEditNotesState extends State<InviteUser> {
  String data = '';
  var _inputFieldController = TextEditingController();
  FmFit fit = FmFit(width: 750);

  @override
  void initState() {
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
    return Container(
        width: fit.t(MediaQuery.of(context).size.width),
        padding: EdgeInsets.symmetric(
            horizontal: fit.t(40.0), vertical: fit.t(24.0)),
        margin: EdgeInsets.only(top: fit.t(50.0), bottom: fit.t(50.0)),
        child: Stack(
          children: <Widget>[
            ListView(
              children: <Widget>[
                Image.asset(
                  ic_app_icon,
                  scale: fit.scale == 1 ? 3.0 : 2.0,
                  color: Colors.white,
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(fit.t(5.0)),
                    color: Colors.white,
                  ),
                  margin: EdgeInsets.only(
                      top: fit.t(30.0), left: fit.t(10.0), right: fit.t(10.0)),
                  width: fit.t(MediaQuery.of(context).size.width),
                  child: Column(
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(fit.t(4.0)),
                              topRight: Radius.circular(fit.t(4.0))),
                          color: btnAppColor,
                        ),
                        height: fit.t(50.0),
                        child: Center(
                          child: Icon(
                            Icons.person_add,
                            color: Colors.white,
                            size: fit.t(30.0),
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(fit.t(4.0)),
                              bottomRight: Radius.circular(fit.t(4.0))),
                          color: Colors.white,
                        ),
                        child: Column(
                          children: <Widget>[
                            ListView(
                              shrinkWrap: true,
                              physics: BouncingScrollPhysics(),
                              children: <Widget>[
                                Center(
                                  child: Container(
                                    padding: EdgeInsets.all(fit.t(16.0)),
                                    child: Text(
                                      '${widget.inviteText}',
                                      style: TextStyle(
                                        color: Color(0xFF96989d),
                                        fontFamily: regularFont,
                                        fontSize: fit.t(16.0),
                                        fontWeight: FontWeight.normal,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(
                                      top: fit.t(10.0),
                                      left: fit.t(15.0),
                                      right: fit.t(15.0)),
                                  child: CustomInputField(
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(
                                          emailLength)
                                    ],
                                    suffixIcon: null,
                                    icon: ic_email,
                                    imgHeight: fit.t(25.0),
                                    imgWidth: fit.t(30.0),
                                    iconColor: appColor,
                                    inputAction: TextInputAction.done,
                                    obscureText: false,
                                    controller: _inputFieldController,
                                    enabled: true,
                                    textInputType: TextInputType.emailAddress,
                                    textStyle: TextStyle(
                                        color: colorBlack,
                                        fontFamily: robotoBoldFont),
                                    hintText: AppLocalizations.of(context)
                                        .translate("email"),
                                    hintStyle: TextStyle(
                                        color: colorGrey,
                                        fontFamily: robotoBoldFont),
                                  ),
                                ),
                                _bottomLine()
                              ],
                            ),
                            GestureDetector(
                              onTap: () => widget.okBtnFunction(data),
                              child: Container(
                                margin: EdgeInsets.symmetric(
                                    horizontal: fit.t(24.0),
                                    vertical: fit.t(20.0)),
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.circular(fit.t(24.0)),
                                    color: btnAppColor),
                                height: fit.t(35.0),
                                child: Center(
                                  child: Container(
                                    padding: EdgeInsets.only(
                                        top: fit.t(4.0), bottom: fit.t(4.0)),
                                    child: Text(widget.okBtnTxt,
                                        style: TextStyle(
                                            fontSize: fit.t(12.0),
                                            fontFamily: robotoMediumFont,
                                            color: Colors.white)),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
            Positioned(
              right: 0,
              top: fit.t(55.0),
              child: GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                  height: fit.t(30.0),
                  width: fit.t(30.0),
                  child: Icon(
                    Icons.close,
                    color: appColor,
                    size: fit.t(15.0),
                  ),
                  decoration:
                      BoxDecoration(shape: BoxShape.circle, color: colorWhite),
                ),
              ),
            ),
          ],
        ));
  }

  _onvalueChange(String value) {
    data = value;
  }

  Widget _bottomLine() {
    return Container(
      margin: EdgeInsets.only(left: fit.t(15.0), right: fit.t(15.0)),
      height: fit.t(1.0),
      width: fit.t(MediaQuery.of(context).size.width),
      color: appColor,
    );
  }
}
