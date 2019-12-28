import 'dart:async';

import 'package:footwork_chinese/constants/app_constants.dart';
import 'package:footwork_chinese/model/VideolistResponse/VideoListResponseData.dart';
import 'package:footwork_chinese/model/errorResponse/error_reponse.dart';
import 'package:footwork_chinese/network/api_callbacks.dart';
import 'package:footwork_chinese/ui/userVideoListing/VideoListBloc/VideoListDataRepository.dart';
import 'package:rxdart/rxdart.dart';

class VideoListBloc with ApiCallback {
  final StreamController apiController;
  final StreamController apiSuccessResponseController;
  VideoListDataRepository _dataProvider;

  VideoListBloc(this.apiController, this.apiSuccessResponseController) {
    _dataProvider = VideoListDataRepository(this);
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

  apiCall(Map map, context, isloader) {
    showProgressLoader(isloader);
    _dataProvider.onFetchData(map, context);
  }

  @override
  void onAPISuccess(Map data, int flag) {
    showProgressLoader(false);
    if (flag == VIDEO_LIST_API_FLAG) {
      var registerResponse = VideoListResponseData.fromJson(data);
      if (registerResponse.status == 200) {
        if (!apiController.isClosed) {
          apiSuccessResponseController.add(registerResponse.data);
          apiController.add(registerResponse);
        }
      }
    }
  }

  @override
  void onAPIError(error, int flag) {
    showProgressLoader(false);
    switch (flag) {
      case VIDEO_LIST_API_FLAG:
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
