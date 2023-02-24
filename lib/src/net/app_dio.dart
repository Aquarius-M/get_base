import 'package:dio/dio.dart';
import 'package:get_base/src/net/config/repository_config.dart';
import 'package:get_base/src/net/interceptors/content_type_interceptors.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

/// dio配置
/// version: 1.0
class AppDio with DioMixin implements Dio {
  AppDio({
    required RepositoryConfig config,
  }) {
    BaseOptions options = BaseOptions(
      baseUrl: config.baseUrl,
      connectTimeout: Duration(milliseconds: config.connectTimeout),
      sendTimeout: Duration(milliseconds: config.sendTimeout),
      receiveTimeout: Duration(milliseconds: config.receiveTimeout),
      validateStatus: (status) {
        /// 不使用http状态码判断状态，使用AdapterInterceptor来处理（适用于标准REST风格）
        return true;
      },
    );
    this.options = options;
    if (config.interceptors?.isNotEmpty ?? false) {
      interceptors.addAll(config.interceptors!);
    }
    // 添加ContentType设置拦截
    if (config.useContentTypeInterceptor) {
      interceptors.add(ContentTypeInterceptor());
    }
    // 是否开启内置打印
    if (config.useLog) {
      interceptors.add(config.logger ?? PrettyDioLogger(requestHeader: true,));
    }
    httpClientAdapter = HttpClientAdapter();
  }
}
