import 'package:dio/dio.dart';

import '../api_response.dart';

/// @description: Response 解析，解析不同返回格式
/// version: 1.0
abstract class HttpTransformer {
  ApiResponse parse(Response response);
}