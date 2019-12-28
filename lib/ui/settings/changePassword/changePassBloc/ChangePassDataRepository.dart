import 'dart:convert';

import 'package:footwork_chinese/constants/app_constants.dart';
import 'package:footwork_chinese/model/errorResponse/customeError.dart';
import 'package:footwork_chinese/network/ApiConfiguration.dart';
import 'package:footwork_chinese/network/ApiUrls.dart';
import 'package:footwork_chinese/network/api_callbacks.dart';
import 'package:footwork_chinese/utils/Utility.dart';
import 'package:footwork_chinese/utils/app_localizations.dart';

class ChangePassDataRepository {
  final ApiCallback apiCallback;

  ChangePassDataRepository(this.apiCallback);

  void _changePassword(Map data, context) async {
    var language = await checkLanguage(context);
    var url = '';
    if (!baseUrl.contains('https://')) {
      url =
          '$baseUrl$changePassApiUrl?insecure=cool&cookie=${data['cookie']}&password=${data['password']}&lang=$language';
    } else {
      url =
          '$baseUrl$changePassApiUrl?cookie=${data['cookie']}&password=${data['password']}&lang=$language';
    }
    try {
      ApiConfiguration.getInstance()
          .apiClient
          .liveService
          .apiPostRequest(context, '$url')
          .then((response) {
        try {
          Map map = jsonDecode(response.body);
          if (map['status'] == 200) {
            apiCallback.onAPISuccess(map, CHANGE_PASS_FLAG);
          } else {
            apiCallback.onAPIError(map, CHANGE_PASS_FLAG);
          }
        } catch (error) {
          apiCallback.onAPIError(error, ERROR_EXCEPTION_FLAG);
        }
      });
    } catch (error) {
      apiCallback.onAPIError(error, ERROR_EXCEPTION_FLAG);
    }
  }

  void changePassword(Map map, context) {
    checkInternetConnection().then((onValue) {
      !onValue
          ? apiCallback.onAPIError(
              CustomError(
                  AppLocalizations.of(context).translate('check_internet')),
              NO_INTERNET_FLAG)
          : _changePassword(map, context);
    });
  }
}
