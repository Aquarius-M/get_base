import 'package:get_base/get_base.dart';

/// 请求头类型拦截器
/// version: 1.0
class ContentTypeInterceptor extends Interceptor {

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // 因dio5.0版本中，请求的content-type默认不带值，所以需要指定
    if (options.contentType == null) {
      final dynamic data = options.data;
      final String? contentType;
      if (data is FormData) {
        contentType = "multipart/form-data";
      } else if (data is Map) {
        // contentType = Headers.formUrlEncodedContentType;
        contentType = Headers.jsonContentType;
      } else if (data is String) {
        contentType = Headers.jsonContentType;
      } else if (data != null) {
        contentType = Headers.textPlainContentType;
      } else {
        contentType = null;
      }
      options.contentType = contentType;
    }
    handler.next(options);
  }
}