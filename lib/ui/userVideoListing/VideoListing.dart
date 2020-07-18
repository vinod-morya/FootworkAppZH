import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fm_fit/fm_fit.dart';
import 'package:footwork_chinese/constants/app_colors.dart';
import 'package:footwork_chinese/constants/app_constants.dart';
import 'package:footwork_chinese/constants/app_images_path.dart';
import 'package:footwork_chinese/custom_widget/NoDataWidget.dart';
import 'package:footwork_chinese/custom_widget/custom_dilaog.dart';
import 'package:footwork_chinese/custom_widget/custom_progress_loader.dart';
import 'package:footwork_chinese/custom_widget/top_alert.dart';
import 'package:footwork_chinese/model/VideolistResponse/VideoListResponseData.dart';
import 'package:footwork_chinese/model/commonReponse/commonResponse.dart';
import 'package:footwork_chinese/model/errorResponse/customeError.dart';
import 'package:footwork_chinese/model/errorResponse/error_reponse.dart';
import 'package:footwork_chinese/network/ApiConfiguration.dart';
import 'package:footwork_chinese/network/ApiUrls.dart';
import 'package:footwork_chinese/style/theme.dart';
import 'package:footwork_chinese/ui/userVideoListing/VideoListBloc/VideoListBloc.dart';
import 'package:footwork_chinese/ui/userVideoListing/VideoListItem.dart';
import 'package:footwork_chinese/ui/userVideoListing/VideoPlayWebview.dart';
import 'package:footwork_chinese/ui/userVideoListing/WebViewPlayer.dart';
import 'package:footwork_chinese/ui/userVideoListing/videoStatusBloc/VideoStatusBloc.dart';
import 'package:footwork_chinese/utils/DialogUtils.dart';
import 'package:footwork_chinese/utils/Utility.dart';
import 'package:footwork_chinese/utils/app_localizations.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';

class VideoListing extends StatefulWidget {
  final title;
  final month;

  @override
  _VideoListingState createState() => _VideoListingState();

  VideoListing(this.title, this.month);
}

class _VideoListingState extends State<VideoListing> {
  String cookies;
  var apiCall = false;
  var _scaffoldKey = GlobalKey<ScaffoldState>();
  List<VideoListBean> videoListData = List();
  VideoListBloc bloc;
  StreamController apiResponseController;
  StreamController apiSuccessResponseController;
  String errorMessage = null;
  VideoStatusBloc _bloc;
  StreamController _controller;

  String lang = '';
  String from = '';
  FmFit fit = FmFit(width: 750);

