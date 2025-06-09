import 'package:dio/dio.dart';
import 'package:frontend/_providers/auth_provider.dart';
import 'package:provider/provider.dart';

import 'rac_storage.dart';

class BasicAuthInterceptor extends InterceptorsWrapper {
  List<String> insecureAPIs = ['/auth/login', 'auth/refresh'];

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    if (!insecureAPIs.any((api) => options.path.contains(api))) {
      String? token = await RACStorage.getToken(); // Fetch latest token
      if (token != null) {
        options.headers["Authorization"] = "Bearer $token"; // Attach token
      }
    }
    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      /* await refreshToken();
      return handler.resolve(await _retryRequest(err.requestOptions)); */
    }
    super.onError(err, handler);
  }

/*
static Future<Response<dynamic>> _retryRequest(
      RequestOptions requestOptions) async {
    String? newToken = await RACStorage.getToken();
    requestOptions.headers["Authorization"] =
        "Bearer $newToken"; // Update token
    return await _dio.fetch(requestOptions);
  }

  static Future<void> refreshToken() async {
    try {
      Response response = await _dio
          .post("/auth/refresh", data: {"refresh_token": "your_refresh_token"});
      String newToken = response.data["access_token"];
      await RACStorage.saveToken(newToken); // Save new token
    } catch (e) {
      print("Token refresh failed");
    }
  }*/
}
