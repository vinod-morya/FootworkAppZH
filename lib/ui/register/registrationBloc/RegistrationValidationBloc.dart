import 'dart:async';

import 'package:footwork_chinese/constants/app_constants.dart';
import 'package:footwork_chinese/model/errorResponse/customeError.dart';
import 'package:footwork_chinese/model/errorResponse/error_reponse.dart';
import 'package:footwork_chinese/model/loginResponse/LoginResponseModel.dart';
import 'package:footwork_chinese/network/api_callbacks.dart';
import 'package:footwork_chinese/ui/register/registrationBloc/RegisterDataRepository.dart';
import 'package:footwork_chinese/utils/Utility.dart';
import 'package:footwork_chinese/utils/validations.dart';
import 'package:rxdart/rxdart.dart';

class RegistrationValidationBloc with ApiCallback {
  final StreamController apiController;
  RegistrationDataRepository _dataProvider;

  RegistrationValidationBloc(this.apiController) {
    _dataProvider = RegistrationDataRepository(this);
  }

  StreamController<String> userNameController = BehaviorSubject<String>();

  Stream<String> get userNameStream => userNameController.stream;

  StreamController<String> _passController = BehaviorSubject<String>();

  Stream<String> get passStream => _passController.stream;

  StreamController<String> _emailController = BehaviorSubject<String>();

  Stream<String> get emailStream => _emailController.stream;

  StreamController<String> _firstNameController = BehaviorSubject<String>();

  Stream<String> get firstNameStream => _firstNameController.stream;

  StreamController<String> _lastNameController = BehaviorSubject<String>();

  Stream<String> get lastNameStream => _lastNameController.stream;

  StreamController<String> _confirmPassController = BehaviorSubject<String>();

  Stream<String> get confirmPassStream => _confirmPassController.stream;

  StreamController<bool> _progressLoaderController = BehaviorSubject<bool>();

  Stream<bool> get progressLoaderStream => _progressLoaderController.stream;

  Validations validations = Validations();

  void dispose() {
    userNameController.close();
    _passController.close();
    _emailController.close();
    _firstNameController.close();
    _lastNameController.close();
    _confirmPassController.close();
    _progressLoaderController.close();
  }

  String userNameValidation(userName, context, text) {
    var validationMessage = text == "first_name"
        ? validations.validateName(userName.toString().trim(), context, "first")
        : text == "last_name"
            ? validations.validateName(
                userName.toString().trim(), context, "last")
            : validations.validateUserName(userName.toString().trim(), context);
    if (validationMessage == null) {
      text == "first_name"
          ? _firstNameController.sink.add(userName)
          : text == "last_name"
              ? _lastNameController.sink.add(userName)
              : userNameController.sink.add(userName);
    } else {
      userNameController.sink
          .addError(CustomError(validationMessage.toString()));
    }
    return validationMessage;
  }

  String passValidation(password, context) {
    var validationMessage = validations.validatePassword(
        password.toString().trim(), 'registration', context);
    if (validationMessage == null) {
      _passController.sink.add(password);
    } else {
      _passController.sink.addError(CustomError(validationMessage.toString()));
    }
    return validationMessage;
  }

  String emailValidation(email, context) {
    var validationMessage =
        validations.validateEmail(email.toString().trim(), context);
    if (validationMessage == null) {
      _emailController.sink.add(email);
    } else {
      _emailController.sink.addError(CustomError(validationMessage.toString()));
    }
    return validationMessage;
  }

  void showProgressLoader(bool show) {
    if (!_progressLoaderController.isClosed) {
      _progressLoaderController.sink.add(show);
    }
  }

  submitRegistration(Map map, context) {
    showProgressLoader(true);
    _dataProvider.onUserRegistration(map, context);
  }

  @override
  void onAPISuccess(Map data, int flag) {
    showProgressLoader(false);
    if (flag == LOGIN_FLAG) {
      var registerResponse = LoginResponseModel.fromJson(data);
      if (registerResponse.status == 200) {
        writeStringDataLocally(key: cookie, value: registerResponse.cookie);
        writeBoolDataLocally(key: session, value: true);
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
      case REGISTER_FLAG:
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