  @override
  void initState() {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
    _controller = StreamController();
    _bloc = VideoStatusBloc(this._controller);

    apiResponseController = StreamController<dynamic>.broadcast();
    apiSuccessResponseController =
        StreamController<List<VideoListBean>>.broadcast();
    _subscribeToPlaystatusApi();
    _subscribeToApiResponse();
    bloc = VideoListBloc(apiResponseController, apiSuccessResponseController);
    Map<String, dynamic> map = Map();
    getStringDataLocally(key: cookie).then((onCookieFetch) {
      cookies = onCookieFetch;
      map.putIfAbsent('cookie', () => onCookieFetch);
      map.putIfAbsent('month', () => widget.month);
      bloc.apiCall(map, context, true);
    });
    checkLanguage(context).then((onLang) {
      lang = onLang;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    fit = FmFit(width: MediaQuery.of(context).size.width);
    if (MediaQuery.of(context).size.width > 600) {
      fit.scale = 1.0 + MediaQuery.of(context).size.aspectRatio;
    } else {
      fit.scale = 1.0;
    }
    return WillPopScope(
      child: Scaffold(
        key: _scaffoldKey,
        appBar: _gradientAppBarWidget(),
        body: Stack(
          children: <Widget>[
            _mainWidget(),
            StreamBuilder<Object>(
                stream: bloc.progressLoaderStream,
                builder: (context, snapshot) {
                  return ProgressLoader(
                    fit: fit,
                    isShowLoader: snapshot.hasData ? snapshot.data : false,
                    color: appColor,
                  );
                }),
          ],
        ),
      ),
      onWillPop: () {
        Navigator.of(context).pop(apiCall);
      },
    );
  }

  Widget _gradientAppBarWidget() {
    return GradientAppBar(
      gradient: ColorsTheme.dashBoardGradient,
      centerTitle: true,
      leading: InkWell(
        child: Icon(
          Platform.isAndroid ? Icons.arrow_back : Icons.arrow_back_ios,
          color: colorWhite,
          size: fit.t(25.0),
        ),
        onTap: () {
          Navigator.of(context).pop(apiCall);
        },
      ),
      title: Text(
        widget.title,
        style: TextStyle(
          fontFamily: robotoBoldFont,
          fontWeight: FontWeight.w600,
          fontSize: fit.t(16.0),
        ),
      ),
    );
  }

  Widget _mainWidget() {
    return Container(
      color: Color(0xFFebebec),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Colors.transparent,
        child: errorMessage == null
            ? StreamBuilder<List<VideoListBean>>(
                stream: apiSuccessResponseController.stream,
                builder: (context, snapshot) {
                  if (snapshot != null &&
                      snapshot.data != null &&
                      snapshot.hasData) {
                    videoListData.clear();
                    if (widget.title == 'Introduction video') {
                      if (snapshot.data.length > 0) {
                        snapshot.data[0].label = 'Intro Video';
                        snapshot.data[0].videoThumb =
                            'https://micahlancaster.com/wp-content/uploads/2020/03/homescreen_video_thumbnail.png';
                        snapshot.data[0].videoUrl =
                            'https://fast.wistia.net/embed/iframe/d2p0u95bk9';
                        videoListData.add(snapshot.data[0]);
                      }
                    } else {
                      videoListData.addAll(snapshot.data);
                    }
                    videoListData.add(VideoListBean());
                    return ListView.separated(
                      itemBuilder: (BuildContext context, int index) {
                        return videoListData.length == 1
                            ? NoDataWidget(
                                fit: fit,
                                txt: AppLocalizations.of(context)
                                    .translate("no_videos"),
                              )
                            : index == (videoListData.length - 1)
                                ? NoDataWidget(
                                    fit: fit,
                                    txt: AppLocalizations.of(context)
                                        .translate("reach_end_text"),
                                  )
                                : VideoListItem(
                                    fit: fit,
                                    data: videoListData[index],
                                    pos: index,
                                    onTapChat: _onChatIconClicked,
                                    onTap: onClickedPlayVideo,
                                    onTapFavourite: _onClickMarkFavourite,
                                    onTapMarkComplete: _onClickMarkCompleted,
                                  );
                      },
                      itemCount: videoListData.length,
                      separatorBuilder: (BuildContext context, int index) {
                        return Divider(
                          color: index == videoListData.length - 2
                              ? Color(0xFFebebec)
                              : colorGrey,
                          height: fit.t(0.2),
                          indent: fit.t(15.0),
                          endIndent: fit.t(15.0),
                        );
                      },
                    );
                  } else if (snapshot != null && snapshot.hasError) {
                    return Text(snapshot.error.toString());
                  } else {
                    return Container(
                      child: Text(''),
                    );
                  }
                })
            : NoDataWidget(
                fit: fit,
                txt: AppLocalizations.of(context).translate("no_videos"),
              ),
      ),
    );
  }

  void _subscribeToApiResponse() {
    StreamSubscription subscription;
    subscription = apiResponseController.stream.listen((data) {
      if (data is VideoListResponseData) {
        errorMessage = null;
        if (from == "mark_favourite") {
          DialogUtils.showCustomDialog(context,
              fit: fit,
              title:
                  AppLocalizations.of(context).translate("view_all_favourites"),
              content:
                  AppLocalizations.of(context).translate('save_favourites'),
              icon: '$ic_star_empty',
              okBtnFunction: null);
        }
      } else if (data is ErrorResponse) {
        TopAlert.showAlert(_scaffoldKey.currentState.context, data.error, true);
      } else if (data is CustomError) {
        TopAlert.showAlert(
            _scaffoldKey.currentState.context, data.errorMessage, true);
      } else if (data is Exception) {
        errorMessage = "some Error";
        setState(() {});
        TopAlert.showAlert(
            _scaffoldKey.currentState.context,
            AppLocalizations.of(context).translate("something_went_wrong"),
            true);
      }
    }, onError: (error) {
      if (error is CustomError) {
        TopAlert.showAlert(
            _scaffoldKey.currentState.context, error.errorMessage, true);
      } else {
        TopAlert.showAlert(
            _scaffoldKey.currentState.context, error.toString(), true);
      }
    });
  }

  void _subscribeToPlaystatusApi() {
    StreamSubscription subscription;
    subscription = _controller.stream.listen((data) {
      if (data is CommonResponse) {
        Map<String, dynamic> mapName = Map();
        mapName.putIfAbsent('cookie', () => cookies);
        mapName.putIfAbsent('month', () => widget.month);
        bloc.apiCall(mapName, context, false);
        from = 'mark_complete';
      } else if (data is ErrorResponse) {
        TopAlert.showAlert(_scaffoldKey.currentState.context, data.error, true);
      } else if (data is CustomError) {
        TopAlert.showAlert(
            _scaffoldKey.currentState.context, data.errorMessage, true);
      } else if (data is Exception) {
        TopAlert.showAlert(
            _scaffoldKey.currentState.context,
            AppLocalizations.of(context).translate("something_went_wrong"),
            true);
      }
    }, onError: (error) {
      if (error is CustomError) {
        TopAlert.showAlert(
            _scaffoldKey.currentState.context, error.errorMessage, true);
      } else {
        TopAlert.showAlert(
            _scaffoldKey.currentState.context, error.toString(), true);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.close();
    apiResponseController.close();
    apiSuccessResponseController.close();
    bloc.dispose();
  }

  onClickedPlayVideo(int position) async {
    String videoStatus = videoListData[position].playStatus.length > 0
        ? videoListData[position].playStatus[0].videoPlayStatus
        : "0";
    String videPlayTime = videoListData[position].playStatus.length > 0
        ? videoListData[position].playStatus[0].videoPlayTime.toString()
        : "0.0";

    var result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => Platform.isIOS &&
                  !videoListData[position].videoUrl.contains("wistia")
              ? VideoPlayerApp(
                  video_Url: videoListData[position].videoUrl,
                )
              : !videoListData[position].videoUrl.contains("wistia")
                  ? VideoPlayerApp(
                      video_Url: videoListData[position].videoUrl,
                    )
                  : VideoPlayWebview(
                      video_url: videoListData[position].videoUrl,
                      id: videoListData[position].id,
                      month: videoListData[position].month,
                      video_play_status: videoStatus,
                      video_play_time: videPlayTime,
                    )),
    );

    if (result != null) {
      if (result is Duration) {
        Map<String, dynamic> map = Map();
        map.putIfAbsent('cookie', () => cookies);
        map.putIfAbsent(
            'video_id', () => videoListData[position].id.toString());
        map.putIfAbsent(
            'month', () => videoListData[position].month.toString());
        map.putIfAbsent('video_play_status', () => videoStatus);
        map.putIfAbsent('video_play_time', () => result.toString());
        _bloc.apiCall(map, context, false, null);
      }
    }
  }

  _onClickMarkFavourite(int position) {
    String isFavourite = videoListData[position].playStatus.length > 0
        ? videoListData[position].playStatus[0].isFavorite
        : "0";
    String title = '';
    if (isFavourite == "0") {
      title = '';
      from = 'mark_favourite';
    } else {
      title = '';
      from = '';
    }

    DialogUtils.showCustomDialog(context,
        fit: fit,
        okBtnText: AppLocalizations.of(context).translate('yes'),
        cancelBtnText: AppLocalizations.of(context).translate('no'),
        title: '$title',
        icon: isFavourite == "0" ? ic_star_fill : ic_star_empty,
        content: isFavourite == "0"
            ? AppLocalizations.of(context).translate('mark_favourite')
            : AppLocalizations.of(context).translate('mark_un_favourite'),
        okBtnFunction: () {
      Navigator.of(context).pop();
      Map<String, dynamic> map = Map();
      map.putIfAbsent('cookie', () => cookies);
      map.putIfAbsent('lang', () => lang);
      map.putIfAbsent('month', () => videoListData[position].month);
      map.putIfAbsent('video_id', () => videoListData[position].id.toString());
      map.putIfAbsent('is_favorite', () => isFavourite == "0" ? '1' : "0");
      if (!baseUrl.contains('https://')) {
        map.putIfAbsent("insecure", () => "cool");
      }
      try {
        bloc.showProgressLoader(true);
        ApiConfiguration.getInstance()
            .apiClient
            .liveService
            .apiMultipartRequest(
                context, '$baseUrl$apiSetFavourite', map, "POST")
            .then((response) {
          try {
            Map map = jsonDecode(response.body);
            if (map['status'] == 200) {
              Map<String, dynamic> mapName = Map();
              mapName.putIfAbsent('cookie', () => cookies);
              mapName.putIfAbsent('month', () => widget.month);
              bloc.apiCall(mapName, context, true);
            }
          } catch (error) {
            TopAlert.showAlert(context, error, true);
          }
        });
      } catch (error) {
        TopAlert.showAlert(context, error, true);
      }
    });
  }

  _onClickMarkCompleted(int position) {
    String videoStatus = videoListData[position].playStatus.length > 0
        ? videoListData[position].playStatus[0].videoPlayStatus
        : "0";

    showDialogMarkAsComplete(context,
        title: '${videoListData[position].label}',
        okBtnText: AppLocalizations.of(context).translate("btn_needs_work"),
        cancelBtnText: (videoStatus == "0" || videoStatus == "2")
            ? AppLocalizations.of(context).translate("btn_mark_complete")
            : AppLocalizations.of(context).translate("mark_incomplete"),
        rating: videoListData[position].playStatus.length > 0
            ? videoListData[position].playStatus[0].rating
            : "0.0", okBtnFunction: (value) {
      Navigator.of(context).pop();
      bloc.showProgressLoader(true);
      apiCall = true;
      Map<String, dynamic> map = Map();
      map.putIfAbsent('cookie', () => cookies);
      map.putIfAbsent('rating', () => value.toInt().toString());
      map.putIfAbsent('video_id', () => videoListData[position].id.toString());
      map.putIfAbsent('month', () => videoListData[position].month);
      map.putIfAbsent('video_play_status', () => "2");
      _bloc.apiCall(map, context, true, null);
    }, cancelBtnFunction: (value) {
      Navigator.of(context).pop();
      bloc.showProgressLoader(true);
      apiCall = true;
      Map<String, dynamic> map = Map();
      map.putIfAbsent('cookie', () => cookies);
      map.putIfAbsent('rating', () => value.toInt().toString());
      map.putIfAbsent('video_id', () => videoListData[position].id.toString());
      map.putIfAbsent('month', () => videoListData[position].month);
      map.putIfAbsent('video_play_status',
          () => (videoStatus == "0" || videoStatus == "2") ? "1" : "0");
      _bloc.apiCall(map, context, true, null);
    });
  }

  _onChatIconClicked(int pos) {
    String comment = videoListData[pos].playStatus.length > 0
        ? videoListData[pos].playStatus[0].comment
        : null;
    String updatedAtTime = videoListData[pos].playStatus.length > 0
        ? videoListData[pos].playStatus[0].updatedAt
        : '';
    showDialogAddEditComment(context,
        okBtnText: AppLocalizations.of(context).translate('save_comment'),
        okBtnFunction: (comment) {
      if (comment != null && comment.toString().trim().isNotEmpty) {
        Navigator.of(context).pop();
        Map<String, dynamic> map = Map();
        map.putIfAbsent('comment', () => comment.toString().trim());
        map.putIfAbsent('cookie', () => cookies);
        map.putIfAbsent('lang', () => lang);
        map.putIfAbsent('month', () => videoListData[pos].month);
        map.putIfAbsent('video_id', () => videoListData[pos].id.toString());
        if (!baseUrl.contains('https://')) {
          map.putIfAbsent("insecure", () => "cool");
        }
        try {
          bloc.showProgressLoader(true);
          ApiConfiguration.getInstance()
              .apiClient
              .liveService
              .apiMultipartRequest(
                  context, '$baseUrl$addCommentApi', map, "POST")
              .then((response) {
            try {
              Map map = jsonDecode(response.body);
              if (map['status'] == 200) {
                Map<String, dynamic> mapName = Map();
                mapName.putIfAbsent('cookie', () => cookies);
                mapName.putIfAbsent('month', () => widget.month);
                bloc.apiCall(mapName, context, true);
                from = 'addComment';
              }
            } catch (error) {
              TopAlert.showAlert(context, error, true);
            }
          });
        } catch (error) {
          TopAlert.showAlert(context, error, true);
        }
      } else {
        TopAlert.showAlert(context,
            AppLocalizations.of(context).translate("comment_label"), true);
      }
    },
        icon: '$ic_chat_white',
        content: comment == null ? '' : comment,
        date: updatedAtTime);
  }
}
