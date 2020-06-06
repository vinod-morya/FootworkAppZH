import 'dart:convert';

import 'package:footwork_chinese/constants/app_constants.dart';
import 'package:footwork_chinese/model/errorResponse/customeError.dart';
import 'package:footwork_chinese/network/ApiConfiguration.dart';
import 'package:footwork_chinese/network/ApiUrls.dart';
import 'package:footwork_chinese/network/api_callbacks.dart';
import 'package:footwork_chinese/utils/Utility.dart';
import 'package:footwork_chinese/utils/app_localizations.dart';

class ForgetPassDataRepository {
  final ApiCallback apiCallback;

  ForgetPassDataRepository(this.apiCallback);

  void onForgetPass(Map data, context) {
    checkInternetConnection().then((onValue) {
      !onValue
          ? apiCallback.onAPIError(
              CustomError(
                  AppLocalizations.of(context).translate('check_internet')),
              NO_INTERNET_FLAG)
          : _onForgetPass(data, context);
    });
  }

  void _onForgetPass(Map data, context) async {
    var language = await checkLanguage(context);
    var url = '';
    if (!baseUrl.contains('https://')) {
      url =
          '$baseUrl$forgetPasswordUrl?insecure=cool&user_login=${data['user_name']}&lang=$language';
    } else {
      url =
          '$baseUrl$forgetPasswordUrl?user_login=${data['user_name']}&lang=$language';
    }
    try {
      ApiConfiguration.getInstance()
          .apiClient
          .liveService
          .apiGetRequest(context, '$url')
          .then((response) {
        try {
          Map map = jsonDecode(response.body);
          if (map['status'] == 200) {
            apiCallback.onAPISuccess(map, FORGOT_FLAG);
          } else {
            apiCallback.onAPIError(map, FORGOT_FLAG);
          }
        } catch (error) {
          apiCallback.onAPIError(error, ERROR_EXCEPTION_FLAG);
        }
      });
    } catch (error) {
      apiCallback.onAPIError(error, ERROR_EXCEPTION_FLAG);
    }
  }
}
