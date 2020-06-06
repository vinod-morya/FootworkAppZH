import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import '../network/_HttpClient.dart';

class ApiClient {
  final ApiService _liveService;

  ApiClient._(this._liveService);

  factory ApiClient.create(HttpClient client) {
    final liveService = _ServiceImpl(client);
    return ApiClient._(liveService);
  }

  ApiService get liveService => _liveService;
}

abstract class ApiService {
  Future<dynamic> apiPostRequest(BuildContext context, String url,
      [Map<String, dynamic> request]);

  Future<dynamic> apiPutRequest(
      BuildContext context, String url, Map<String, dynamic> request);

  Future<dynamic> apiGetRequest(BuildContext context, String url);

  Future<dynamic> apiDeleteCustom(String url);

  Future<dynamic> apiDelete(String url, Map<String, dynamic> request);

  Future<dynamic> apiMultipartRequest(BuildContext context, String url,
      Map<String, dynamic> data, String apiType);
}

class _ServiceImpl implements ApiService {
  final HttpClient client;

  _ServiceImpl(this.client);

  @override
  Future apiPostRequest(BuildContext context, String url,
      [Map<String, dynamic> data]) async {
    String newUrl = "";
    if (data != null) {
      newUrl = url;
      data.putIfAbsent("app_type", () => "1");
    } else {
      newUrl = url + "&app_type=1";
    }
//    try {
//      if (data != null && data.length > 0) {
//            print('POST : $url request -> $data');
//          }
//    } catch (e) {
//      print(e);
//    }
    final response = await client.post("$newUrl", body: json.encode(data));
    print('POST : $url response -> ${response.body}');
    return response;
  }

  @override
  Future apiGetRequest(BuildContext context, String url) async {
    final response = await client.get(url + "&app_type=1");
    print('GET : $url response -> ${response.body}');
    return response;
  }

  @override
  Future apiDelete(String url, Map map) async {}

  @override
  Future apiPutRequest(
      BuildContext context, String url, Map<String, dynamic> request) async {
//    try {
//      if (request != null && request.length > 0) {
//            print('PUT : $url request -> $request');
//          }
//    } catch (e) {
//      print(e);
//    }
    final response = await client.put("$url", body: json.encode(request));
    print('PUT : $url response -> ${response.body}');
    return response;
  }

  @override
  Future apiDeleteCustom(String url) async {
    final response = await client.delete("$url");
//    print('DELETE : $url response -> ${response.body}');
    return response;
  }

  @override
  Future apiMultipartRequest(BuildContext context, String url,
      Map<String, dynamic> data, String apiType) async {
    data.putIfAbsent("app_type", () => "1");
//    try {
//      if (data != null && data.length > 0) {
//        print('MULTIPART : $url request -> $data');
//      }
//    } catch (e) {
//      print(e);
//    }
    final response = await client.mutipartPost(url, data, apiType);
    print('MULTIPART : $url response -> ${response.body}');
    return response;
  }
}
