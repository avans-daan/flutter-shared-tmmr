import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'interceptors/authentication_interceptor.dart';

// Must be top-level function
dynamic _parseAndDecode(String response) {
  return jsonDecode(response);
}

Future<void> parseJson(String text) {
  return compute(_parseAndDecode, text);
}

class HttpClient {
  //region Singleton
  factory HttpClient() {
    return _instance;
  }

  HttpClient._internal();

  static final _instance = HttpClient._internal();

  //endregion

  final Dio _dio = _createDio(false);
  final Dio _authorizedDio = _createDio(true);

  static Dio _createDio(bool addAuthInterceptor) {
    var options = BaseOptions(
        baseUrl: const String.fromEnvironment('API_URL'),
        connectTimeout: 2000,
        receiveTimeout: 5000,
        sendTimeout: 5000,
        contentType: 'application/json; charset=utf8',
        responseType: ResponseType.json);

    options.headers['Accept'] = 'application/json; charset=utf8';

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
