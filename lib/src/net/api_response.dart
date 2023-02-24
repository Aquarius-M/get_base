import 'network_exception.dart';

/// @description: 默认请求返回体封装
/// version: 1.0
class ApiResponse {
  late bool ok;
  dynamic data;
  // 此字段用于接口访问成功时返回msg信息
  String? msg;

  ///当 [statusCode] != 200 && [code] != 1，全部封装成异常返回
  NetworkException? error;

  ApiResponse.success(this.data, {this.msg}) {
    ok = true;
  }

  ///自定义异常返回
  ApiResponse.failure({String? errorMsg, int? errorCode}) {
    ok = false;
    error = NetworkException(errorCode, errorMsg);
  }

  ///通过异常创建返回
  ApiResponse.failureFromError(this.error) {
    ok = false;
  }

  @override
  String toString() {
    return "ok: $ok, "
        "data: $data, "
        "msg: $msg, "
        "error: ${error.toString()}";
  }
}