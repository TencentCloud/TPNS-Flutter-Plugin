abstract class NativeEventHandler {
  ///推送注册成功时候的回调
  ///token 信鸽推送的token

  void onRegisterPushSuccess(String token);

  ///注册失败
  ///message 失败消息
  ///code错误码
  void onRegisterPushFail(String message, int code);

  ///反注册结果
  ///message 消息
  ///code 结果码
  void onUnregisterResult(String message, int code) {}

  ///收到透传消息
  ///title 标题
  ///message 文本
  ///customContent消息自定义 key-value
  void onTextMessage(String title, String message, String customContent) {}

  ///设置tag
  ///message 消息
  ///code 错误码
  void onSetTagResult(String message, int code) {}

  ///删除tag
  ///message 消息
  ///code 错误码
  void onDeleteTagResult(String message, int code) {}

  ///通知栏展示
  ///title 标题
  ///message 文本
  ///customContent消息自定义 key-value
  ///type类型
  void onNotifactionShowedResult(
      String title, String message, String customContent, int type) {}

  ///通知栏点击
  ///title 标题
  ///message 文本
  ///customContent消息自定义 key-value
  ///type类型
  void onNotifactionClickedResult(
      String title, String message, String customContent, int type) {}

  /// 绑定账号注册
  /// account 账号
  /// code 错误码
  /// message
  void onBindAccountResult(String account, int code, String message) {}

  /// 添加注册账号
  /// account 账号
  /// code 错误码
  /// message
  void onAppendAccountResult(String account, int code, String message) {}

  /// 删除绑定账号
  /// account 账号
  /// code 错误码
  /// message
  void onDeleteAccountResult(String account, int code, String message) {}
}
