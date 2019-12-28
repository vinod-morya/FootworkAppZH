import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fm_fit/fm_fit.dart';
import 'package:footwork_chinese/constants/app_colors.dart';
import 'package:footwork_chinese/constants/app_constants.dart';
import 'package:footwork_chinese/constants/app_images_path.dart';
import 'package:footwork_chinese/utils/app_localizations.dart';
import 'package:footwork_chinese/utils/date_formatter.dart';

class AddEditNotes extends StatefulWidget {
  final icon;
  final okBtnFunction;
  final okBtnTxt;
  final date;
  final noteText;

  AddEditNotes(
      this.icon, this.okBtnFunction, this.okBtnTxt, this.date, this.noteText);

  @override
  _AddEditNotesState createState() => _AddEditNotesState();
}

class _AddEditNotesState extends State<AddEditNotes> {
  String data = '';
  var _inputFieldController = TextEditingController();
  FmFit fit = FmFit(width: 750);

  @override
  void initState() {
    _inputFieldController.text = widget.noteText;
    data = widget.noteText;
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
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(horizontal: fit.t(40.0), vertical: 0.0),
        margin: EdgeInsets.only(top: fit.t(50.0), bottom: 0.0),
        child: Stack(
          children: <Widget>[
            ListView(
              physics: NeverScrollableScrollPhysics(),
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
                  width: MediaQuery.of(context).size.width,
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
                          child: widget.icon == null
                              ? Icon(
                                  Icons.check,
                                  color: Colors.white,
                                )
                              : Image.asset(
                                  widget.icon,
                                  color: colorWhite,
                                  height: fit.t(30.0),
                                  width: fit.t(20.0),
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
                            Container(
                              padding: EdgeInsets.all(fit.t(10.0)),
                              child: RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                  text:
                                      '${widget.date == '' ? '' : AppLocalizations.of(context).translate("last_edited")}',
                                  style: TextStyle(
                                      fontSize: fit.t(8.0),
                                      color: Color(0xFF96989d),
                                      fontFamily: robotoMediumFont,
                                      fontWeight: FontWeight.bold),
                                  children: <TextSpan>[
                                    TextSpan(
                                      text:
                                          ' ${widget.date == '' ? '' : getDate(widget.date, 'MMMM dd, yyyy')}',
                                      style: TextStyle(
                                          color: appColor,
                                          fontSize: fit.t(8.0),
                                          fontFamily: regularFont,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SingleChildScrollView(
                              child: Container(
                                height: MediaQuery.of(context).size.height / 3,
                                padding: EdgeInsets.only(
                                    left: fit.t(24.0),
                                    right: fit.t(24.0),
                                    top: 0.0,
                                    bottom: fit.t(8.0)),
                                child: TextField(
                                  controller: _inputFieldController,
                                  cursorWidth: fit.t(1.0),
                                  cursorColor: appColor,
                                  onChanged: _onvalueChange,
                                  autofocus: false,
                                  maxLines: null,
                                  minLines: null,
                                  expands: true,
                                  enableInteractiveSelection: false,
                                  maxLength: 1000,
                                  textAlign: TextAlign.start,
                                  keyboardType: TextInputType.text,
                                  textInputAction: TextInputAction.done,
                                  keyboardAppearance: Brightness.light,
                                  textCapitalization:
                                      TextCapitalization.sentences,
                                  decoration: InputDecoration(
                                      hintMaxLines: 1,
                                      border: InputBorder.none,
                                      hoverColor: colorWhite,
                                      focusColor: colorWhite,
                                      fillColor: colorWhite,
                                      hintText: AppLocalizations.of(context)
                                          .translate("start_note"),
                                      hintStyle: TextStyle(
                                          color: Color(0x9996989d),
                                          fontFamily: regularFont,
                                          fontSize: fit.t(18.0))),
                                  style: TextStyle(
                                    color: colorGrey,
                                    fontFamily: regularFont,
                                    fontSize: fit.t(18.0),
                                  ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () => widget.okBtnFunction(data),
                              child: Container(
                                margin: EdgeInsets.symmetric(
                                    horizontal: fit.t(24.0),
                                    vertical: fit.t(10.0)),
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
}
