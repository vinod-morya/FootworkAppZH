import 'dart:convert';

import 'package:footwork_chinese/constants/app_constants.dart';
import 'package:footwork_chinese/model/errorResponse/customeError.dart';
import 'package:footwork_chinese/network/ApiConfiguration.dart';
import 'package:footwork_chinese/network/ApiUrls.dart';
import 'package:footwork_chinese/network/api_callbacks.dart';
import 'package:footwork_chinese/utils/Utility.dart';
import 'package:footwork_chinese/utils/app_localizations.dart';

class RegistrationDataRepository {
  final ApiCallback apiCallback;

  RegistrationDataRepository(this.apiCallback);

  void onUserRegistration(Map data, context) {
    checkInternetConnection().then((onValue) {
      !onValue
          ? apiCallback.onAPIError(
              CustomError(
                  AppLocalizations.of(context).translate('check_internet')),
              NO_INTERNET_FLAG)
          : _onRegistration(data, context);
    });
  }

  void _onRegistration(Map data, context) async {
    var language =  checkLanguage();
    if (!baseUrl.contains('https://')) {
      data.putIfAbsent("insecure", () => "cool");
    }
    var url = '';
    if (!baseUrl.contains('https://')) {
      url = '$baseUrl$getNonceKey&insecure=cool';
    } else {
      url = '$baseUrl$getNonceKey';
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
            data.putIfAbsent('nonce', () => map['nonce']);
            data.putIfAbsent('notify', () => 'both');
            data.putIfAbsent('display_name',
                () => '${data['first_name']} ${data['last_name']}');
            data.putIfAbsent('lang', () => '$language');
            data.putIfAbsent('app_type', () => '1');
            if (!baseUrl.contains('https://')) {
              data.putIfAbsent("insecure", () => "cool");
            }
            try {
              ApiConfiguration.getInstance()
                  .apiClient
                  .liveService
                  .apiMultipartRequest(
                      context, '$baseUrl$register', data, 'POST')
                  .then((response) {
                try {
                  Map map = jsonDecode(response.body);
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
                            apiCallback.onAPISuccess(
                                userResponseMap, REGISTER_FLAG);
                          } else {
                            apiCallback.onAPIError(
                                userResponseMap, REGISTER_FLAG);
                          }
                        } catch (error) {
                          apiCallback.onAPIError(error, ERROR_EXCEPTION_FLAG);
                        }
                      });
                    } catch (error) {
                      apiCallback.onAPIError(error, ERROR_EXCEPTION_FLAG);
                    }
                  } else {
                    apiCallback.onAPIError(map, REGISTER_FLAG);
                  }
                } catch (error) {
                  apiCallback.onAPIError(error, ERROR_EXCEPTION_FLAG);
                }
              });
            } catch (error) {
              apiCallback.onAPIError(error, ERROR_EXCEPTION_FLAG);
            }
          } else {
            apiCallback.onAPIError(map, REGISTER_FLAG);
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
