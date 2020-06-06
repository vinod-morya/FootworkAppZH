import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:footwork_chinese/constants/app_constants.dart';
import 'package:footwork_chinese/model/errorResponse/customeError.dart';
import 'package:footwork_chinese/network/ApiConfiguration.dart';
import 'package:footwork_chinese/network/ApiUrls.dart';
import 'package:footwork_chinese/network/api_callbacks.dart';
import 'package:footwork_chinese/utils/Utility.dart';
import 'package:footwork_chinese/utils/app_localizations.dart';

class VideoStatusDataRepository {
  final ApiCallback apiCallback;

  VideoStatusDataRepository(this.apiCallback);

  void onFetchData(Map data, context, String from) {
    checkInternetConnection().then((onValue) {
      !onValue
          ? apiCallback.onAPIError(
              CustomError(
                  AppLocalizations.of(context).translate('check_internet')),
              NO_INTERNET_FLAG)
          : _onFetchData(data, context, from);
    });
  }

  void _onFetchData(Map data, BuildContext context, String from) async {
    var language = await checkLanguage(context);
    data.putIfAbsent('lang', () => language);
    if (!baseUrl.contains('https://')) {
      data.putIfAbsent('insecure', () => 'cool');
    }
    var url = "$baseUrl$setVideoStatus";
    try {
      ApiConfiguration.getInstance()
          .apiClient
          .liveService
          .apiMultipartRequest(context, '$url', data, "POST")
          .then((response) {
        try {
          Map map = jsonDecode(response.body);
          if (map['status'] == 200) {
            apiCallback.onAPISuccess(map, VIDEO_STATUS_API_FLAG);
          } else {
            apiCallback.onAPIError(map, VIDEO_STATUS_API_FLAG);
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
