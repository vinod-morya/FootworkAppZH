import 'dart:async';

import 'package:flutter/src/widgets/framework.dart';
import 'package:footwork_chinese/constants/app_constants.dart';
import 'package:footwork_chinese/model/CountryListResponse.dart';
import 'package:footwork_chinese/model/commonReponse/commonResponse.dart';
import 'package:footwork_chinese/model/errorResponse/error_reponse.dart';
import 'package:footwork_chinese/model/userDashBoardResponse/UserDashBoardResponse.dart';
import 'package:footwork_chinese/network/api_callbacks.dart';
import 'package:footwork_chinese/ui/userDashBoard/DashboardBloc/DashBoardDataRepository.dart';
import 'package:rxdart/rxdart.dart';

class DashBoardBloc with ApiCallback {
  final StreamController apiController;
  final StreamController apiSuccessResponseController;
  DashBoardDataRepository _dataProvider;

  DashBoardBloc(this.apiController, this.apiSuccessResponseController) {
    _dataProvider = DashBoardDataRepository(this);
  }

  StreamController<bool> _progressLoaderController = BehaviorSubject<bool>();

  Stream<bool> get progressLoaderStream => _progressLoaderController.stream;

  void dispose() {
    _progressLoaderController.close();
  }

  void showProgressLoader(bool show) {
    if (!_progressLoaderController.isClosed) {
      _progressLoaderController.sink.add(show);
    }
  }

  getCountryCode(Map map, context) {
    showProgressLoader(true);
    _dataProvider.onGetCountry(map, context);
  }

  apiCall(Map map, context) {
    showProgressLoader(true);
    _dataProvider.onFetchData(map, context);
  }

  @override
  void onAPISuccess(Map data, int flag) {
    showProgressLoader(false);
    if (flag == DASHBOARD_API_FLAG) {
      var registerResponse = UserDashBoardResponse.fromJson(data);
      if (registerResponse.status == 200) {
        if (!apiController.isClosed) {
          apiController.add(registerResponse);
          apiSuccessResponseController.add(registerResponse.data);
//          print('responseParsed and loaded to stream ${new DateTime.now()}');
        }
      }
    } else if (flag == COUNTRY_LIST) {
      var response = CountryListResponse.fromJson(data);
      if (response.status == 200) {
        if (!apiController.isClosed) {
          apiController.add(response);
        }
      }
    } else if (flag == UPDATE_PAYMENT) {
      var response = CommonResponse.fromJson(data);
      if (response.status == 200) {
        if (!apiController.isClosed) {
          apiController.add(response);
        }
      }
    }
  }

  @override
  void onAPIError(error, int flag) {
    showProgressLoader(false);
    switch (flag) {
      case COUNTRY_LIST:
        var errorResponse = ErrorResponse.fromJson(error);
        if (!apiController.isClosed) {
          apiController.add(errorResponse);
        }
        break;
      case UPDATE_PAYMENT:
        var errorResponse = ErrorResponse.fromJson(error);
        errorResponse.code = UPDATE_PAYMENT;
        if (!apiController.isClosed) {
          apiController.add(errorResponse);
        }
        break;
      case DASHBOARD_API_FLAG:
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

  void purchasedMonthUpdate(
      BuildContext context, Map<String, dynamic> request) {
    showProgressLoader(true);
    _dataProvider.posUpdateMonth(request, context);
  }
}
