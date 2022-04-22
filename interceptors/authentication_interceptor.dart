import 'package:dio/dio.dart';
import '../repositories/token_repository.dart';

class AuthenticationInterceptor extends Interceptor {
  AuthenticationInterceptor();

  @override
  Future onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    var repo = TokenRepository();
    var token = repo.getToken();

    if (token == null) {
      return handler.reject(
          DioError(
              requestOptions: options,
              error: "Unauthorized",
              response: null,
              type: DioErrorType.cancel),
          true);
    }

    options.headers["Authorization"] = "Bearer $token";

    return super.onRequest(options, handler);
  }
}
