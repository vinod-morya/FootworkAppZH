import 'dart:async';

import 'package:footwork_chinese/constants/app_constants.dart';
import 'package:footwork_chinese/model/commonReponse/commonResponse.dart';
import 'package:footwork_chinese/model/errorResponse/error_reponse.dart';
import 'package:footwork_chinese/network/api_callbacks.dart';
import 'package:footwork_chinese/ui/userVideoListing/videoStatusBloc/VideoStatusDataRepository.dart';
import 'package:rxdart/rxdart.dart';

class VideoStatusBloc with ApiCallback {
  final StreamController apiController;
  VideoStatusDataRepository _dataProvider;

  VideoStatusBloc(this.apiController) {
    _dataProvider = VideoStatusDataRepository(this);
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

  apiCall(Map map, context, isLoader, [String from]) {
    showProgressLoader(isLoader);
    _dataProvider.onFetchData(map, context, from);
  }

  @override
  void onAPISuccess(Map data, int flag) {
    showProgressLoader(false);
    if (flag == VIDEO_STATUS_API_FLAG) {
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
      case VIDEO_STATUS_API_FLAG:
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
