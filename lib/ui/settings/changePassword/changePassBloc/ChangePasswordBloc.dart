import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:footwork_chinese/constants/app_constants.dart';
import 'package:footwork_chinese/model/commonReponse/commonResponse.dart';
import 'package:footwork_chinese/model/errorResponse/customeError.dart';
import 'package:footwork_chinese/model/errorResponse/error_reponse.dart';
import 'package:footwork_chinese/network/api_callbacks.dart';
import 'package:footwork_chinese/utils/app_localizations.dart';
import 'package:footwork_chinese/utils/validations.dart';
import 'package:rxdart/rxdart.dart';

import 'ChangePassDataRepository.dart';

class ChangePasswordBloc with ApiCallback {
  ChangePassDataRepository _dataProvider;
  String _newPassword, _confirmPassword;

  StreamController apiResponseController;

  ChangePasswordBloc(this.apiResponseController) {
    _dataProvider = ChangePassDataRepository(this);
  }

  Validations validations = Validations();

  StreamController<bool> _progressLoaderController = BehaviorSubject<bool>();

  Stream<bool> get progressLoaderStream => _progressLoaderController.stream;

  StreamController<String> _oldPassController = BehaviorSubject<String>();

  Stream<String> get oldPassStream => _oldPassController.stream;

  StreamController<String> _newPassController = BehaviorSubject<String>();

  Stream<String> get newPasswordStream => _newPassController.stream;

  StreamController<String> _confirmPassController = BehaviorSubject<String>();

  Stream<String> get confirmPassWordStream => _confirmPassController.stream;

  void showProgressLoader(bool show) {
    if (!apiResponseController.isClosed) {
      _progressLoaderController.sink.add(show);
    }
  }

  String newPassValidation(password, context) {
    this._newPassword = password;
    var validationMessage = validations.validatePassword(
        password.toString().trim(), "new", context);
    if (validationMessage == null) {
      _newPassController.sink.add(password);
    } else {
      _newPassController.sink
          .addError(CustomError(validationMessage.toString()));
    }
    return validationMessage;
  }

  String confirmPassValidation(password, context) {
    this._confirmPassword = password;
    var validationMessage;
    if (_confirmPassword.isEmpty) {
      validationMessage =
          AppLocalizations.of(context).translate("confirm_pass_empty");
    } else {
      if (_confirmPassword == _newPassword) {
        _newPassController.sink.add(password);
        validationMessage = null;
      } else {
        validationMessage =
            AppLocalizations.of(context).translate("pass_match");
      }
    }
    return validationMessage;
  }

  @override
  void onAPIError(error, int flag) {
    showProgressLoader(false);
    switch (flag) {
      case CHANGE_PASS_FLAG:
        var errorResponse = ErrorResponse.fromJson(error);
        if (!apiResponseController.isClosed) {
          apiResponseController.add(errorResponse);
        }
        break;
      case ERROR_EXCEPTION_FLAG:
        showProgressLoader(false);
        if (!apiResponseController.isClosed) {
          apiResponseController.add(Exception());
        }
        break;
      case NO_INTERNET_FLAG:
        if (!apiResponseController.isClosed) {
          apiResponseController.add(error);
        }
        break;
    }
  }

  @override
  void onAPISuccess(Map data, int flag) {
    showProgressLoader(false);
    if (flag == CHANGE_PASS_FLAG) {
      var registerResponse = CommonResponse.fromJson(data);
      if (registerResponse.status == 200) {
        if (!apiResponseController.isClosed) {
          apiResponseController.add(registerResponse);
        }
      }
    }
  }

  void callApiChangePass(Map map, BuildContext context) {
    showProgressLoader(true);
    _dataProvider.changePassword(map, context);
  }
}
