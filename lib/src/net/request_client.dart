import 'package:dio/dio.dart';
import 'package:get_base/src/net/function/custom_function.dart';

import 'api_response.dart';
import 'app_dio.dart';
import 'config/repository_config.dart';
import 'network_exception.dart';
import 'transformer/http_transformer.dart';

///请求类型枚举
enum Method { get, post, delete, put, patch, head }

///请求类型值
const _methodValues = {
  Method.get: 'get',
  Method.post: 'post',
  Method.delete: 'delete',
  Method.put: 'put',
  Method.patch: 'patch',
  Method.head: 'head',
};

/// 基础请求管理工具
/// version: 1.0
class RequestClient {
  // 工厂模式获取单例
  static final RequestClient _instance = RequestClient._internal();

  RequestClient._internal();

  factory RequestClient() => _instance;

  /// 存放dio，不同的baseUrl创建不同的dio
  /// 使用baseUrl作为key，存放dio
  final Map<String, AppDio> _dioMap = {};

  /// 请求方法
  Future request({
    required String url,
    required RepositoryConfig config,
    Method method = Method.get,
    Options? options,
    data,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
    required HttpTransformer transformer,
    required Success success,
    required Fail fail,
    MessageBack? messageBack,
  }) async {
    try {
      Response response = await _checkDio(config: config).request(
        url,
        options: _checkOptions(method, options),
        data: data,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      _onSuccess(
        response: response,
        success: success,
        fail: fail,
        transformer: transformer,
        messageBack: messageBack,
      );
    } on DioError catch (e) {
      final NetworkException netError = parseException(e);
      _onFail(code: netError.code, msg: netError.message, fail: fail);
    }
  }

  /// 根据baseUrl获取dio
  /// 如果[_dioMap]中的key不存在baseUrl，则创建新dio
  AppDio _checkDio({
    required RepositoryConfig config,
  }) {
    if (_dioMap.keys.any((element) => element == config.baseUrl)) {
      return _dioMap[config.baseUrl]!;
    } else {
      AppDio dio = AppDio(
        config: config,
      );
      _dioMap.addAll({config.baseUrl: dio});
      return dio;
    }
  }

  /// 检查请求配置
  Options _checkOptions(Method method, Options? options) {
    options ??= Options();
    options.method = _methodValues[method];
    return options;
  }

  /// 请求成功处理
  /// [response] 结果
  /// [success] 成功回调
  /// [fail] 失败回调
  /// [transformer] 解析体
  /// [messageBack] msg信息回调，仅在[success]下回调，如果接口不成功，是通过[fail]回调msg信息
  void _onSuccess({
    required Response response,
    required Success success,
    required Fail fail,
    required HttpTransformer transformer,
    MessageBack? messageBack,
  }) {
    ApiResponse apiResponse = transformer.parse(response);
    if (apiResponse.ok) {
      success.call(apiResponse.data);
      messageBack?.call(apiResponse.msg ?? "");
    } else {
      if (apiResponse.error!.code == 401) {
        // 登录失效
        _onFail(code: apiResponse.error!.code, msg: apiResponse.error!.message, fail: fail);
      } else {
        fail.call(apiResponse.error!.code, apiResponse.error!.message);
      }
    }
  }

  /// 请求失败处理
  void _onFail({
    required int code,
    required String msg,
    required Fail fail,
  }) {
    // todo 还没有对登录失效进行处理
    fail.call(code, msg);
  }
}
