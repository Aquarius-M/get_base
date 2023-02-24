import 'package:flutter/material.dart';

import '../network_exception.dart';

/// 请求开始前检查回调方法，返回异常
typedef BeforeRequestCheck = Future<NetworkException?> Function();

/// 请求成功回调方法
typedef Success<T> = Function(T data);

/// 请求失败回调方法
typedef Fail = Function(int code, String msg);

/// 字符串回调函数
typedef MessageBack = Function(String msg);

/// toast回调方法
typedef ToastCall = Function(String msg);

/// loading回调方法
typedef LoadingCall = Function(VoidCallback cancel,);