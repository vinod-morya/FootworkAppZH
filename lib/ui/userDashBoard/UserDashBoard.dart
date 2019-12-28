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
import 'package:footwork_chinese/database/data_base_helper.dart';
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

class UserDashBoard extends StatefulWidget {
  @override
  _UserDashBoardState createState() => _UserDashBoardState();
}

class _UserDashBoardState extends State<UserDashBoard>
    with TickerProviderStateMixin {
  UserBean userDataModel;
  var db = new DataBaseHelper();
  List<DataListBean> monthListing = List();
  DashBoardBloc bloc;
  StreamController apiResponseController;
  StreamController apiSuccessResponseController;
  AnimationController controller;
  String cookies;
  String errorText;
  FmFit fit = FmFit(width: 750);

  @override
  void initState() {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
    getStringDataLocally(key: userData).then((onUserModel) {
      userDataModel = UserBean.fromJson(jsonDecode(onUserModel));
    });
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
    controller = AnimationController(
        vsync: this, duration: Duration(milliseconds: 1000));
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
                      monthListing.add(snapshot.data
                          .singleWhere((DataListBean a) => a.tapStatus == 0));
                      monthListing.add(DataListBean());
                    }
                    return ListView.builder(
                      physics: BouncingScrollPhysics(),
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
                                animation: Tween<double>(
                                        begin: 0,
                                        end: monthListing[index].tapStatus == 1
                                            ? _calculateEndAnimation(
                                                        monthListing[index]) ==
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
                txt: errorText,
              ),
      ),
    );
  }

  void onClickedMonth(int position) async {
    var result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => VideoListing(
              '${monthListing[position].label}', monthListing[position].month)),
    );
    if (result != null) {
      if (result) {
        Map<String, String> map = Map<String, String>();
        map.putIfAbsent("cookie", () => cookies);
        bloc.apiCall(map, context);
      }
    }
  }

  void getAuth(BuildContext context, String onCookie) {
    try {
      var url = '';
      if (!baseUrl.contains('https://')) {
        url = '$baseUrl$validateAuth?insecure=cool&cookie=$onCookie';
      } else {
        url = '$baseUrl$validateAuth?cookie=$onCookie';
      }
      Map<String, String> map = Map<String, String>();
      map.putIfAbsent("cookie", () => onCookie);
      bloc.apiCall(map, context);
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
            TopAlert.showAlert(
                context,
                AppLocalizations.of(context).translate("session_expired"),
                true);
            clearDataLocally();
            Navigator.pushReplacementNamed(context, '/login');
          }
        } catch (error) {
          TopAlert.showAlert(context, error, true);
        }
      });
    } catch (error) {
      TopAlert.showAlert(context,
          AppLocalizations.of(context).translate("session_expired"), true);
      clearDataLocally();
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  void _subscribeToApiResponse() {
    StreamSubscription subscription;
    subscription = apiResponseController.stream.listen((data) {
      if (data is UserDashBoardResponse) {
      } else if (data is CountryListResponse) {
        writeStringDataLocally(key: countries, value: json.encode(data));
      } else if (data is ErrorResponse) {
        errorText = data.error;
        setState(() {});
        TopAlert.showAlert(context, data.error, true);
      } else if (data is CustomError) {
        TopAlert.showAlert(context, data.errorMessage, true);
      } else if (data is Exception) {
        TopAlert.showAlert(
            context,
            AppLocalizations.of(context).translate("something_went_wrong"),
            true);
      }
    }, onError: (error) {
      if (error is CustomError) {
        TopAlert.showAlert(context, error.errorMessage, true);
      } else {
        TopAlert.showAlert(context, error.toString(), true);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    apiResponseController.close();
    apiSuccessResponseController.close();
    bloc.dispose();
  }

  double _calculateEndAnimation(DataListBean data) {
    try {
      return (data.playVideo / int.parse(data.totalVideos)) * 100;
    } catch (e) {
      return 0;
    }
  }

  void _onLogin(Map data, context) async {
    String userPassword = await getStringDataLocally(key: password);
    data.putIfAbsent('username', () => userDataModel.username);
    data.putIfAbsent('password', () => userPassword);
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
      ApiConfiguration.getInstance()
          .apiClient
          .liveService
          .apiGetRequest(context, '$url')
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
                    db.deleteUser(userDataModel.id);
                    userResponseMap.putIfAbsent("cookie", () => map['cookie']);
                    var data = LoginResponseModel.fromJson(userResponseMap);
                    writeBoolDataLocally(key: session, value: true);
                    writeStringDataLocally(key: cookie, value: data.cookie);
                    writeStringDataLocally(
                        key: userId, value: data.user.id.toString());
                    writeStringDataLocally(
                        key: password, value: userPassword.toString().trim());
                    data.user.password = userPassword.toString().trim();
                    db.saveUser(data.user);
                    writeStringDataLocally(
                        key: userData, value: json.encode(data.user));
                    ApiConfiguration.createNullConfiguration(
                        ConfigConfig("", true));
                  } else {}
                } catch (e) {
                  Navigator.pushReplacementNamed(context, '/login');
                }
              });
            } catch (error) {
              Navigator.pushReplacementNamed(context, '/login');
            }
          } else {
            Navigator.pushReplacementNamed(context, '/login');
          }
        } catch (e) {
          Navigator.pushReplacementNamed(context, '/login');
        }
      });
    } catch (error) {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }
}
