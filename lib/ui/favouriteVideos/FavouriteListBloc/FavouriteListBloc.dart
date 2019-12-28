import 'dart:async';

import 'package:footwork_chinese/constants/app_constants.dart';
import 'package:footwork_chinese/model/errorResponse/error_reponse.dart';
import 'package:footwork_chinese/model/favouriteVideo/FavouriteVideoResponse.dart';
import 'package:footwork_chinese/network/api_callbacks.dart';
import 'package:footwork_chinese/ui/favouriteVideos/FavouriteListBloc/FavouriteListDataRepository.dart';
import 'package:rxdart/rxdart.dart';

class FavouriteListBloc with ApiCallback {
  final StreamController apiController;
  final StreamController apiSuccessResponseController;
  FavouriteListDataRepository _dataProvider;

  FavouriteListBloc(this.apiController, this.apiSuccessResponseController) {
    _dataProvider = FavouriteListDataRepository(this);
  }

  StreamController<bool> _progressLoaderController = BehaviorSubject<bool>();

  Stream<bool> get progressLoaderStream => _progressLoaderController.stream;

  void dispose() {
    _progressLoaderController.close();
  }

  void showProgressLoader(bool show) {
    if (_progressLoaderController != null &&
        !_progressLoaderController.isClosed) {
      _progressLoaderController.sink.add(show);
    }
  }

  apiCall(Map map, context, isLoader) {
    showProgressLoader(isLoader);
    _dataProvider.onFetchData(map, context);
  }

  @override
  void onAPISuccess(Map data, int flag) {
    showProgressLoader(false);
    if (flag == FAVOURITE_VIDEO_API_FLAG) {
      var registerResponse = FavouriteVideoResponse.fromJson(data);
      if (registerResponse.status == 200) {
        if (!apiSuccessResponseController.isClosed) {
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
      case FAVOURITE_VIDEO_API_FLAG:
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
