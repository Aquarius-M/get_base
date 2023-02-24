import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get_base/src/net/request_client.dart';

import 'config/client_config.dart';
import 'function/custom_function.dart';
import 'config/repository_config.dart';
import 'network_exception.dart';
import 'transformer/http_transformer.dart';

/// 接口仓库基类
/// version: 1.0
abstract class BaseRepository {
  /// 设置当前仓库的dio配置项
  RepositoryConfig config();

  /// 当前仓库的请求头，因baseUrl可能不同，所以不同仓库的请求头也可能不一样
  Map<String, dynamic> getHeader();

  /// 当前仓库数据返回解析体
  HttpTransformer getTransformer();

  Future get({
    required String url,
    Options? options,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
    required Success onSuccess,
    required Fail onFail,
    MessageBack? onMessageBack,
    bool showErrorTip = true, // 显示error tip
    bool showTip = false, // 显示信息 tip
  }) async {
    await _request(
      url: url,
      options: options,
      queryParameters: queryParameters,
      cancelToken: cancelToken,
      onReceiveProgress: onReceiveProgress,
      onSuccess: onSuccess,
      onFail: onFail,
      onMessageBack: onMessageBack,
      showErrorTip: showErrorTip,
      showTip: showTip,
    );
  }

  Future post({
    required String url,
    Options? options,
    data,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
    HttpTransformer? transformer,
    required Success onSuccess,
    required Fail onFail,
    MessageBack? onMessageBack,
    bool showErrorTip = true, // 显示error tip
    bool showTip = false, // 显示信息 tip
  }) async {
    await _request(
      url: url,
      method: Method.post,
      options: options,
      data: data,
      queryParameters: queryParameters,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
      transformer: transformer,
      onSuccess: onSuccess,
      onFail: onFail,
      onMessageBack: onMessageBack,
      showErrorTip: showErrorTip,
      showTip: showTip,
    );
  }

  /// 接口请求的二次封装
  Future _request({
    required String url,
    Method method = Method.get,
    Options? options,
    data,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
    HttpTransformer? transformer,
    required Success onSuccess,
    required Fail onFail,
    MessageBack? onMessageBack,

    bool showErrorTip = true, // 显示error tip
    bool showTip = false, // 显示信息 tip
  }) async {
    /// 请求前检查工作，当返回值不为空时，拦截请求
    NetworkException? checkResult = await ClientConfig.beforeRequest.call();
    if (checkResult != null) {
      debugPrint("\x1B[31m请求前检查工作异常 ===> ${checkResult.toString()}\x1B[0m");
      onFail.call(checkResult.code, checkResult.message);
      return;
    }
    await RequestClient().request(
      url: url,
      config: config(),
      method: method,
      options: options?.copyWith(headers: getHeader()) ?? Options(headers: getHeader()),
      data: data,
      queryParameters: queryParameters,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
      transformer: transformer ?? getTransformer(),
      success: onSuccess,
      fail: (code, msg) {
        onFail.call(code, msg);
        // 当前请求显示错误tip，且该请求非取消请求的情况下
        if (showErrorTip && code != HttpExceptionCode.cancelError) ClientConfig.toastCall?.call(msg);
      },
      messageBack: (msg) {
        if (showTip) ClientConfig.toastCall?.call(msg);
      },
    );
  }

  /// 取消请求
  _onCancel() {

  }
}
