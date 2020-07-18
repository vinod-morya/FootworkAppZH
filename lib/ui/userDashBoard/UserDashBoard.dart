import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fm_fit/fm_fit.dart';
import 'package:footwork_chinese/constants/app_colors.dart';
import 'package:footwork_chinese/constants/app_constants.dart';
import 'package:footwork_chinese/custom_widget/NoDataWidget.dart';
import 'package:footwork_chinese/custom_widget/custom_dilaog.dart';
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
import 'package:footwork_chinese/utils/ConsumableStore.dart';
import 'package:footwork_chinese/utils/Utility.dart';
import 'package:footwork_chinese/utils/app_localizations.dart';
import 'package:footwork_chinese/utils/date_formatter.dart';
import 'package:http/http.dart' as http;
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:uni_links/uni_links.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../model/commonReponse/commonResponse.dart';

const String kNonConsumableIdYear =
    'com.training.footwork_chinese_yearly_sub_yuan';
const List<String> _kProductConsumableIdYearly = <String>[kNonConsumableIdYear];

class UserDashBoard extends StatefulWidget {
  @override
  _UserDashBoardState createState() => _UserDashBoardState();
}

class _UserDashBoardState extends State<UserDashBoard>
    with TickerProviderStateMixin {
  final InAppPurchaseConnection _connection =
      Platform.isIOS ? InAppPurchaseConnection.instance : null;
  StreamSubscription<List<PurchaseDetails>> _subscription;
  List<String> _notFoundIds = [];
  List<ProductDetails> _products = [];
  bool _isAvailable = false;
  String _queryProductError;
  bool _loading = true;
  bool ispaymentCalled = false;

  UserBean userDataModel;
  List<DataListBean> monthListing = List();
  DashBoardBloc bloc;
  String monthPurchasingFor = "";
  StreamController apiResponseController;
  StreamController apiSuccessResponseController;
  AnimationController controller;
  String cookies;
  String errorText;
  FmFit fit = FmFit(width: 750);
  int callSavedTime;
  bool isApiCall = true;
  var refreshKey = GlobalKey<RefreshIndicatorState>();
  List<PurchasedMonth> purchaseMonthList = List();
  String thumbnail;
  String videoUrl;
  var amount = '';
  var type = '';

  MembershipsInfoBean memberInfo;
  String source;

  bool deepLink = false;
  Map<String, dynamic> data = Map();

  bool isCall = false;
  StreamSubscription _sub;

  Future<Null> initUniLinks() async {
    _sub = getUriLinksStream().listen((Uri uri) {
      if (uri != null) {
        if (uri.toString().contains(returnUrl)) {
          if (uri != null) {
            deepLink = true;
            isCall = true;
            print('uri data -> $uri');
            uri?.queryParametersAll?.forEach((key, value) {
              data.putIfAbsent(key, () => value[0]);
            });
            _sub.cancel();
            if (data.length > 1) {
              if (data.containsKey('source')) {
                callApiAuthorizePayment(data);
              }
            }
          }
        }
      }
    }, onError: (err) {
      setError(err);
    });
  }

  @override
  void initState() {
    initUniLinks();
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
    getStringDataLocally(key: userData).then((onUserModel) {
      userDataModel = UserBean.fromJson(jsonDecode(onUserModel));
    });
    callSavedTime = DateTime
        .now()
        .millisecondsSinceEpoch;
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
        if (Platform.isIOS) {
          getStringDataLocally(key: inAppPurchaseData).then((value) {
            if (value != null && value != '' && value.isNotEmpty) {
              Map map = jsonDecode(value);
              map['cookie'] = cookies;
              bloc.purchasedMonthUpdate(context, map);
            }
          });
        }
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
    if (Platform.isIOS) {
      Stream purchaseUpdated =
          InAppPurchaseConnection.instance.purchaseUpdatedStream;
      _subscription = purchaseUpdated.listen((purchaseDetailsList) {
        _listenToPurchaseUpdated(purchaseDetailsList);
      }, onDone: () {
        _subscription.cancel();
      }, onError: (error) {
        print(error);
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    fit = FmFit(width: MediaQuery
        .of(context)
        .size
        .width);
    if (MediaQuery
        .of(context)
        .size
        .width > 600) {
      fit.scale = 1.0 + MediaQuery
          .of(context)
          .size
          .aspectRatio;
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
      if (memberInfo == null || memberInfo.id == null) {
        var isCalled = false;
        for (var purchase in purchaseMonthList) {
          if (purchase.purchasedmonth == monthListing[position].month) {
            _navigateToMonth(position);
            isCalled = true;
            break;
          }
        }
        if (!isCalled) {
          openInAppDialog(position);
        }
      } else {
        _navigateToMonth(position);
      }
    } else {
      openInAppDialog(position);
    }
  }

  void _openInAppDialogBool(bool callInApp) {
    if (callInApp) {
      if (memberInfo == null || memberInfo.id == null) {
        showDialogInApp(context,
            yearlyTxt: "\¥298/年",
            title: "篮球脚步训练",
            body:
                "${AppLocalizations.of(context).translate("yearly_subscription")}",
            yearlyBtnFunction: _yearlySubscriptionClick,
            restoreBtnFunction:
                Platform.isAndroid ? null : _restorePurchaseClick);
      }
    }
  }

  _restorePurchaseClick() {
    Navigator.of(context).pop();
    _restoreActionDialog();
  }

  void _yearlySubscriptionClick() {
    Navigator.of(context).pop();
    if (Platform.isAndroid) {
      openDialogPayment('2');
    } else {
      initStoreInfo("2");
    }
  }

  void openDialogPayment(String purtype) {
    var price = '';
    price = "\¥298/年";
    amount = '298';
    type = '2';
    showDialogPurchase(
      context,
      title: '篮球脚步训练',
      body: '继续购买$price\n请选择付款方式',
      aliPayBtnFunction: aliPayCall,
    );
  }

  void callApiAuthorizePayment(Map<String, dynamic> datas) {
    Map<String, dynamic> data = Map();
    data.putIfAbsent('cookie', () => cookies);
    data.putIfAbsent('payment_type', () => 'alipay');
    if (datas['redirect_status'] == null) {
      data.putIfAbsent('status', () => 'succeeded');
    } else {
      if (datas['redirect_status'] == 'succeeded') {
        data.putIfAbsent('status', () => 'succeeded');
      } else {
        data.putIfAbsent('status', () => 'failed');
      }
    }
    data.putIfAbsent('source', () => datas['source']);
    data.putIfAbsent('insecure', () => 'cool');
    checkInternetConnection().then((onValue) {
      if (onValue) {
        bloc.showProgressLoader(true);
        ApiConfiguration
            .getInstance()
            .apiClient
            .liveService
            .apiMultipartRequest(
            context, '$baseUrl$authorizeAccount', data, 'POST')
            .then((response) {
          try {
            Map map = jsonDecode(response.body);
            if (map['status'] == 200) {
              callApiUpdatePayment('alipay', datas['source']);
            } else {
              setError(map['msg']);
              bloc.showProgressLoader(false);
            }
          } catch (error) {
            bloc.showProgressLoader(false);
            setError(error);
          }
        });
      } else {
        TopAlert.showAlert(
            context, AppLocalizations.of(context).translate('check_internet'),
            true);
      }
    });
  }

  void callApiUpdatePayment(String typeName, String source) {
    checkInternetConnection().then((onValue) {
      if (onValue) {
        Map<String, dynamic> data = Map();
        data.putIfAbsent('cookie', () => cookies);
        data.putIfAbsent('payment_type', () => typeName);
        data.putIfAbsent('lang', () => 'zh');
        data.putIfAbsent('source', () => source);
        data.putIfAbsent('currency', () => 'cny');
        data.putIfAbsent('amount', () => amount);
        data.putIfAbsent('purchase_type', () => type);
        data.putIfAbsent('purchasemonth', () => monthPurchasingFor);
        data.putIfAbsent('deviceType', () => getDeviceType());
        data.putIfAbsent('insecure', () => 'cool');

        ApiConfiguration
            .getInstance()
            .apiClient
            .liveService
            .apiMultipartRequest(
            context, '$baseUrl$updatePurchase', data, 'POST')
            .then((response) {
          try {
            Map map = jsonDecode(response.body);
            if (map['status'] == 200) {
              if (mounted)
                setState(() {
                  errorText = null;
                });
              bloc.showProgressLoader(false);
              Map<String, String> dashboardCall = Map<String, String>();
              dashboardCall.putIfAbsent("cookie", () => cookies);
              bloc.apiCall(dashboardCall, context);
            } else {
              setError(map['msg']);
              bloc.showProgressLoader(false);
            }
          } catch (error) {
            bloc.showProgressLoader(false);
            setError(error);
          }
        });
      } else {
        TopAlert.showAlert(
            context, AppLocalizations.of(context).translate('check_internet'),
            true);
      }
    });
  }

  void aliPayCall() {
    checkInternetConnection().then((onValue) {
      if (onValue) {
        bloc.showProgressLoader(true);
        Map<String, dynamic> data = Map();
        data.putIfAbsent('cookie', () => cookies);
        data.putIfAbsent('payment_type', () => 'alipay');
        data.putIfAbsent('currency', () => 'cny');
        data.putIfAbsent('amount', () => amount);
        data.putIfAbsent('return_url', () => returnUrl);
        data.putIfAbsent('email', () => userDataModel.email);
        data.putIfAbsent('insecure', () => 'cool');

        ApiConfiguration
            .getInstance()
            .apiClient
            .liveService
            .apiMultipartRequest(
            context, '$baseUrl$createStripeSource', data, 'POST')
            .then((response) {
          try {
            Map map = jsonDecode(response.body);
            bloc.showProgressLoader(false);
            if (map['status'] == 200) {
              source = map['data']['id'];
              var launch = map['data']['redirect']['url'];
              _launchUrl(launch);
            } else if (map['status'] == 209) {
              source = map['data']['source'];
              var launch = map['data']['url'];
              _launchUrl(launch);
            } else {
              if (map['status'] == 210) {
                setError(map['msg']);
              }
            }
          } catch (error) {
            setError(error);
            bloc.showProgressLoader(false);
          }
        });
      } else {
        TopAlert.showAlert(
            context, AppLocalizations.of(context).translate('check_internet'),
            true);
      }
    });
    Navigator.of(context).pop();
  }

  void weChatCall() {
    Map<String, dynamic> data = Map();
    data.putIfAbsent('cookie', () => cookies);
    data.putIfAbsent('payment_type', () => 'wechat');
    data.putIfAbsent('currency', () => 'cny');
    data.putIfAbsent('amount', () => '200');
    data.putIfAbsent('return_url', () => returnUrl);
    data.putIfAbsent('email', () => userDataModel.email);
    data.putIfAbsent('insecure', () => 'cool');

    ApiConfiguration
        .getInstance()
        .apiClient
        .liveService
        .apiMultipartRequest(
        context, '$baseUrl$createStripeSource', data, 'POST')
        .then((response) {
      try {
        Map map = jsonDecode(response.body);
        if (map['status'] == 200) {
          source = map['data']['id'];
          var launch = map['data']['redirect']['url'];
          _launchUrl(launch);
          Navigator.of(context).pop();
        }
      } catch (error) {
        print(error);
      }
    });
  }

  void setError(dynamic error) {
    TopAlert.showAlert(context, '${error.toString()}', false);
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
              purchaseMonthList.clear();
              memberInfo = response.membershipsInfo;
              purchaseMonthList = response.purchasedMonth;
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
        if (data.data.length > 0) {
          errorText = null;
        }
        if (purchaseMonthList != null) {
          purchaseMonthList.clear();
        }
        purchaseMonthList = data.purchasedMonth;
        memberInfo = data.membershipsInfo;
        writeStringDataLocally(key: dashBoardData, value: json.encode(data));
        if (data.videoUrl != null) {
          videoUrl = data.videoUrl;
        } else {
          videoUrl = "https://fast.wistia.net/embed/iframe/c568dpkzq7";
        }
        ispaymentCalled = false;
        writeStringDataLocally(key: videoURl, value: videoUrl);
        if (data.thumbNail != null) {
          thumbnail = data.thumbNail;
        } else {
          thumbnail =
          "https://embed-ssl.wistia.com/deliveries/7b064f6bfc25e88da280b27ef3264918ad8e3391.jpg?image_crop_resized=768x432";
        }
        writeStringDataLocally(key: videoThumbnail, value: thumbnail);
        setState(() {});
      } else if (data is CommonResponse) {
        errorText = null;
        callSavedTime = DateTime
            .now()
            .millisecondsSinceEpoch;
        Map<String, String> map = Map<String, String>();
        map.putIfAbsent("cookie", () => cookies);
        bloc.apiCall(map, context);
        writeStringDataLocally(
            key: dashboardCall, value: (callSavedTime + 600000).toString());
        writeStringDataLocally(key: inAppPurchaseData, value: '');
        setState(() {});
      } else if (data is CountryListResponse) {
        writeStringDataLocally(key: countries, value: json.encode(data));
      } else if (data is ErrorResponse) {
        errorText = data.error;
        videoUrl = "https://fast.wistia.net/embed/iframe/c568dpkzq7";
        thumbnail =
        "https://embed-ssl.wistia.com/deliveries/7b064f6bfc25e88da280b27ef3264918ad8e3391.jpg?image_crop_resized=768x432";
        writeStringDataLocally(key: videoThumbnail, value: thumbnail);
        writeStringDataLocally(key: videoURl, value: videoUrl);
        writeStringDataLocally(key: dashBoardData, value: '');
        setState(() {});
        if (Platform.isAndroid) {
          TopAlert.showAlert(context, data.error, true);
        }
      } else if (data is CustomError) {
        TopAlert.showAlert(context, data.errorMessage, true);
        videoUrl = "https://fast.wistia.net/embed/iframe/c568dpkzq7";
        thumbnail =
        "https://embed-ssl.wistia.com/deliveries/7b064f6bfc25e88da280b27ef3264918ad8e3391.jpg?image_crop_resized=768x432";
        writeStringDataLocally(key: videoThumbnail, value: thumbnail);
        writeStringDataLocally(key: videoURl, value: videoUrl);
        setState(() {});
      } else if (data is Exception) {
        videoUrl = "https://fast.wistia.net/embed/iframe/c568dpkzq7";
        thumbnail =
        "https://embed-ssl.wistia.com/deliveries/7b064f6bfc25e88da280b27ef3264918ad8e3391.jpg?image_crop_resized=768x432";
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
    _sub?.cancel();
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

  ///In app purchase
  void _listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) {
    purchaseDetailsList.forEach((PurchaseDetails purchaseDetails) async {
      if (purchaseDetails.status == PurchaseStatus.pending) {
        bloc.showProgressLoader(true);
        var _duration = Duration(seconds: 15);
        Timer(_duration, _navigationToNextPage);
      } else {
        if (purchaseDetails.status == PurchaseStatus.error) {
          if (purchaseDetails.error.code == 'purchase_error') {
            handleError(
                AppLocalizations.of(context).translate("purchase_error"));
          } else {
            handleError(purchaseDetails.error.message);
          }
        } else if (purchaseDetails.status == PurchaseStatus.purchased) {
          bool valid = await _verifyPurchase(purchaseDetails);
          if (valid) {
            deliverProduct(purchaseDetails);
          } else {
            _handleInvalidPurchase(purchaseDetails);
            return;
          }
        }

        if (purchaseDetails.pendingCompletePurchase) {
          await InAppPurchaseConnection.instance
              .completePurchase(purchaseDetails);
        }
      }
    });
  }

  void _handleInvalidPurchase(PurchaseDetails purchaseDetails) {
    setState(() {
      if (Platform.isIOS) {
        final action = CupertinoAlertDialog(
          title: Text(AppLocalizations.of(context).translate("app_name")),
          content: Text("${purchaseDetails.error.message}"),
          actions: <Widget>[
            CupertinoDialogAction(
                isDefaultAction: true,
                child: Text(AppLocalizations.of(context).translate("ok")),
                onPressed: () {
                  Navigator.of(context).pop();
                }),
          ],
        );
        showCupertinoModalPopup(context: context, builder: (context) => action);
      }
      bloc.showProgressLoader(false);
    });
  }

  Future<void> initStoreInfo(String value) async {
    if (memberInfo == null || memberInfo.id == null) {
      final bool isAvailable = await _connection.isAvailable();
      if (!isAvailable) {
        setState(() {
          _isAvailable = isAvailable;
          _products = [];
          _notFoundIds = [];
          bloc.showProgressLoader(false);
          _loading = false;
        });
        return;
      }

      ProductDetailsResponse productDetailResponse;
      productDetailResponse = await _connection
          .queryProductDetails(_kProductConsumableIdYearly.toSet());
      if (productDetailResponse.error != null) {
        setState(() {
          _queryProductError = productDetailResponse.error.message;
          handleError(_queryProductError);
          _isAvailable = isAvailable;
          _products = productDetailResponse.productDetails;
          _notFoundIds = productDetailResponse.notFoundIDs;
          bloc.showProgressLoader(false);
          _loading = false;
        });
        return;
      }

      if (productDetailResponse.productDetails.isEmpty) {
        setState(() {
          _queryProductError = null;
          _isAvailable = isAvailable;
          _products = productDetailResponse.productDetails;
          _notFoundIds = productDetailResponse.notFoundIDs;
          bloc.showProgressLoader(false);
          _loading = false;
        });
        return;
      }

      setState(() {
        _isAvailable = isAvailable;
        _products = productDetailResponse.productDetails;
        _notFoundIds = productDetailResponse.notFoundIDs;
        bloc.showProgressLoader(false);
        _loading = false;
      });
      _queryProductError == null
          ? _loading ? waitToOpen() : _buyProduct()
          : null;
    }
  }

  Card _buildProductList() {
    if (_loading) {
      var _duration = Duration(milliseconds: 7000);
      Timer(_duration, _navigationToNextPage);
      return Card(
          child: (ListTile(
              leading: CircularProgressIndicator(),
              title: Text(
                  AppLocalizations.of(context).translate("fetch_products")))));
    }
    if (!_isAvailable) {
      return Card();
    }
    final ListTile productHeader = ListTile(
      title: Text(
        AppLocalizations.of(context).translate("product_sale"),
        textAlign: TextAlign.center,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          fontFamily: robotoBoldFont,
          color: appColor,
          fontSize: 18.0,
          letterSpacing: -0.39,),
      ),);
    List<ListTile> productList = <ListTile>[];
    if (_notFoundIds.isNotEmpty) {
      productList.add(ListTile(
        title: Text('[${_notFoundIds.join(", ")}] not found',
            style: TextStyle(color: ThemeData
                .light()
                .errorColor)),
      ));
    }

    productList.addAll(_products.map(
          (ProductDetails productDetails) {
        return ListTile(
          dense: true,
          contentPadding: EdgeInsets.all(0.0),
          title: Column(
            children: <Widget>[
              Text(
                '\"${productDetails.title != null
                    ? productDetails.title
                    : ""}\"',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontFamily: robotoBoldFont,
                    color: appColor,
                    fontSize: 16.0,
                    letterSpacing: -0.39),
              ),
              SizedBox(
                height: 5.0,
              ),
              Text(
                  productDetails.description != null
                      ? productDetails.description
                      : "",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.w300,
                      fontFamily: robotoBoldFont,
                      color: appColor,
                      fontSize: 14.0,
                      letterSpacing: -0.39)),
              SizedBox(
                height: 20.0,
              ),
              FlatButton(
                child: Text(AppLocalizations.of(context).translate("buy_at") +
                    " " +
                    productDetails.price),
                color: btnAppColor,
                textColor: Colors.white,
                onPressed: () {
                  PurchaseParam purchaseParam = PurchaseParam(
                      productDetails: productDetails,
                      applicationUserName:
                      '${userDataModel.username}_${userDataModel.id
                          .toString()}',
                      sandboxTesting: true);
                  _connection.buyNonConsumable(purchaseParam: purchaseParam);
                  bloc.showProgressLoader(false);
                  Navigator.of(context).pop();
                },
              )
            ],
          ),
        );
      },
    ));

    return Card(
      child: Center(
        child: Column(
          children: <Widget>[
            productHeader,
            Divider(),
          ] +
              productList,
        ),
      ),
    );
  }

  void deliverProduct(PurchaseDetails purchaseDetails) async {
    bloc.showProgressLoader(false);
    if (purchaseDetails.productID == kNonConsumableIdYear) {
      await ConsumableStore.save(purchaseDetails.purchaseID);
      bloc.showProgressLoader(false);
      callApiUpdatePaymentInApp(purchaseDetails, "yearly");
    }
  }

  Future<bool> _verifyPurchase(PurchaseDetails purchaseDetails) {
    if (purchaseDetails.error == null) {
      if (purchaseDetails.productID == kNonConsumableIdYear) {
        return Future<bool>.value(true);
      }
    }
    // IMPORTANT!! Always verify a purchase before delivering the product.
    // For the purpose of an example, we directly return true.
    return Future<bool>.value(false);
  }

  void handleError(String error) {
    setState(() {
      if (Platform.isIOS) {
        final action = CupertinoAlertDialog(
          title: Text(AppLocalizations.of(context).translate("app_name")),
          content: Text("$error"),
          actions: <Widget>[
            CupertinoDialogAction(
                isDefaultAction: true,
                child: Text(AppLocalizations.of(context).translate("ok")),
                onPressed: () {
                  Navigator.of(context).pop();
                }),
          ],
        );
        showCupertinoModalPopup(context: context, builder: (context) => action);
      }
      bloc.showProgressLoader(false);
    });
  }

  Future<void> consume(String id) async {
    await ConsumableStore.consume(id);
  }

  void _buyProduct() {
    showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0)),
              //this right here
              content: StatefulBuilder(
                builder: (BuildContext context,
                    void Function(void Function()) setState) {
                  return Container(
                    height: 250.0,
                    width: 250.0,
                    child: ListView(
                      children: [
                        _buildProductList(),
                      ],
                    ),
                  );
                },
              ),
              actions: <Widget>[
                FlatButton(
                  child: Text(AppLocalizations.of(context).translate("cancel")),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  void waitToOpen() {
    var _duration = Duration(seconds: 2);
    Timer(_duration, _buyProduct);
  }

  void _navigationToNextPage() {
    setState(() {
      bloc.showProgressLoader(false);
    });
  }

  void _restoreActionDialog() async {
    bloc.showProgressLoader(true);
    final QueryPurchaseDetailsResponse purchaseResponse =
    await _connection.queryPastPurchases();
    if (purchaseResponse.error != null) {
      bloc.showProgressLoader(false);
    }
    bool called = false;
    for (PurchaseDetails purchase in purchaseResponse.pastPurchases) {
      if (await _verifyPurchase(purchase)) {
        if (purchase.pendingCompletePurchase) {
          called = true;
          bloc.showProgressLoader(true);
          InAppPurchaseConnection.instance
              .completePurchase(purchase)
              .then((BillingResultWrapper value) {
            if (value.responseCode == BillingResponse.ok) {
              String message = value.debugMessage;
              _showRestoreDialog(message, purchase);
            } else {
              _handleErrorPurchase(value.debugMessage);
            }
          });
        }
      }
    }
    if (!called) {
      bloc.showProgressLoader(false);
      _handleErrorPurchase(
          AppLocalizations.of(context).translate("no_past_purchase"));
    }
  }

  void _showRestoreDialog(String message, PurchaseDetails purchase) {
    if (message == null) {
      _validatePurchase(purchase);
    } else {
      final action = CupertinoAlertDialog(
        title: Text(AppLocalizations.of(context).translate("app_name")),
        content: Text("$message"),
        actions: <Widget>[
          CupertinoDialogAction(
            isDefaultAction: true,
            child: Text(AppLocalizations.of(context).translate("ok")),
            onPressed: () {
              bloc.showProgressLoader(false);
              _validatePurchase(purchase);
              Navigator.of(context).pop();
            },
          ),
        ],
      );
      showCupertinoModalPopup(context: context, builder: (context) => action);
    }
  }

  void _validatePurchase(PurchaseDetails purchaseDetails) async {
    bool valid = await _verifyPurchase(purchaseDetails);
    if (valid) {
      bloc.showProgressLoader(true);
      deliverProduct(purchaseDetails);
    } else {
      _handleInvalidPurchase(purchaseDetails);
      return;
    }
  }

  void _handleErrorPurchase(String debugMessage) {
    setState(() {
      if (Platform.isIOS) {
        final action = CupertinoAlertDialog(
          title: Text(AppLocalizations.of(context).translate("app_name")),
          content: Text("\n$debugMessage\n"),
          actions: <Widget>[
            CupertinoDialogAction(
                isDefaultAction: true,
                child: Text(AppLocalizations.of(context).translate("ok")),
                onPressed: () {
                  Navigator.of(context).pop();
                }),
          ],
        );
        showCupertinoModalPopup(context: context, builder: (context) => action);
      }
      bloc.showProgressLoader(false);
    });
  }

  void callApiUpdatePaymentInApp(PurchaseDetails purchaseDetails, String type) {
    if (!ispaymentCalled) {
      bloc.showProgressLoader(true);
      ispaymentCalled = true;
      Map<String, dynamic> request = Map();
      request.putIfAbsent('user_name', () => userDataModel.username);
      request.putIfAbsent('txn_date', () => purchaseDetails.transactionDate);
      request.putIfAbsent('purchase_type', () => type == "monthly" ? "1" : "2");
      request.putIfAbsent('deviceType', () => '2');
      request.putIfAbsent('orderId', () => purchaseDetails.purchaseID);
      request.putIfAbsent('productId', () => purchaseDetails.productID);
      request.putIfAbsent('insecure', () => 'cool');
      request.putIfAbsent('cookie', () => cookies);
      writeStringDataLocally(
          key: inAppPurchaseData, value: jsonEncode(request));
      bloc.purchasedMonthUpdate(context, request);
    }
  }

  void _navigateToMonth(int position) async {
    var result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              VideoListing(
                  monthListing[position].label == null
                      ? '月1：奠定基础'
                      : '${monthListing[position].label}',
                  monthListing[position].lastActivity == null
                      ? '1'
                      : monthListing[position].month)),
    );
    if (result != null) {
      if (result) {
        Map<String, String> map = Map<String, String>();
        map.putIfAbsent("cookie", () => cookies);
        bloc.apiCall(map, context);
      }
    }
  }

  void openInAppDialog(int position) {
    monthPurchasingFor =
    monthListing[position].month == null ? "1" : monthListing[position].month;
    var callInApp = false;
    if (monthListing[position].lastActivity == null) {
      callInApp = true;
      _openInAppDialogBool(callInApp);
    } else {
      bloc.showProgressLoader(true);
      utcTimeWorldClock(position, callInApp);
    }
  }

  void utcTimeWorldClock(int position, bool callInApp) async {
    try {
      final response =
      await http.get('http://worldclockapi.com/api/json/utc/now');
      if (response != null) {
        if (response.body != null) {
          Map data = jsonDecode(response.body);
          if (data != null && data.length > 0) {
            if (data['currentDateTime'] != null &&
                data['currentDateTime']
                    .toString()
                    .isNotEmpty) {
              bloc.showProgressLoader(false);
              int utcTime = getDateTimeStamp(
                  data['currentDateTime'], 'yyyy-MM-dd HH:mm:ss');
              _conditionSub(position, utcTime, callInApp);
            } else {
              utcTimeShowCase(position, callInApp);

              /// CURRENT TIME NOT GET
            }
          } else {
            utcTimeShowCase(position, callInApp);

            /// MAP DATA IS NULL
          }
        } else {
          utcTimeShowCase(position, callInApp);

          /// RESPONSE BODY NULL
        }
      } else {
        utcTimeShowCase(position, callInApp);

        /// RESPONSE NULL
      }
    } catch (e) {
      utcTimeShowCase(position, callInApp);
      print(e);
    }
  }

  void utcTimeShowCase(int position, bool callInApp) async {
    try {
      final response = await http.get(
          'https://showcase.linx.twenty57.net:8081/UnixTime/tounixtimestamp?datetime=now');
      if (response != null) {
        if (response.body != null) {
          Map data = jsonDecode(response.body);
          if (data != null && data.length > 0) {
            if (data['UnixTimeStamp'] != null &&
                data['UnixTimeStamp']
                    .toString()
                    .isNotEmpty) {
              bloc.showProgressLoader(false);
              int utcTime = int.parse(data['UnixTimeStamp']);
              _conditionSub(position, utcTime, callInApp);
            } else {
              utcTimeFromCalendar(position, callInApp);

              /// CURRENT TIME NOT GET
            }
          } else {
            utcTimeFromCalendar(position, callInApp);

            /// MAP DATA IS NULL
          }
        } else {
          utcTimeFromCalendar(position, callInApp);

          /// RESPONSE BODY NULL
        }
      } else {
        utcTimeFromCalendar(position, callInApp);

        /// RESPONSE NULL
      }
    } catch (e) {
      utcTimeFromCalendar(position, callInApp);
      print(e);
    }
  }

  void utcTimeFromCalendar(int position, bool callInApp) {
    bloc.showProgressLoader(false);
    int utcTime = DateTime
        .now()
        .millisecondsSinceEpoch;
    _conditionSub(position, utcTime, callInApp);
  }

  void _conditionSub(int position, int utcTime, bool isCall) {
    int unlockTime = getDateTimeStamp(
        monthListing[position].lastActivity, 'yyyy-MM-dd HH:mm:ss');
    if (utcTime > unlockTime) {
      isCall = true;
      _openInAppDialogBool(isCall);
    } else {
      TopAlert.showAlert(context,
          AppLocalizations.of(context).translate("purchase_message"), true);
    }
  }
}
