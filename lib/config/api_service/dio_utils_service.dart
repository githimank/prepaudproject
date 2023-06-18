import 'dart:developer';
import 'package:dio/dio.dart';

import 'package:shared_preferences/shared_preferences.dart';

class DioUtil {
  Dio? _instance;
  Dio? getInstance() {
    _instance ??= createDioInstance();
    return _instance;
  }

  Dio createDioInstance() {
    var dio = Dio();
    dio.interceptors.clear();
    return dio
      ..interceptors
          .add(InterceptorsWrapper(onRequest: (options, handler) async {
        final prefs = await SharedPreferences.getInstance();
        final accessToken = prefs.getString('token');
        options.headers["Authorization"] = "Bearer $accessToken";
        log(options.queryParameters.toString());
        return handler.next(options); //modify your request
      }, onResponse: (response, handler) {
        return handler.next(response);
      }, onError: (DioException e, handler) async {
        if (e.response != null) {
          try {} catch (e) {
            // debugPrint(e.toString());
            e.toString();
          }
        }
        if (DioExceptionType.unknown == e.type) {
          handler.reject(e);
        }
        log(e.toString());
        log(e.stackTrace.toString());
        log(e.requestOptions.toString());
        log(e.error.toString());
        handler.next(e);
      }));
  }
}
