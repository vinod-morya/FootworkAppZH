import 'dart:convert';

import 'package:footwork_chinese/constants/app_constants.dart';
import 'package:footwork_chinese/model/errorResponse/customeError.dart';
import 'package:footwork_chinese/network/ApiConfiguration.dart';
import 'package:footwork_chinese/network/ApiUrls.dart';
import 'package:footwork_chinese/network/api_callbacks.dart';
import 'package:footwork_chinese/utils/Utility.dart';
import 'package:footwork_chinese/utils/app_localizations.dart';

class EditProfileDataRepository {
  final ApiCallback apiCallback;

  EditProfileDataRepository(this.apiCallback);

  void onProfileSubmit(Map data, context) {
    checkInternetConnection().then((onValue) {
      !onValue
          ? apiCallback.onAPIError(
              CustomError(
                  AppLocalizations.of(context).translate('check_internet')),
              NO_INTERNET_FLAG)
          : _onProfileSubmit(data, context);
    });
  }

  void onStateApiCall(Map data, context) {
    checkInternetConnection().then((onValue) {
      !onValue
          ? apiCallback.onAPIError(
              CustomError(
                  AppLocalizations.of(context).translate('check_internet')),
              NO_INTERNET_FLAG)
          : _onStateApiCall(data, context);
    });
  }

  void _onProfileSubmit(Map data, context) async {
    var language =  checkLanguage();
    data.putIfAbsent('lang', () => language);
    data.putIfAbsent(
        'display_name', () => '${data['first_name']} ${data['last_name']}');
    if (!baseUrl.contains('https://')) {
      data.putIfAbsent("insecure", () => "cool");
    }
    try {
      ApiConfiguration.getInstance()
          .apiClient
          .liveService
          .apiMultipartRequest(context, '$baseUrl$updateProfile', data, 'POST')
          .then((response) {
        try {
          Map map = jsonDecode(response.body);
          if (map['status'] == 200) {
            var url2 = '';
            if (!baseUrl.contains('https://')) {
              url2 =
                  '$baseUrl$getUserCurrentInfo?insecure=cool&cookie=${data['cookie']}&lang=$language';
            } else {
              url2 =
                  '$baseUrl$getUserCurrentInfo?cookie=${data['cookie']}&lang=$language';
            }
            try {
              ApiConfiguration.getInstance()
                  .apiClient
                  .liveService
                  .apiPostRequest(context, '$url2')
                  .then((response) {
                try {
                  Map userResponseMap = jsonDecode(response.body);
                  if (userResponseMap['status'] == 200) {
                    userResponseMap.putIfAbsent("cookie", () => data['cookie']);
                    apiCallback.onAPISuccess(
                        userResponseMap, UPDATE_PROFILE_FLAG);
                  } else {
                    apiCallback.onAPIError(
                        userResponseMap, UPDATE_PROFILE_FLAG);
                  }
                } catch (error) {
                  apiCallback.onAPIError(error, ERROR_EXCEPTION_FLAG);
                }
              });
            } catch (error) {
              apiCallback.onAPIError(error, ERROR_EXCEPTION_FLAG);
            }
          } else {
            apiCallback.onAPIError(map, UPDATE_PROFILE_FLAG);
          }
        } catch (error) {
          apiCallback.onAPIError(error, ERROR_EXCEPTION_FLAG);
        }
      });
    } catch (error) {
      apiCallback.onAPIError(error, ERROR_EXCEPTION_FLAG);
    }
  }

  _onStateApiCall(Map map, context) async {
    var language =  checkLanguage();
    var url = '';
    if (!baseUrl.contains('https://')) {
      url =
          '$baseUrl$getStateList?insecure=cool&cookie=${map['cookie']}&country_code=${map['country_code']}&lang=$language';
    } else {
      url =
          '$baseUrl$getStateList?cookie=${map['cookie']}&country_code=${map['country_code']}&lang=$language';
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
            apiCallback.onAPISuccess(map, STATE_LIST);
          } else {
            apiCallback.onAPIError(map, STATE_LIST);
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
