import 'dart:async';

import 'package:footwork_chinese/constants/app_constants.dart';
import 'package:footwork_chinese/model/StateListResponse.dart';
import 'package:footwork_chinese/model/errorResponse/error_reponse.dart';
import 'package:footwork_chinese/model/loginResponse/LoginResponseModel.dart';
import 'package:footwork_chinese/network/api_callbacks.dart';
import 'package:footwork_chinese/ui/editProfile/profileBloc/EditProfileDataRepository.dart';
import 'package:footwork_chinese/utils/validations.dart';
import 'package:rxdart/rxdart.dart';

class EditProfileValidationBloc with ApiCallback {
  final StreamController apiController;
  EditProfileDataRepository _dataProvider;

  EditProfileValidationBloc(this.apiController) {
    _dataProvider = EditProfileDataRepository(this);
  }

  StreamController<bool> _progressLoaderController = BehaviorSubject<bool>();

  Stream<bool> get progressLoaderStream => _progressLoaderController.stream;

  Validations validations = Validations();

  void dispose() {
    _progressLoaderController.close();
  }

  String userNameValidation(userName, context, text) {
    var validationMessage = text == "first_name"
        ? validations.validateName(userName.toString().trim(), context)
        : text == "last_name"
            ? validations.validateName(userName.toString().trim(), context)
            : validations.validateUserName(userName.toString().trim(), context);
    return validationMessage;
  }

  String emailValidation(email, context) {
    var validationMessage =
        validations.validateEmail(email.toString().trim(), context);
    return validationMessage;
  }

  void showProgressLoader(bool show) {
    if (!_progressLoaderController.isClosed) {
      _progressLoaderController.sink.add(show);
    }
  }

  updateData(Map map, context) {
    showProgressLoader(true);
    _dataProvider.onProfileSubmit(map, context);
  }

  stateApiCall(Map map, context) {
    showProgressLoader(true);
    _dataProvider.onStateApiCall(map, context);
  }

  @override
  void onAPISuccess(Map data, int flag) {
    showProgressLoader(false);
    if (flag == UPDATE_PROFILE_FLAG) {
      var registerResponse = LoginResponseModel.fromJson(data);
      if (registerResponse.status == 200) {
        if (!apiController.isClosed) {
          apiController.add(registerResponse);
        }
      }
    } else if (flag == STATE_LIST) {
      var registerResponse = StateListResponse.fromJson(data);
      if (registerResponse.status == 200) {
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
      case STATE_LIST:
        var errorResponse = ErrorResponse.fromJson(error);
        if (!apiController.isClosed) {
          apiController.add(errorResponse);
        }
        break;
      case UPDATE_PROFILE_FLAG:
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
