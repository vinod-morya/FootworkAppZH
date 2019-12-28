import 'dart:async';

import 'package:footwork_chinese/constants/app_constants.dart';
import 'package:footwork_chinese/model/errorResponse/customeError.dart';
import 'package:footwork_chinese/model/errorResponse/error_reponse.dart';
import 'package:footwork_chinese/model/loginResponse/LoginResponseModel.dart';
import 'package:footwork_chinese/network/api_callbacks.dart';
import 'package:footwork_chinese/ui/login/loginbloc/LoginDataRepository.dart';
import 'package:footwork_chinese/utils/Utility.dart';
import 'package:footwork_chinese/utils/validations.dart';
import 'package:rxdart/rxdart.dart';

class LoginValidationBloc with ApiCallback {
  final StreamController apiController;
  String _userName, _password;
  LoginDataRepository _dataProvider;

  LoginValidationBloc(this.apiController) {
    _dataProvider = LoginDataRepository(this);
  }

  StreamController<String> userNameController = BehaviorSubject<String>();

  Stream<String> get userNameStream => userNameController.stream;

  StreamController<String> _passController = BehaviorSubject<String>();

  Stream<String> get passStream => _passController.stream;

  StreamController<bool> _progressLoaderController = BehaviorSubject<bool>();

  Stream<bool> get progressLoaderStream => _progressLoaderController.stream;

  Validations validations = Validations();

  void dispose() {
    userNameController.close();
    _passController.close();
    _progressLoaderController.close();
  }

  String userNameValidation(userName, context) {
    this._userName = userName;
    var validationMessage =
        validations.validateUserName(userName.toString().trim(), context);
    if (validationMessage == null) {
      userNameController.sink.add(userName);
    } else {
      userNameController.sink
          .addError(CustomError(validationMessage.toString()));
    }
    return validationMessage;
  }

  String passValidation(password, context) {
    this._password = password;
    var validationMessage = validations.validatePassword(
        password.toString().trim(), 'login', context);
    if (validationMessage == null) {
      _passController.sink.add(password);
    } else {
      _passController.sink.addError(CustomError(validationMessage.toString()));
    }
    return validationMessage;
  }

  void showProgressLoader(bool show) {
    if (!_progressLoaderController.isClosed) {
      _progressLoaderController.sink.add(show);
    }
  }

  submitLogin(Map map, context) {
    showProgressLoader(true);
    map.putIfAbsent('username', () => _userName);
    map.putIfAbsent('password', () => _password);
    _dataProvider.onUserLogin(map, context);
  }

  @override
  void onAPISuccess(Map data, int flag) {
    showProgressLoader(false);
    if (flag == LOGIN_FLAG) {
      var registerResponse = LoginResponseModel.fromJson(data);
      if (registerResponse.status == 200) {
        writeBoolDataLocally(key: session, value: true);
        writeStringDataLocally(key: cookie, value: registerResponse.cookie);
        if (!apiController.isClosed) {
          apiController.add(registerResponse);
        }
      }
    }
  }

  @override
  void onAPIError(error, int flag) {
    showProgressLoader(false);
    switch (flag) {
      case LOGIN_FLAG:
        var errorResponse = ErrorResponse.fromJson(error);
        if (!apiController.isClosed) {
          apiController.add(errorResponse);
        }
        break;
      case ERROR_EXCEPTION_FLAG:
        showProgressLoader(false);
        if (!apiController.isClosed) {
          apiController.add(Exception());
        }
        break;
      case NO_INTERNET_FLAG:
        if (!apiController.isClosed) {
          apiController.add(error);
        }
        break;
    }
  }
}
