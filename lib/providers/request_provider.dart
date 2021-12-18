import 'dart:convert';
import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter_portfolio_web/providers/authorize_provider.dart';
import 'package:http/browser_client.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter/services.dart' show rootBundle;
import 'package:http/http.dart' as http;

import '/packet/packet.dart' as packet;

class ResponseData {
  final int statusCode;
  final String? err;
  late final packet.ResponsePresent? _responsePacket;

  ResponseData({
    required this.statusCode,
    this.err,
    packet.ResponsePresent? responsePacket,
  }) {
    _responsePacket = responsePacket;
  }

  bool isSuccess() {
    if (statusCode != 200) {
      return false;
    }

    final result = _responsePacket?.result ?? '';
    if (result != 'success') {
      return false;
    }

    return true;
  }

  String? getError() {
    if (err != null) {
      return err;
    }

    if (_responsePacket != null) {
      return _responsePacket!.error;
    }

    return null;
  }

  T? getResponsePacket<T extends packet.Packet>() {
    try {
      if (_responsePacket == null) {
        return null;
      }

      final jsonContent = json.decode(_responsePacket!.data);
      return packet.fromJson<T>(jsonContent) as T?;
    } catch (e) {
      return null;
    }
  }
}

class RequestProvider {
  bool _isInitalize = false;
  String _domain = "";

  final Map<String, String> _header = {
    //'accept': 'application/json',
    //'content-type': 'application/json',
    //'Access-Control_Allow_Origin': '*',
    //'Access-Control-Allow-Headers': 'Set-Cookie',
    //'Access-Control-Allow-Credentials': 'true',
  };

  final Map<String, String> _cookie = {};

  Future<void> initalize() async {
    if (_isInitalize == true) {
      return;
    }

    final jsonContent = await rootBundle.loadString('assets/manifest.json');
    final jsonData = json.decode(jsonContent);

    _domain = jsonData['domain'] as String? ?? '';
    print('initalize domain = ${_domain}');

    _isInitalize = true;
  }

  String getFullUrl(String url) => _domain + url;

  Future<void> _updateCookies(String headerContent) async {
    if (headerContent.isEmpty) {
      return;
    }

    try {
      final headerList = json.decode(headerContent) as List<dynamic>?;
      if (headerList == null) {
        return;
      }

      for (var header in headerList) {
        if (header is String == false) {
          continue;
        }

        header = header as String;
        if (header.startsWith('Set-Cookie:') == false) {
          continue;
        }

        var cookie = header.substring('Set-Cookie:'.length);
        cookie = cookie.substring(0, cookie.indexOf(';'));

        final seplitIndex = cookie.indexOf('=');

        final cookieName = cookie.substring(0, seplitIndex);
        final cookieValue = cookie.substring(seplitIndex + 1);

        var prefs = await SharedPreferences.getInstance();
        prefs.setString(cookieName, cookieValue);
      }

      document.cookie = await _makeCookieHeader();
    } catch (e) {
      print(e);
    }
  }

  Future<String> _makeCookieHeader() async {
    String cookieHeader = '';

    var prefs = await SharedPreferences.getInstance();

    for (var key in prefs.getKeys()) {
      final value = prefs.getString(key);
      if (value == null) {
        continue;
      }

      cookieHeader += '$key=$value; ';
    }

    return cookieHeader;
  }

  Future<Map<String, String>> _makeHeader() async {
    Map<String, String> header = {};

    for (var entry in _header.entries) {
      header[entry.key] = entry.value;
    }

    // Refuesed to set unsafe header "cookie" 에러 발생!
    //header['Cookie'] = await _makeCookieHeader();

    return header;
  }

  Future<ResponseData> _parseResponsePreset(int statusCode, String body) async {
    try {
      final jsonContent = json.decode(body);
      final responsePresent = packet.ResponsePresent.fromJson(jsonContent);

      await _updateCookies(responsePresent.header);

      return ResponseData(
        statusCode: statusCode,
        responsePacket: responsePresent,
      );
    } catch (e) {
      print(e);

      return ResponseData(
        statusCode: -1,
        err: '[json error]${e.toString()}',
      );
    }
  }

  Future<ResponseData> getMethod(String url) async {
    await initalize();

    final fullUrl = Uri.parse(getFullUrl(url));

    http.Response response;
    int statusCode = 500;

    var client = BrowserClient();
    client.withCredentials = true;

    try {
      response = await client.get(
        fullUrl,
        headers: await _makeHeader(),
      );
      statusCode = response.statusCode;
    } catch (e) {
      return ResponseData(
        statusCode: statusCode,
        err: e.toString(),
      );
    } finally {
      client.close();
    }

    return await _parseResponsePreset(statusCode, response.body);
  }

  Future<ResponseData> postMethod(String url, packet.Packet postBody) async {
    await initalize();

    late String jsonContent;

    try {
      jsonContent = json.encode(postBody.toJson());
    } catch (e) {
      return ResponseData(
        statusCode: -1,
        err: '[error][encoding error]${e.toString()}',
      );
    }

    final fullUrl = Uri.parse(getFullUrl(url));

    http.Response response;
    int statusCode = 500;

    var client = BrowserClient();
    client.withCredentials = true;

    try {
      response = await client.post(
        fullUrl,
        headers: await _makeHeader(),
        body: jsonContent,
      );
      statusCode = response.statusCode;
    } catch (e) {
      return ResponseData(
        statusCode: statusCode,
        err: e.toString(),
      );
    } finally {
      client.close();
    }

    return await _parseResponsePreset(statusCode, response.body);
  }

  Future<ResponseData> putMethod(String url, packet.Packet postBody) async {
    await initalize();

    late String jsonContent;

    try {
      jsonContent = json.encode(postBody.toJson());
    } catch (e) {
      return ResponseData(
        statusCode: -1,
        err: '[error][encoding error]${e.toString()}',
      );
    }

    final fullUrl = Uri.parse(getFullUrl(url));

    http.Response response;
    int statusCode = 500;

    var client = BrowserClient();
    client.withCredentials = true;

    try {
      response = await client.put(
        fullUrl,
        headers: await _makeHeader(),
        body: jsonContent,
      );
      statusCode = response.statusCode;
    } catch (e) {
      return ResponseData(
        statusCode: statusCode,
        err: e.toString(),
      );
    } finally {
      client.close();
    }

    return await _parseResponsePreset(statusCode, response.body);
  }

  Future<ResponseData> deleteMethod(String url) async {
    await initalize();

    final fullUrl = Uri.parse(getFullUrl(url));

    http.Response response;
    int statusCode = 500;

    var client = BrowserClient();
    client.withCredentials = true;

    try {
      response = await client.delete(
        fullUrl,
        headers: await _makeHeader(),
      );
      statusCode = response.statusCode;
    } catch (e) {
      return ResponseData(
        statusCode: statusCode,
        err: e.toString(),
      );
    } finally {
      client.close();
    }

    return await _parseResponsePreset(statusCode, response.body);
  }

  Future<bool> checkAuentication(BuildContext context) async {
    final responseData = await getMethod('/api/authentication');

    final authorizeProvider = context.read<AuthorizeProvider>();

    final isAuth = responseData.statusCode == 200 ? true : false;

    if (isAuth == true) {
      authorizeProvider.onLogin();
    } else {
      authorizeProvider.onLogout();
    }

    return isAuth;
  }
}
