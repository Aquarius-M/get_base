import 'package:dio/dio.dart';

import '../api_response.dart';
import 'http_transformer.dart';

/// @author: zx
/// @description: 返回体解析
/// 接口返回类型
///   {
///     "code": 1,
///     "data": {},
///     "msg": "success"
/// }
class DefaultHttpTransformer extends HttpTransformer {
  @override
  ApiResponse parse(Response response) {
    //成功返回码为1
    if (response.data is Map) {
      if (response.data['code'] == 1) {
        return ApiResponse.success(response.data['data'], msg: response.data['msg']);
      } else {
        //处理接口自定义的异常
        return ApiResponse.failure(errorCode: response.data['code'], errorMsg: response.data['msg']);
      }
    } else {
      return ApiResponse.failure(errorCode: -1, errorMsg: "异常");
    }
  }

  /// 单例对象
  static final DefaultHttpTransformer _instance = DefaultHttpTransformer._internal();

  /// 内部构造方法，可避免外部暴露构造函数，进行实例化
  DefaultHttpTransformer._internal();

  /// 工厂构造方法，这里使用命名构造函数方式进行声明
  factory DefaultHttpTransformer.getInstance() => _instance;
}