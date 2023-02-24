import 'package:get_base/get_base.dart';

/// 连接超时时间
const int _connectTimeout = 1000 * 60;

/// 接收超时时间
const int _receiveTimeout = 1000 * 60;

/// 发送超时时间
const int _sendTimeout = 1000 * 60;

/// 仓库配置项
class RepositoryConfig {
  RepositoryConfig({
    required this.baseUrl,
    this.connectTimeout = _connectTimeout,
    this.sendTimeout = _sendTimeout,
    this.receiveTimeout = _receiveTimeout,
    this.interceptors,
    this.useContentTypeInterceptor = true,
    this.useLog = true,
    this.logger,
  });

  /// 请求基本地址
  final String baseUrl;

  /// 连接服务器超时时间
  final int connectTimeout;

  /// 发送超时时间
  final int sendTimeout;

  /// 两次数据流数据接收的最长间隔时间，注意不是请求的最长接收时间
  final int receiveTimeout;

  /// 拦截器
  final List<Interceptor>? interceptors;

  /// 使用默认的请求头content-type拦截器
  final bool useContentTypeInterceptor;

  /// 自动开启打印
  final bool useLog;

  /// 打印配置
  final PrettyDioLogger? logger;

  RepositoryConfig copyWith({
    String? baseUrl,
    int? connectTimeout,
    int? sendTimeout,
    int? receiveTimeout,
    List<Interceptor>? interceptors,
    bool? useContentTypeInterceptor,
    bool? useLog,
    PrettyDioLogger? logger,
  }) {
    return RepositoryConfig(
      baseUrl: baseUrl ?? this.baseUrl,
      connectTimeout: connectTimeout ?? this.connectTimeout,
      sendTimeout: sendTimeout ?? this.sendTimeout,
      receiveTimeout: receiveTimeout ?? this.receiveTimeout,
      interceptors: interceptors ?? this.interceptors,
      useContentTypeInterceptor: useContentTypeInterceptor ?? this.useContentTypeInterceptor,
      useLog: useLog ?? this.useLog,
      logger: logger ?? this.logger,
    );
  }
}
