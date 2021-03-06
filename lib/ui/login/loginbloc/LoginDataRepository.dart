import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:footwork_chinese/constants/app_constants.dart';
import 'package:footwork_chinese/model/errorResponse/customeError.dart';
import 'package:footwork_chinese/network/ApiConfiguration.dart';
import 'package:footwork_chinese/network/ApiUrls.dart';
import 'package:footwork_chinese/network/api_callbacks.dart';
import 'package:footwork_chinese/utils/Utility.dart';
import 'package:footwork_chinese/utils/app_localizations.dart';

class LoginDataRepository {
  final ApiCallback apiCallback;

  LoginDataRepository(this.apiCallback);

  void onUserLogin(Map data, context) {
    checkInternetConnection().then((onValue) {
      !onValue
          ? apiCallback.onAPIError(
              CustomError(
                  AppLocalizations.of(context).translate('check_internet')),
              NO_INTERNET_FLAG)
          : _onLogin(data, context);
    });
  }

  void _onLogin(Map data, context) async {
    var language = await checkLanguage(context);
    var url = '';
    if (!baseUrl.contains('https://')) {
      url =
          '$baseUrl$loginUrl?insecure=cool&username=${data['username']}&password=${data['password']}&lang=$language';
    } else {
      url =
          '$baseUrl$loginUrl?username=${data['username']}&password=${data['password']}&lang=$language';
    }
    try {
      Dio()
          .get('$url')
          .then((response) {
            try {
              Map map = (response.data);
              if (map['status'] == 200) {
                try {
                  var url2 = '';
                  if (!baseUrl.contains('https://')) {
                    url2 =
                        '$baseUrl$getUserCurrentInfo?insecure=cool&cookie=${map['cookie']}&lang=$language';
                  } else {
                    url2 =
                        '$baseUrl$getUserCurrentInfo?cookie=${map['cookie']}&lang=$language';
                  }
                  ApiConfiguration.getInstance()
                      .apiClient
                      .liveService
                      .apiPostRequest(context, '$url2')
                      .then((response) {
                    try {
                      Map userResponseMap = jsonDecode(response.body);
                      if (userResponseMap['status'] == 200) {
                        userResponseMap.putIfAbsent(
                            "cookie", () => map['cookie']);
                        apiCallback.onAPISuccess(userResponseMap, LOGIN_FLAG);
                      } else {
                        apiCallback.onAPIError(userResponseMap, LOGIN_FLAG);
                      }
                    } catch (error) {
                      apiCallback.onAPIError(error, ERROR_EXCEPTION_FLAG);
                    }
                  });
                } catch (error) {
                  apiCallback.onAPIError(error, ERROR_EXCEPTION_FLAG);
                }
              } else {
                apiCallback.onAPIError(map, LOGIN_FLAG);
              }
            } catch (error) {
              apiCallback.onAPIError(error, ERROR_EXCEPTION_FLAG);
            }
          })
          .timeout(Duration(seconds: 100))
          .catchError((error) {
            apiCallback.onAPIError(error, ERROR_EXCEPTION_FLAG);
          });
    } catch (error) {
      apiCallback.onAPIError(error, ERROR_EXCEPTION_FLAG);
    }
  }
}
