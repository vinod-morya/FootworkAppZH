//import 'dart:convert';
//
//import 'package:flutter/cupertino.dart';
//import 'package:flutter/material.dart';
//import 'package:flutter_local_notifications/flutter_local_notifications.dart';
//import 'package:footwork_chinese/constants/app_constants.dart';
//
//import 'Utility.dart';
//
//class LocalPushNotification {
//  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
//  BuildContext context;
//
//  void initLocalPushNotification() {
//    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
//    var android = new AndroidInitializationSettings('@mipmap/ic_launcher');
//    var iOS = new IOSInitializationSettings(
//        defaultPresentAlert: true,
//        defaultPresentBadge: true,
//        defaultPresentSound: true,
//        requestAlertPermission: true);
//    var initSettings = new InitializationSettings(android, iOS);
//    flutterLocalNotificationsPlugin.initialize(initSettings,
//        onSelectNotification: onSelectNotification);
//  }
//
//  showNotification(Map notificationData, BuildContext context) async {
//    this.context = context;
//    var android = new AndroidNotificationDetails(
//        '1002', 'Submittal Tree', 'Submittal App',
//        priority: Priority.High, importance: Importance.Max);
//    var iOS = new IOSNotificationDetails(
//        presentAlert: true, presentBadge: true, presentSound: true);
//    var platform = new NotificationDetails(android, iOS);
//    await flutterLocalNotificationsPlugin.show(
//        0,
//        notificationData['notification']['title'],
//        notificationData['notification']['body'],
//        platform,
//        payload: jsonEncode(notificationData['data']).toString());
//  }
//
//  Future onSelectNotification(String payload) async {
//    Map map = json.decode((payload));
//    var type = map['notyType'];
//    var projectID = map['projectID'];
//    var notyId = map['notyId'];
//    var status = map['status'];
//    var cRole = map["userType"];
//    var model;
//    getStringDataLocally(key: userData).then((onValue) {
//      switch (type) {
//        case '0':
//        case '1':
//        case '2':
//        case '12':
//        case '13':
//          break;
//        case '3':
//        case '4':
//        case '5':
//        case '6':
//          break;
//        case '7':
//        case '8':
//          break;
//        case '9':
//        case '10':
//        case '11':
//          break;
//        case '14':
//        case '15':
//        case '16':
//        case '17':
//        default:
//          break;
//      }
//    });
//  }
//}
