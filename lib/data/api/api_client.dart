import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/foundation.dart' as Foundation;
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/request/request.dart';
import 'package:http/http.dart' as Http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/app_constants.dart';
import '../model/error_response.dart';

class ApiClient extends GetxService {
  final String appBaseUrl;
  final SharedPreferences sharedPreferences;
  static final String noInternetMessage = 'connection_to_api_server_failed'.tr;
  final int timeoutInSeconds = 90;

  String token = "";
  Map<String, String> _mainHeaders = {};

  ApiClient({required this.appBaseUrl, required this.sharedPreferences}) {
    token = sharedPreferences.getString(AppConstants.TOKEN) ??
        "Basic Y29yZV9jbGllbnQ6c2VjcmV0";
    if (Foundation.kDebugMode) {
      print('Token: $token');
    }
    updateHeader(
      token,
      null,
      sharedPreferences.getString(AppConstants.LANGUAGE_CODE),
      0,
    );
  }

  void updateHeader(
      String token, List<int>? zoneIDs, String? languageCode, int moduleID) {
    Map<String, String> header = {
      'Content-Type': 'application/json; charset=utf-8',
      AppConstants.LOCALIZATION_KEY:
          languageCode ?? AppConstants.languages[0].languageCode,
      'Authorization': token
    };
    header.addAll({AppConstants.MODULE_ID: moduleID.toString()});
    _mainHeaders = header;
  }

  Future<Response> getData(String uri,
      {Map<String, dynamic>? query, Map<String, String>? headers}) async {
    try {
      if (Foundation.kDebugMode) {
        print('====> API Call: $uri\nHeader: $_mainHeaders');
      }
      Http.Response response = await Http.get(
        Uri.parse(appBaseUrl + uri).replace(queryParameters: query),
        headers: headers ?? _mainHeaders,
      ).timeout(Duration(seconds: timeoutInSeconds));
      return handleResponse(response, uri);
    } catch (e) {
      print('------------${e.toString()}');
      return Response(statusCode: 1, statusText: noInternetMessage);
    }
  }

  Future<Response> postData(String uri, dynamic body,
      Map<String, String>? headers) async {
    try {
      String requestBody = jsonEncode(body);
      if (Foundation.kDebugMode) {
        print('====> API Call: $uri\nHeader: $_mainHeaders');
        print('====> API Body: $requestBody');
      }
      Http.Response response = await Http.post(
        Uri.parse(appBaseUrl + uri),
        body: requestBody,
        headers: headers,
      ).timeout(Duration(seconds: timeoutInSeconds));
      return handleResponse(response, uri);
    } catch (e) {
      print(e);
      return Response(statusCode: 1, statusText: noInternetMessage);
    }
  }

  Future<Response> postDataLogin(String uri, dynamic body,
      Map<String, String>? headers) async {
    try {
      if (Foundation.kDebugMode) {
        print('====> API Call: $uri\nHeader: ${headers ?? _mainHeaders}');
        print('====> API Body: $body');
      }
      Http.Response response = await Http.post(
        Uri.parse(appBaseUrl + uri),
        body: body,
        headers: headers,
      ).timeout(Duration(seconds: timeoutInSeconds));
      return handleResponse(response, uri);
    } catch (e) {
      return Response(statusCode: 1, statusText: noInternetMessage);
    }
  }

  Future<Response> postMultipartData(
      String uri, Map<String, String> body, List<MultipartBody> multipartBody,
      {required Map<String, String>? headers}) async {
    try {
      if (Foundation.kDebugMode) {
        print('====> API Call: $uri\nHeader: $_mainHeaders');
        print('====> API Body: $body with ${multipartBody.length} picture');
      }
      Http.MultipartRequest request =
          Http.MultipartRequest('POST', Uri.parse(appBaseUrl + uri));
      request.headers.addAll(headers ?? _mainHeaders);
      for (MultipartBody multipart in multipartBody) {
        if (multipart.file != null) {
          Uint8List list = await multipart.file.readAsBytes();
          request.files.add(Http.MultipartFile(
            multipart.key,
            multipart.file.readAsBytes().asStream(),
            list.length,
            filename: '${DateTime.now().toString()}.png',
          ));
        }
      }
      request.fields.addAll(body);
      Http.Response response =
          await Http.Response.fromStream(await request.send());
      return handleResponse(response, uri);
    } catch (e) {
      return Response(statusCode: 1, statusText: noInternetMessage);
    }
  }

  Future<Response> putData(String uri, dynamic body,
      {required Map<String, String> headers}) async {
    try {
      if (Foundation.kDebugMode) {
        print('====> API Call: $uri\nHeader: $_mainHeaders');
        print('====> API Body: $body');
      }
      Http.Response response = await Http.put(
        Uri.parse(appBaseUrl + uri),
        body: jsonEncode(body),
        headers: headers ?? _mainHeaders,
      ).timeout(Duration(seconds: timeoutInSeconds));
      return handleResponse(response, uri);
    } catch (e) {
      return Response(statusCode: 1, statusText: noInternetMessage);
    }
  }

  Future<Response> deleteData(String uri,
      {Map<String, String>? headers}) async {
    try {
      if (Foundation.kDebugMode) {
        print('====> API Call: $uri\nHeader: $_mainHeaders');
      }
      Http.Response response = await Http.delete(
        Uri.parse(appBaseUrl + uri),
        headers: headers ?? _mainHeaders,
      ).timeout(Duration(seconds: timeoutInSeconds));
      return handleResponse(response, uri);
    } catch (e) {
      return Response(statusCode: 1, statusText: noInternetMessage);
    }
  }

  Response handleResponse(Http.Response response, String uri) {
    dynamic body;
    try {
      body = jsonDecode(utf8.decode(response.bodyBytes));
    } catch (e) {}
    Response response0 = Response(
      body: body ?? response.body,
      bodyString: response.body.toString(),
      request: Request(
          headers: response.request!.headers,
          method: response.request!.method,
          url: response.request!.url),
      headers: response.headers,
      statusCode: response.statusCode,
      statusText: response.reasonPhrase,
    );
    if (response0.statusCode != 200 &&
        response0.body != null &&
        response0.body is! String) {
      if (response0.body.toString().startsWith('{errors: [{code:')) {
        ErrorResponse errorResponse = ErrorResponse.fromJson(response0.body);
        response0 = Response(
            statusCode: response0.statusCode,
            body: response0.body,
            statusText: errorResponse.errors![0].message);
      } else if (response0.body.toString().startsWith('{message')) {
        response0 = Response(
            statusCode: response0.statusCode,
            body: response0.body,
            statusText: response0.body['message']);
      }
    } else if (response0.statusCode != 200 && response0.body == null) {
      response0 = Response(statusCode: 0, statusText: noInternetMessage);
    }
    if (Foundation.kDebugMode) {
      print(
          '====> API Response: [${response0.statusCode}] $uri\n${response0.body}');
    }
    return response0;
  }
}

class MultipartBody {
  String key;
  XFile file;

  MultipartBody(this.key, this.file);
}
