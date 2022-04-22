import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'interceptors/authentication_interceptor.dart';

// Must be top-level function
_parseAndDecode(String response) {
  return jsonDecode(response);
}

parseJson(String text) {
  return compute(_parseAndDecode, text);
}

class HttpClient {
  //region Singleton
  HttpClient._internal();

  static final _instance = HttpClient._internal();

  factory HttpClient() {
    return _instance;
  }

  //endregion

  final Dio _dio = _createDio(false);
  final Dio _authorizedDio = _createDio(true);

  static _createDio(bool addAuthInterceptor) {
    var options = BaseOptions(
        baseUrl: const String.fromEnvironment("API_URL"),
        connectTimeout: 2000,
        receiveTimeout: 5000,
        sendTimeout: 5000,
        contentType: 'application/json; charset=utf8',
        responseType: ResponseType.json);

    var dio = Dio(options);
    if (addAuthInterceptor) {
      dio.interceptors.add(AuthenticationInterceptor());
    }

    (dio.transformer as DefaultTransformer).jsonDecodeCallback = parseJson;

    return dio;
  }

  Dio getClient() {
    return _dio;
  }

  Dio getAuthorizedClient() {
    return _authorizedDio;
  }
}
