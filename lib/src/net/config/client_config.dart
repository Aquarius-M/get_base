import 'package:get_base/src/net/function/custom_function.dart';
import 'package:get_base/src/net/network_exception.dart';

/// 网络请求全局配置项
class ClientConfig {

  /// 请求开始前检查回调
  /// 返回值 为空 时继续执行
  /// 返回值 不为空 时，会把返回的 异常 通过 onError 返回
  static BeforeRequestCheck beforeRequest = _check;

  /// 对外暴露 toast 回调事件
  static ToastCall? toastCall;
}

/// 默认请求前检查方法
Future<NetworkException?> _check()async {
  return null;
}
