import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fm_fit/fm_fit.dart';
import 'package:footwork_chinese/constants/app_colors.dart';
import 'package:footwork_chinese/constants/app_constants.dart';
import 'package:footwork_chinese/custom_widget/NoDataWidget.dart';
import 'package:footwork_chinese/custom_widget/custom_progress_loader.dart';
import 'package:footwork_chinese/custom_widget/top_alert.dart';
import 'package:footwork_chinese/model/CountryListResponse.dart';
import 'package:footwork_chinese/model/errorResponse/customeError.dart';
import 'package:footwork_chinese/model/errorResponse/error_reponse.dart';
import 'package:footwork_chinese/model/loginResponse/LoginResponseModel.dart';
import 'package:footwork_chinese/model/userDashBoardResponse/UserDashBoardResponse.dart';
import 'package:footwork_chinese/network/ApiConfiguration.dart';
import 'package:footwork_chinese/network/ApiUrls.dart';
import 'package:footwork_chinese/ui/userDashBoard/DashboardBloc/DashBoardBloc.dart';
import 'package:footwork_chinese/ui/userDashBoard/UserDashboardListItem.dart';
import 'package:footwork_chinese/ui/userVideoListing/VideoListing.dart';
import 'package:footwork_chinese/utils/Utility.dart';
import 'package:footwork_chinese/utils/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../model/commonReponse/commonResponse.dart';

class UserDashBoard extends StatefulWidget {
  @override
  _UserDashBoardState createState() => _UserDashBoardState();
}

