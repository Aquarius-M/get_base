import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// @author: zx
/// @description: Dio拦截器
class DioInterceptor extends Interceptor {

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    //如果request的path参数是完整的url,以http开头，则baseUrl不起作用
    if (kDebugMode) {
      log("********** Request **********\n"
          "method: ${options.method} url: ${options.path.contains("://") ? "" : options.baseUrl}${options.path}\n"
          "header: ${options.headers}\n"
          "param: ${prettyJson(options.queryParameters)}\n"
          "data: ${prettyJson(options.data)}\n");
    }
    return handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (kDebugMode) {
      log("********** Response **********\n"
          "url: ${response.requestOptions.path.contains("://") ? "" : response.requestOptions.baseUrl}${response.requestOptions.path}\n"
          "statusMessage: ${response.statusMessage}\n"
          "statusCode: ${response.statusCode}\n"
          "data: ${prettyJson((response.data is String) ? jsonDecode(response.data) : response.data)}");
    }
    super.onResponse(response, handler);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    if (kDebugMode) {
      log("********** error **********\n"
          "url: ${err.requestOptions.path.contains("://") ? "" : err.requestOptions.baseUrl}${err.requestOptions.path}\n"
          "type: ${err.type}\n"
          "error: ${err.error}");
    }
    super.onError(err, handler);
  }
}

/// 创建多行 JSON
String prettyJson(dynamic json) {
  var spaces = ' ' * 4;
  var encoder = JsonEncoder.withIndent(spaces);
  return encoder.convert(json);
}
