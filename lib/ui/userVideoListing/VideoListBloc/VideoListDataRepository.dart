import 'dart:convert';

import 'package:footwork_chinese/constants/app_constants.dart';
import 'package:footwork_chinese/model/errorResponse/customeError.dart';
import 'package:footwork_chinese/network/ApiConfiguration.dart';
import 'package:footwork_chinese/network/ApiUrls.dart';
import 'package:footwork_chinese/network/api_callbacks.dart';
import 'package:footwork_chinese/utils/Utility.dart';
import 'package:footwork_chinese/utils/app_localizations.dart';

class VideoListDataRepository {
  final ApiCallback apiCallback;

  VideoListDataRepository(this.apiCallback);

  void onFetchData(Map data, context) {
    checkInternetConnection().then((onValue) {
      !onValue
          ? apiCallback.onAPIError(
              CustomError(
                  AppLocalizations.of(context).translate('check_internet')),
              NO_INTERNET_FLAG)
          : _onFetchData(data, context);
    });
  }

  void _onFetchData(Map data, context) async {
    var language = await checkLanguage(context);
    var url = '';
    if (!baseUrl.contains('https://')) {
      url =
          '$baseUrl$apiVideoListMonthWise?insecure=cool&cookie=${data['cookie']}&month=${data['month']}&lang=$language';
    } else {
      url =
          '$baseUrl$apiVideoListMonthWise?cookie=${data['cookie']}&month=${data['month']}&lang=$language';
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
            apiCallback.onAPISuccess(map, VIDEO_LIST_API_FLAG);
          } else {
            apiCallback.onAPIError(map, VIDEO_LIST_API_FLAG);
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