class _UserDashBoardState extends State<UserDashBoard>
    with TickerProviderStateMixin {
  UserBean userDataModel;
  List<DataListBean> monthListing = List();
  DashBoardBloc bloc;
  StreamController apiResponseController;
  StreamController apiSuccessResponseController;
  AnimationController controller;
  String cookies;
  String errorText;
  FmFit fit = FmFit(width: 750);
  int callSavedTime;
  bool isApiCall = true;
  var refreshKey = GlobalKey<RefreshIndicatorState>();
  String thumbnail;
  String videoUrl;

  MembershipsInfoBean memberInfo;

  @override
  void initState() {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
    getStringDataLocally(key: userData).then((onUserModel) {
      userDataModel = UserBean.fromJson(jsonDecode(onUserModel));
    });
    callSavedTime = DateTime.now().millisecondsSinceEpoch;
    apiCallTime();
    apiCallCheck();
    apiResponseController = StreamController<dynamic>.broadcast();
    apiSuccessResponseController =
        StreamController<List<DataListBean>>.broadcast();
    _subscribeToApiResponse();
    bloc = DashBoardBloc(apiResponseController, apiSuccessResponseController);
    getStringDataLocally(key: cookie).then((onCookie) {
      if (onCookie != null && onCookie.isNotEmpty) {
        this.cookies = onCookie;
        checkInternetConnection().then((onValue) {
          !onValue
              ? TopAlert.showAlert(
                  context,
                  AppLocalizations.of(context).translate("check_internet"),
                  true)
              : getAuth(context, onCookie);
        });
      } else {
        clearDataLocally();
        Navigator.pushReplacementNamed(context, '/login');
      }
    });
    getStringDataLocally(key: countries).then((onFetchCountries) {
      if (onFetchCountries == null || !(onFetchCountries.length > 0)) {
        Map<dynamic, dynamic> mapName = Map();
        mapName.putIfAbsent('cookie', () => '$cookies');
        bloc.getCountryCode(mapName, context);
      }
    });
    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 1));

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
    return Stack(
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
    );
  }

  Widget _mainWidget() {
    return Container(
      color: Color(0xFFebebec),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Colors.transparent,
        child: errorText == null
            ? StreamBuilder<List<DataListBean>>(
                stream: apiSuccessResponseController.stream,
                builder: (context, snapshot) {
                  if (snapshot != null &&
                      snapshot.data != null &&
                      snapshot.hasData) {
                    monthListing.clear();
                    if (snapshot.data.length > 0) {
                      List<DataListBean> dataList = List();
                      for (int i = 0; i < snapshot.data.length; i++) {
                        if (snapshot.data[i].tapStatus == 1) {
                          dataList.add(snapshot.data[i]);
                        }
                      }
                      Iterable inReverse = dataList.reversed;
                      List<DataListBean> dataInReverse = inReverse.toList();
                      monthListing.addAll(dataInReverse);
                      for (int i = 0; i < snapshot.data.length; i++) {
                        if (snapshot.data[i].tapStatus == 0) {
                          monthListing.add(snapshot.data[i]);
                        }
                      }
                      monthListing.insert(0, DataListBean());
                      monthListing.add(DataListBean());
                    }
                    return RefreshIndicator(
                      key: refreshKey,
                      onRefresh: refreshList,
                      child: ListView.builder(
                        physics: AlwaysScrollableScrollPhysics(),
                        itemBuilder: (BuildContext context, int index) {
                          return index == (monthListing.length - 1)
                              ? NoDataWidget(
                                  fit: fit,
                                  txt: AppLocalizations.of(context)
                                      .translate("reach_end_text"),
                                )
                              : UserDashboardListItem(
                                  fit: fit,
                                  progressController: controller,
                                  videoURl: videoUrl,
                                  thumbnail: thumbnail,
                                  animation: Tween<double>(
                                          begin: 0,
                                          end: monthListing[index].tapStatus ==
                                                  1
                                              ? _calculateEndAnimation(
                                                          monthListing[
                                                              index]) ==
                                                      0.0
                                                  ? 0.0
                                                  : _calculateEndAnimation(
                                                      monthListing[index])
                                              : 100)
                                      .animate(controller)
                                        ..addListener(() {}),
                                  data: monthListing[index],
                                  pos: index,
                                  onTap: onClickedMonth,
                                );
                        },
                        itemCount: monthListing.length,
                      ),
                    );
                  } else if (snapshot != null && snapshot.hasError) {
                    return Text(snapshot.error.toString());
                  } else {
                    return Container(
                      child: Text(''),
                    );
                  }
                })
            : getListWidget(monthListing, errorText, controller),
      ),
    );
  }

  void onClickedMonth(int position) async {
    if (monthListing[position].tapStatus == 1) {
      var result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => VideoListing(
                '${monthListing[position].label}',
                monthListing[position].month)),
      );
      if (result != null) {
        if (result) {
          Map<String, String> map = Map<String, String>();
          map.putIfAbsent("cookie", () => cookies);
          bloc.apiCall(map, context);
        }
      }
    }
  }

  Future<Null> refreshList() async {
    refreshKey.currentState?.show(atTop: false);
    await Future.delayed(Duration(seconds: 1));
    Map<String, String> map = Map<String, String>();
    map.putIfAbsent("cookie", () => cookies);
    bloc.apiCall(map, context);
    return null;
  }

  void getAuth(BuildContext context, String onCookie) {
    try {
      var url = '';
      if (!baseUrl.contains('https://')) {
        url = '$baseUrl$validateAuth?insecure=cool&cookie=$onCookie';
      } else {
        url = '$baseUrl$validateAuth?cookie=$onCookie';
      }
      getStringDataLocally(key: dashBoardData).then((onFetchdashBoardData) {
        if (onFetchdashBoardData == null ||
            !(onFetchdashBoardData.length > 0) ||
            isApiCall) {
          Map<String, String> map = Map<String, String>();
          map.putIfAbsent("cookie", () => onCookie);
          bloc.apiCall(map, context);
          writeStringDataLocally(
              key: dashboardCall, value: (callSavedTime + 600000).toString());
        } else {
          getStringDataLocally(key: videoURl).then((value) {
            videoUrl = value;
            getStringDataLocally(key: videoThumbnail).then((thumbUrl) {
              thumbnail = thumbUrl;
              var response = UserDashBoardResponse.fromJson(
                  jsonDecode(onFetchdashBoardData));
              memberInfo = response.membershipsInfo;
              apiResponseController.add(response);
              apiSuccessResponseController.add(response.data);
            });
          });
        }
      });
      ApiConfiguration.getInstance()
          .apiClient
          .liveService
          .apiGetRequest(context, '$url')
          .then((response) {
        try {
          Map map = jsonDecode(response.body);
          if (map['status'] == 200) {
            if (!map['valid']) {
              Map<String, String> data = Map();
              _onLogin(data, context);
            }
          } else {
            clearDataLocally();
            Navigator.pushReplacementNamed(context, '/login');
          }
        } catch (error) {
          TopAlert.showAlert(context, error, true);
        }
      });
    } catch (error) {
      clearDataLocally();
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  void _subscribeToApiResponse() {
    StreamSubscription subscription;
    subscription = apiResponseController.stream.listen((data) {
      if (data is UserDashBoardResponse) {
        memberInfo = data.membershipsInfo;
        writeStringDataLocally(key: dashBoardData, value: json.encode(data));
        if (data.videoUrl != null) {
          videoUrl = data.videoUrl;
        } else {
          videoUrl = "https://fast.wistia.net/embed/iframe/d2p0u95bk9";
        }
        writeStringDataLocally(key: videoURl, value: videoUrl);
        if (data.thumbNail != null) {
          thumbnail = data.thumbNail;
        } else {
          thumbnail =
              "https://micahlancaster.com/wp-content/uploads/2020/03/homescreen_video_thumbnail.png";
        }
        writeStringDataLocally(key: videoThumbnail, value: thumbnail);
        setState(() {});
      } else if (data is CommonResponse) {
        errorText = null;
        callSavedTime = DateTime.now().millisecondsSinceEpoch;
        Map<String, String> map = Map<String, String>();
        map.putIfAbsent("cookie", () => cookies);
        bloc.apiCall(map, context);
        writeStringDataLocally(
            key: dashboardCall, value: (callSavedTime + 600000).toString());
        setState(() {});
      } else if (data is CountryListResponse) {
        writeStringDataLocally(key: countries, value: json.encode(data));
      } else if (data is ErrorResponse) {
        errorText = data.error;
        videoUrl = "https://fast.wistia.net/embed/iframe/d2p0u95bk9";
        thumbnail =
            "https://micahlancaster.com/wp-content/uploads/2020/03/homescreen_video_thumbnail.png";
        writeStringDataLocally(key: videoThumbnail, value: thumbnail);
        writeStringDataLocally(key: videoURl, value: videoUrl);
        writeStringDataLocally(key: dashBoardData, value: '');
        setState(() {});
        TopAlert.showAlert(context, data.error, true);
      } else if (data is CustomError) {
        TopAlert.showAlert(context, data.errorMessage, true);
        videoUrl = "https://fast.wistia.net/embed/iframe/d2p0u95bk9";
        thumbnail =
            "https://micahlancaster.com/wp-content/uploads/2020/03/homescreen_video_thumbnail.png";
        writeStringDataLocally(key: videoThumbnail, value: thumbnail);
        writeStringDataLocally(key: videoURl, value: videoUrl);
        setState(() {});
      } else if (data is Exception) {
        videoUrl = "https://fast.wistia.net/embed/iframe/d2p0u95bk9";
        thumbnail =
            "https://micahlancaster.com/wp-content/uploads/2020/03/homescreen_video_thumbnail.png";
        writeStringDataLocally(key: videoThumbnail, value: thumbnail);
        writeStringDataLocally(key: videoURl, value: videoUrl);
        TopAlert.showAlert(
            context,
            AppLocalizations.of(context).translate("something_went_wrong"),
            true);
        setState(() {});
      }
    }, onError: (error) {
      if (error is CustomError) {
        if (error.errorMessage != null) {
          TopAlert.showAlert(context, error.errorMessage, true);
        }
      } else {
        if (error != null) {
          TopAlert.showAlert(context, error.toString(), true);
        }
      }
    });
  }

  @override
  void dispose() {
    apiResponseController.close();
    apiSuccessResponseController.close();
    bloc.dispose();
    super.dispose();
  }

  double _calculateEndAnimation(DataListBean data) {
    try {
      if (data.playVideo == 0 && data.totalVideos == "0") {
        return 0;
      } else {
        return (data.playVideo / int.parse(data.totalVideos)) * 100;
      }
    } catch (e) {
      return 0;
    }
  }

  void _onLogin(Map data, context) async {
    String userPassword = await getStringDataLocally(key: password);
    data.putIfAbsent('username', () => userDataModel.username);
    data.putIfAbsent('password', () => userPassword);
    var language = await checkLanguage(context);
    data.putIfAbsent('lang', () => language);
    var url = '$baseUrl$loginUrl';
    if (!baseUrl.contains('https://')) {
      data.putIfAbsent('insecure', () => "cool");
    }
    try {
      ApiConfiguration.getInstance()
          .apiClient
          .liveService
          .apiMultipartRequest(context, '$url', data, 'POST')
          .then((response) {
        try {
          Map map = jsonDecode(response.body);
          if (map['status'] == 200) {
            var url2 = '';
            if (!baseUrl.contains('https://')) {
              url2 =
                  '$baseUrl$getUserCurrentInfo?insecure=cool&cookie=${map['cookie']}&lang=$language';
            } else {
              url2 =
                  '$baseUrl$getUserCurrentInfo?cookie=${map['cookie']}&lang=$language';
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
                    Map<String, String> mapD = Map<String, String>();
                    cookies = map['cookie'];
                    mapD.putIfAbsent("cookie", () => map['cookie']);
                    bloc.apiCall(mapD, context);
                    userResponseMap.putIfAbsent("cookie", () => map['cookie']);
                    var data = LoginResponseModel.fromJson(userResponseMap);
                    writeBoolDataLocally(key: session, value: true);
                    writeStringDataLocally(key: cookie, value: data.cookie);
                    writeStringDataLocally(
                        key: userId, value: data.user.id.toString());
                    writeStringDataLocally(
                        key: password, value: userPassword.toString().trim());
                    data.user.password = userPassword.toString().trim();
                    writeStringDataLocally(
                        key: userData, value: json.encode(data.user));
                    ApiConfiguration.createNullConfiguration(
                        ConfigConfig("", true));
                  } else {}
                } catch (e) {
                  clearDataLocally();
                  Navigator.pushReplacementNamed(context, '/login');
                }
              });
            } catch (error) {
              clearDataLocally();
              Navigator.pushReplacementNamed(context, '/login');
            }
          } else {
            clearDataLocally();
            Navigator.pushReplacementNamed(context, '/login');
          }
        } catch (e) {
          clearDataLocally();
          Navigator.pushReplacementNamed(context, '/login');
        }
      });
    } catch (error) {
      clearDataLocally();
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  Widget getListWidget(List<DataListBean> monthListing, String errorText,
      AnimationController controller) {
    monthListing.clear();
    monthListing.add(DataListBean());
    monthListing.add(DataListBean());
    monthListing.add(DataListBean());

    return RefreshIndicator(
      key: refreshKey,
      onRefresh: refreshList,
      child: ListView.builder(
        physics: AlwaysScrollableScrollPhysics(),
        itemBuilder: (BuildContext context, int index) {
          return index == (monthListing.length - 1)
              ? GestureDetector(
                  onTap: () => _launchUrl(
                      'https://micahlancaster.com/footwork-training-system-short/'),
                  child: NoDataWidget(
                    fit: fit,
                    txt: '$errorText.',
                    url: AppLocalizations.of(context)
                        .translate("subscribe_here"),
                  ),
                )
              : UserDashboardListItem(
                  fit: fit,
                  progressController: controller,
                  videoURl: videoUrl,
                  thumbnail: thumbnail,
                  animation: Tween<double>(
                          begin: 0,
                          end: monthListing[index].tapStatus == 1
                              ? _calculateEndAnimation(monthListing[index]) ==
                                      0.0
                                  ? 0.0
                                  : _calculateEndAnimation(monthListing[index])
                              : 100)
                      .animate(controller)
                        ..addListener(() {}),
                  data: monthListing[index],
                  pos: index,
                  onTap: onClickedMonth,
                );
        },
        itemCount: monthListing.length,
      ),
    );
  }

  _launchUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void apiCallCheck() {
    getBoolDataLocally(key: dashboardCallApi).then((onValueHistory) {
      if (onValueHistory) {
        isApiCall = true;
        writeBoolDataLocally(key: dashboardCallApi, value: false);
      }
    });
  }

  void apiCallTime() {
    getStringDataLocally(key: dashboardCall).then((onValue) {
      if (onValue != null && onValue.isNotEmpty) {
        int callTime = int.parse(onValue);
        if (callTime < callSavedTime) {
          isApiCall = true;
        } else {
          isApiCall = false;
        }
      } else {
        isApiCall = true;
      }
    });
  }
}
