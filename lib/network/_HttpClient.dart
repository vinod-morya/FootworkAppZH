import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class HttpClient {
  // http headers
  final Map<String, String> headers;

  HttpClient._(this.headers);

  factory HttpClient.createGuestClient(String deviceId, bool isLoggedIn) {
    var platform;
    if (Platform.isAndroid)
      platform = '1';
    else if (Platform.isIOS)
      platform = '2';
    else
      platform = '1';

    Map<String, String> _headers;
    if (isLoggedIn) {
      _headers = {
        'devtoken': deviceId,
        'content-type': 'application/json',
        'platform': platform,
      };
    } else {
      _headers = {
        'devtoken': deviceId,
        'platform': platform,
        'content-type': 'application/json',
      };
    }
    return HttpClient._(_headers);
  }

  Future<http.Response> get(url, {Map<String, String> headers}) {
    return _execute(
        (client) => client.get(url, headers: headers ?? this.headers));
  }

  Future<http.Response> post(url, {Map<String, String> headers, body}) {
    return _execute((client) =>
        client.post(url, body: body, headers: headers ?? this.headers));
  }

  Future<http.Response> mutipartPost(
      url, Map<String, dynamic> body, String apiType,
      {Map<String, String> headers}) async {
    List<String> _keyList = body.keys.toList();
    List<dynamic> _valuesList = body.values.toList();

    var request = http.MultipartRequest(
      apiType,
      Uri.parse(url),
    );
    request.headers.addAll(headers ?? this.headers);

    for (int i = 0; i < body.length; i++) {
      if (_valuesList[i] is File) {
        request.files.add(
            await MultipartFile.fromPath(_keyList[i], _valuesList[i].path));
      } else
        request.fields[_keyList[i]] = _valuesList[i];
    }
    http.Response response =
        await http.Response.fromStream(await request.send());

    return response;
  }

  Future<http.Response> delete(url, {Map<String, String> headers}) {
    return _execute(
        (client) => client.delete(url, headers: headers ?? this.headers));
  }

  Future<http.Response> deleteCustom(url, [body]) async {
    var rq = Request('DELETE', Uri.parse(url));
    rq.bodyFields = body;
    return await http.Client().send(rq).then(Response.fromStream);
  }

  Future<http.Response> put(url,
      {Map<String, String> headers, body, Encoding encoding}) {
    return _execute((client) =>
        client.put(url, headers: headers ?? this.headers, body: body));
  }

  Future<T> _execute<T>(Future<T> fn(http.Client client)) async {
    final client = http.Client();
    try {
//      return await fn(client).timeout(Duration(seconds: 300));
      return await fn(client);
    } finally {
      client.close();
    }
  }
}
