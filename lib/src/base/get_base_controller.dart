import 'package:get/get.dart';

/// 普通基类
/// version: 1.0
class GetBaseController extends GetxController with StateMixin{

  /// 页面是否销毁
  bool _isDispose = false;

  /// 更新状态为 成功
  changeSuccess() {
    change(null, status: RxStatus.success());
    update();
  }

  /// 更新状态为 加载中
  changeLoading() {
    change(null, status: RxStatus.loading());
    update();
  }

  /// 更新状态为 空数据
  changeEmpty() {
    change(null, status: RxStatus.empty());
    update();
  }

  /// 更新状态为 错误状态
  changeError(String msg) {
    change(null, status: RxStatus.error(msg));
    update();
  }

  @override
  update([List<Object>? ids, bool condition = true]) {
    // 仅当页面未销毁时更新
    if (!_isDispose) {
      super.update(ids, condition);
    }
  }

  @override
  void dispose() {
    _isDispose = true;
    super.dispose();
  }
}