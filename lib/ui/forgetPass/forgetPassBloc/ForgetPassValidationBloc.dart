import 'dart:async';

import 'package:footwork_chinese/constants/app_constants.dart';
import 'package:footwork_chinese/model/commonReponse/commonResponse.dart';
import 'package:footwork_chinese/model/errorResponse/customeError.dart';
import 'package:footwork_chinese/model/errorResponse/error_reponse.dart';
import 'package:footwork_chinese/network/api_callbacks.dart';
import 'package:footwork_chinese/ui/forgetPass/forgetPassBloc/ForgetPassDataRepository.dart';
import 'package:footwork_chinese/utils/validations.dart';
import 'package:rxdart/rxdart.dart';

class ForgetPassValidationBloc with ApiCallback {
  final StreamController apiController;
  ForgetPassDataRepository _dataProvider;

  ForgetPassValidationBloc(this.apiController) {
    _dataProvider = ForgetPassDataRepository(this);
  }

  StreamController<String> userNameController = BehaviorSubject<String>();

  Stream<String> get userNameStream => userNameController.stream;

  StreamController<bool> _progressLoaderController = BehaviorSubject<bool>();

  Stream<bool> get progressLoaderStream => _progressLoaderController.stream;

  Validations validations = Validations();

  void dispose() {
    userNameController.close();
    _progressLoaderController.close();
  }

  String userNameValidation(userName, context) {
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

  void showProgressLoader(bool show) {
    if (!_progressLoaderController.isClosed) {
      _progressLoaderController.sink.add(show);
    }
  }

  submitForgetPass(Map map, context) {
    showProgressLoader(true);
    _dataProvider.onForgetPass(map, context);
  }

  @override
  void onAPISuccess(Map data, int flag) {
    showProgressLoader(false);
    if (flag == FORGOT_FLAG) {
      var registerResponse = CommonResponse.fromJson(data);
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
      case FORGOT_FLAG:
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
