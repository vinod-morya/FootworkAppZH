library flutter_multiselect;

import 'package:flutter/material.dart';
import 'package:footwork_chinese/constants/app_colors.dart';
import 'package:footwork_chinese/constants/app_constants.dart';
import 'package:footwork_chinese/custom_widget/multipleSelect/selection_modal.dart';

class MultiSelect extends FormField<dynamic> {
  final String titleText;
  final String hintText;
  final bool required;
  final String errorText;
  final dynamic value;
  final bool filterable;
  final List dataSource;
  final String textField;
  final String valueField;
  final Function change;
  final Function open;
  final Function close;
  final Widget leading;
  final Widget trailing;
  final int maxLength;
  TextEditingController textEditingController = TextEditingController();

  MultiSelect(
      {FormFieldSetter<dynamic> onSaved,
      FormFieldValidator<dynamic> validator,
      dynamic initialValue,
      bool autovalidate = false,
      this.titleText = 'Title',
      this.hintText = 'Tap to select one or more...',
      this.required = false,
      this.errorText = 'Please select one or more option(s)',
      this.value,
      this.leading,
      this.filterable = true,
      this.dataSource,
      this.textField,
      this.valueField,
      this.change,
      this.open,
      this.close,
      this.trailing,
      this.maxLength})
      : super(
            onSaved: onSaved,
            validator: validator,
            initialValue: initialValue,
            autovalidate: autovalidate,
            builder: (FormFieldState<dynamic> state) {
              List<Widget> _buildSelectedOptions(dynamic values, state) {
                List<Widget> selectedOptions = [];

                if (values != null) {
                  values.forEach((item) {
                    var existingItem = dataSource.singleWhere(
                        (itm) => itm[valueField] == item,
                        orElse: () => null);
                    if (existingItem != null) {
                      selectedOptions.add(Chip(
                        label: Text(existingItem[textField],
                            overflow: TextOverflow.ellipsis),
                      ));
                    }
                  });
                }

                return selectedOptions;
              }

              return InkWell(
                onTap: () async {
                  var results = await Navigator.push(
                      state.context,
                      MaterialPageRoute<dynamic>(
                        builder: (BuildContext context) => SelectionModal(
                            title: titleText,
                            filterable: filterable,
                            valueField: valueField,
                            textField: textField,
                            dataSource: dataSource,
                            values: state.value ?? [],
                            maxLength: maxLength ?? dataSource?.length),
                        fullscreenDialog: false,
                      ));

                  if (results != null) {
                    dynamic newValue;
                    if (results.length > 0) {
                      newValue = results;
                    }
                    state.didChange(newValue);
                    if (change != null) {
                      change(newValue);
                    }
                  }
                },
                child: Padding(
                  padding: EdgeInsets.only(bottom: 20.0),
                  child: TextField(
                    cursorColor: colorGrey,
                    enabled: false,
                    readOnly: true,
                    keyboardAppearance: Brightness.light,
                    style:
                        TextStyle(color: colorBlack, fontFamily: regularFont),
                    textInputAction: null,
                    keyboardType: null,
                    decoration: InputDecoration(
                        hintText: hintText.contains("*")
                            ? hintText.substring(0, hintText.length - 1)
                            : hintText,
                        labelText: hintText,
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 15.0, horizontal: 40.0),
                        hintStyle: TextStyle(color: colorGrey),
                        labelStyle: TextStyle(color: colorGrey),
                        alignLabelWithHint: true,
                        enabledBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(25.0)),
                            borderSide: BorderSide(color: colorGrey)),
                        disabledBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(25.0)),
                            borderSide: BorderSide(color: colorGrey)),
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(25.0)),
                            borderSide: BorderSide(color: colorGrey)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(25.0)),
                            borderSide: BorderSide(color: colorGrey)),
                        suffixIcon: Icon(Icons.arrow_drop_down)),
                  ),
                ),
              );
            });
}
