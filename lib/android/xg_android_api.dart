import 'dart:async';

import 'package:flutter/services.dart';

import 'native_event_handler.dart';

class XgAndroidApi {
  final String flutterLog = "| XGPUSH | Flutter | ";
  static MethodChannel? _channel;
  NativeEventHandler? _eventHandler;

  XgAndroidApi(MethodChannel channel) {
    _channel = channel;
  }

  ///在调native函数前需要调用改函数
  void addNativeEventHandler(NativeEventHandler eventHandler) {
    this._eventHandler = eventHandler;
    _channel?.setMethodCallHandler(_handleMethod);
  }

  Future<Null> _handleMethod(MethodCall call) async {
    if (this._eventHandler == null) return;
    Map para = call.arguments;
    switch (call.method) {
      case "onRegisterPushSuccess":
        String token = para['pushToken'];
        this._eventHandler?.onRegisterPushSuccess(token);
        return;
      case "onRegisterPushFail":
        String message = para['message'];
        int code = para['resultCode'];
        this._eventHandler?.onRegisterPushFail(message, code);
        return;
      case "onUnregisterResult":
        String message = para['message'];
        int code = para['resultCode'];
        this._eventHandler?.onUnregisterResult(message, code);
        return;
      case "onTextMessage":
        String message = para['message'];
        String customContent = para['customMessage'];
        String title = para['title'];
        this._eventHandler?.onTextMessage(title, message, customContent);
        return;
      case "onSetTagResult":
        String message = para['message'];
        int code = para['resultCode'];
        this._eventHandler?.onSetTagResult(message, code);
        return;
      case "onDeleteTagResult":
        String message = para['message'];
        int code = para['resultCode'];
        this._eventHandler?.onDeleteTagResult(message, code);
        return;
      case "onNotifactionShowedResult":
        String message = para['message'];
        String customContent = para['customMessage'];
        String title = para['title'];
        int actionType = para['actionType'];
        this._eventHandler?.onNotifactionShowedResult(
            title, message, customContent, actionType);
        return;
      case "onNotifactionClickedResult":
        String message = para['message'];
        String customContent = para['customMessage'];
        String title = para['title'];
        int actionType = para['actionType'];
        this._eventHandler?.onNotifactionClickedResult(
            title, message, customContent, actionType);
        return;
      case "onBindAccountResult":
        String message = para['message'];
        String account = para['account'];
        int code = para['resultCode'];
        this._eventHandler?.onBindAccountResult(account, code, message);
        return;
      case "onAppendAccountResult":
        String message = para['message'];
        String account = para['account'];
        int code = para['resultCode'];
        this._eventHandler?.onAppendAccountResult(account, code, message);
        return;
      case "onDeleteAccountResult":
        String message = para['message'];
        String account = para['account'];
        int code = para['resultCode'];
        this._eventHandler?.onDeleteAccountResult(account, code, message);
        return;
    }
  }

  ///注册信鸽推送
  ///production
  ///debug 是否为debug模式  默认不是
  void regPush() {
    _channel?.invokeMethod('regPush');
  }

  ///开启debug模式
  ///debug 是否为debug模式 默认不是
  void setEnableDebug({bool? debug}) {
    _channel?.invokeMethod('setEnableDebug', {'enableDebug': debug});
  }

  /// 设置心跳时间间隔
  /// interval 心跳间隔
  void setHeartbeatIntervalMs({int? interval}) {
    _channel?.invokeMethod(
        'setHeartbeatIntervalMs', {'heartBeatIntervalMs': interval});
  }

  /// 配置是否关闭拉起其他 App
  /// enable 是否关闭 默认不是
  void enablePullUpOtherApp({bool? enable}) {
    _channel?.invokeMethod('enablePullUpOtherApp', {'enable': enable});
  }

  ///反注册信鸽推送
  /// 当用户已退出或 App 被关闭，不再需要接收推送时，可以取消注册 App，即反注册。
  ///（一旦设备反注册，直到这个设备重新注册成功期间内，下发的消息该设备都无法收到）
  void stopXg() {
    _channel?.invokeMethod('stopXg');
  }

  ///设置标签
  void setXgTag({String? tagName}) {
    _channel?.invokeMethod('setXgTag', {'tagName': tagName});
  }

  /// 设置多tag tagNames为List<String>tag的集合
  /// 一次设置多个标签，会覆盖这个设备之前设置的标签。
  void setXgTags({List? tagNames}) {
    _channel?.invokeMethod('setXgTags', {'tagNames': tagNames});
  }

  /// 添加多个标签 tagNames为List<String>tag的集合 每个 tag 不能超过40字节（超过会抛弃）不能包含空格（含有空格会删除空格)
  /// 最多设置1000个 tag，超过部分会抛弃
  /// 一次设置多个标签，会覆盖这个设备之前设置的标签。
  /// <p>
  /// 如果新增的标签的格式为 "test:2 level:2"，则会删除这个设备的全部历史标签，再新增 test:2 和 level。
  /// 如果新增的标签有部分不带:号，如 "test:2 level"，则会删除这个设备的全部历史标签，再新增 test:2 和 level 标签。
  /// <p>
  /// 新增的 tags 中，:号为后台关键字，请根据具体的业务场景使用。
  /// 此接口调用的时候需要间隔一段时间（建议大于5s），否则可能造成更新失败。
  void addXgTags({List? tagNames}) {
    _channel?.invokeMethod('addXgTags', {'tagNames': tagNames});
  }

  ///删除指定标签
  void deleteXgTag({String? tagName}) {
    _channel?.invokeMethod('deleteXgTag', {'tagName': tagName});
  }

  ///删除多个标签
  ///Set 标签名集合，每个标签是一个 String。限制：每个 tag 不能超过40字节（超过会抛弃），
  ///不能包含空格（含有空格会删除空格）。最多设置1000个tag，超过部分会抛弃。
  void deleteXgTags({List? tagNames}) {
    _channel?.invokeMethod('deleteXgTags', {'tagNames': tagNames});
  }

  ///清除所有标签
  void cleanXgTags() {
    _channel?.invokeMethod('cleanXgTags');
  }

  ///获取token
  /// 第一次注册会产生 Token，之后一直存在手机上，不管以后注销注册操作，该 Token 一直存在，
  /// 当 App 完全卸载重装了 Token 会发生变化。不同 App 之间的 Token 不一样。
  Future<String> getXgToken() async {
    final String token = await _channel?.invokeMethod('xgToken');
    return token;
  }

  ///绑定账号
  ///推荐有账号体系的App使用（此接口会覆盖设备之前绑定过的账号，仅当前注册的账号生效）
  void bindAccount({String? account}) {
    _channel?.invokeMethod('bindAccount', {'account': account});
  }

  void bindAccountWithType({String? account, String? accountType}) {
    _channel?.invokeMethod('bindAccount', {'account': account, 'accountType': accountType});
  }

  ///添加账号
  ///推荐有账号体系的App使用（此接口保留之前的账号，只做增加操作，
  ///一个token下最多只能有10个账号超过限制会自动顶掉之前绑定的账号，)
  void appendAccount({String? account}) {
    _channel?.invokeMethod('appendAccount', {'account': account});
  }

  void appendAccountWithType({String? account, String? accountType}) {
    _channel?.invokeMethod('appendAccount', {'account': account, 'accountType': accountType});
  }

  ///删除注册账号
  ///账号解绑只是解除 Token 与 App 账号的关联，若使用全量/标签/Token 推送仍然能收到通知/消息。
  void delAccount({String? account}) {
    _channel?.invokeMethod('delAccount', {'account': account});
  }
  
  void delAccountWithType({String? account, String? accountType}) {
    _channel?.invokeMethod('delAccount', {'account': account, 'accountType': accountType});
  }

  ///清除全部账号
  void delAllAccount() {
    _channel?.invokeMethod('delAllAccount');
  }

  ///新增用户属性
  void upsertAttributes({Map<String, String>? attributes}) {
    _channel?.invokeMethod('upsertAttributes', {'attributes': attributes});
  }

  ///删除用户属性
  void delAttributes({List<String>? attributes}) {
    _channel?.invokeMethod('delAttributes', {'attributes': attributes});
  }

  ///更新用户属性
  void clearAndAppendAttributes({Map<String, String>? attributes}) {
    _channel?.invokeMethod('clearAndAppendAttributes', {'attributes': attributes});
  }

  ///清除全部用户属性
  void clearAttributes() {
    _channel?.invokeMethod('clearAttributes');
  }

/*-------------第三方厂商通道集成-------------*/

  /// 开启其他推送
  void enableOtherPush() {
    _channel?.invokeMethod('enableOtherPush');
  }

  /// 开启其他推送
  void enableOtherPush2({bool? enable}) {
    _channel?.invokeMethod('enableOtherPush2', {'enable': enable});
  }

  /// 获取厂商推送 token
  Future<String> getOtherPushToken() async {
    final String otherPushToken = await _channel?.invokeMethod('getOtherPushToken');
    return otherPushToken;
  }

  /// 获取厂商推送品牌
  Future<String> getOtherPushType() async {
    final String otherPushType = await _channel?.invokeMethod('getOtherPushType');
    return otherPushType;
  }

  /*-------------------角标控制---------------*/

  /// 接设置应用角标，
  /// 当前支持华为、OPPO、vivo，其中 OPPO 需另外向厂商申请角标展示权限
  void setBadgeNum({int? badgeNum}) {
    _channel?.invokeMethod('setBadgeNum', {'badgeNum': badgeNum});
  }

  /// 设置手机应用角标归0，建议在应用打开时将角标清0，
  /// 当前支持华为、OPPO、vivo，其中 OPPO 需另外向厂商申请角标展示权限
  void resetBadgeNum() {
    _channel?.invokeMethod('resetBadgeNum');
  }


  /// 清空当前应用在通知栏的通知
  void cancelAllNotification() {
    _channel?.invokeMethod('cancelAllNotification');
  }

  /// 创建通知渠道
  void createNotificationChannel({String? channelId, String? channelName}) {
    _channel?.invokeMethod('createNotificationChannel', {'channelId': channelId, 'channelName': channelName});
  }

  /*----------------小米厂商通道集成-----------*/

  /// 设置小米推送的APP_ID
  /// aappId为在小米平台注册所得Id
  void setMiPushAppId({String? appId}) {
    _channel?.invokeMethod('setMiPushAppId', {'appId': appId});
  }

  /// 设置小米推送的APP_KEY
  ///appKey 为在小米平台注册所得key
  void setMiPushAppKey({String? appKey}) {
    _channel?.invokeMethod('setMiPushAppKey', {'appKey': appKey});
  }

  ///判断是否为小米手机
  Future<bool> isMiuiRom() async {
    final bool isMIUI = await _channel?.invokeMethod('isMiuiRom');
    return isMIUI;
  }

  ///开启小米厂商通道
  ///appId  为在小米平台注册所得Id
  ///appKey 为在小米平台注册所得key
  @Deprecated(
      'Please call the following apis instead:'
        'XgFlutterPlugin.xgApi.setMiPushAppId(appId:"APP_ID");'
        'XgFlutterPlugin.xgApi.setMiPushAppKey(appKey: "APPKEY");'
        'XgFlutterPlugin.xgApi.enableOtherPush();'
        'XgFlutterPlugin.xgApi.regPush();'
  )
  void startMiPush({String? appId, String? appKey}) async {
    final bool isMIUI = await _channel?.invokeMethod('isMiuiRom');
    if (isMIUI) {
      _channel?.invokeMethod('setMiPushAppId', {'appId': appId});
      _channel?.invokeMethod('setMiPushAppKey', {'appKey': appKey});
      _channel?.invokeMethod('enableOtherPush');
      _channel?.invokeMethod('regPush');
    }
  }

  /*---------------------华为厂商通道集成----------------------*/

  ///判断是否为华为手机
  Future<bool> isEmuiRom() async {
    final bool isHUAWEI = await _channel?.invokeMethod('isEmuiRom');
    return isHUAWEI;
  }

  ///开启华为厂商通道
  @Deprecated(
      'Please call the following apis instead:'
          'XgFlutterPlugin.xgApi.enableOtherPush();'
          'XgFlutterPlugin.xgApi.regPush();'
  )
  void startHuaWeiPush() async {
    final bool isHUAWEI = await _channel?.invokeMethod('isEmuiRom');
    if (isHUAWEI) {
      _channel?.invokeMethod('enableOtherPush');
      _channel?.invokeMethod('regPush');
    }
  }

  /*---------------------oppo厂商通道集成------------------*/

  ///开启Oppo通知
  ///isNotification 是否开启OPPO通知
  void enableOppoNotification({bool? isNotification}) {
    _channel?.invokeMethod(
        'enableOppoNotification', {'isNotification': isNotification});
  }

  ///设置Oppo推送ID
  ///appId为在Oppo平台注册所得Id
  void setOppoPushAppId({String? appId}) {
    _channel?.invokeMethod('setOppoPushAppId', {'appId': appId});
  }

  ///设置Oppo推送Key
  ///appKey为在Oppo平台注册所得Key
  void setOppoPushAppKey({String? appKey}) {
    _channel?.invokeMethod('setOppoPushAppKey', {'appKey': appKey});
  }

  ///判断是否为OPPO手机
  Future<bool> isOppoRom() async {
    final bool isOppo = await _channel?.invokeMethod('isOppoRom');
    return isOppo;
  }

  ///开启oppo厂商通道
  ///isNotification 是否开启OPPO通知
  /// appId为在Oppo平台注册所得Id
  /// appKey为在Oppo平台注册所得Key
  @Deprecated(
      'Please call the following apis instead:'
          'XgFlutterPlugin.xgApi.setOppoPushAppId(appId:"APP_ID");'
          'XgFlutterPlugin.xgApi.setOppoPushAppKey(appKey: "APPKEY");'
          'XgFlutterPlugin.xgApi.enableOtherPush();'
          'XgFlutterPlugin.xgApi.regPush();'
  )
  void startOPPOPush({String? appId, String? appKey, bool? isNotification}) async {
    final bool isOppo = await _channel?.invokeMethod('isOppoRom');
    if (isOppo) {
      _channel?.invokeMethod(
          'enableOppoNotification', {'isNotification': isNotification});
      _channel?.invokeMethod('setOppoPushAppId', {'appId': appId});
      _channel?.invokeMethod('setOppoPushAppKey', {'appKey': appKey});
      _channel?.invokeMethod('enableOtherPush');
      _channel?.invokeMethod('regPush');
    }
  }

/*--------------------vivo厂商通道集成---------------*/

  ///判断是否为Vico手机
  Future<bool> isVivoRom() async {
    final bool isVivo = await _channel?.invokeMethod('isVivoRom');
    return isVivo;
  }

  ///开启ViVO厂商通道
  @Deprecated(
      'Please call the following apis instead:'
          'XgFlutterPlugin.xgApi.enableOtherPush();'
          'XgFlutterPlugin.xgApi.regPush();'
  )
  void startViVOPush() async {
    final bool isVivo = await _channel?.invokeMethod('isVivoRom');
    if (isVivo) {
      _channel?.invokeMethod('enableOtherPush');
      _channel?.invokeMethod('regPush');
    }
  }

  /*-------------------魅族厂商通道集成--------------*/

  ///设置魅族推送所需appID
  ///appId为在魅族平台注册所得Id
  void setMzPushAppId({String? appId}) {
    _channel?.invokeMethod('setMzPushAppId', {'appId': appId});
  }

  ///设置魅族推送所需appKey
  ///appKey为在魅族平台注册所得key
  void setMzPushAppKey({String? appKey}) {
    _channel?.invokeMethod('setMzPushAppKey', {'appKey': appKey});
  }

  ///判断是否为魅族手机
  Future<bool> isMeizuRom() async {
    final bool isMeiZu = await _channel?.invokeMethod('isMeizuRom');
    return isMeiZu;
  }

  ///开启魅族手机厂商通道
  ///appId为在魅族平台注册所得Id
  ///appKey为在魅族平台注册所得key
  @Deprecated(
      'Please call the following apis instead:'
          'XgFlutterPlugin.xgApi.setMzPushAppId(appId:"APP_ID");'
          'XgFlutterPlugin.xgApi.setMzPushAppKey(appKey: "APPKEY");'
          'XgFlutterPlugin.xgApi.enableOtherPush();'
          'XgFlutterPlugin.xgApi.regPush();'
  )
  void startMeizuPush({String? appId, String? appKey}) async {
    final bool isMeiZu = await _channel?.invokeMethod('isMeizuRom');
    if (isMeiZu) {
      _channel?.invokeMethod('setMzPushAppId', {'appId': appId});
      _channel?.invokeMethod('setMzPushAppKey', {'appKey': appKey});
      _channel?.invokeMethod('enableOtherPush');
      _channel?.invokeMethod('regPush');
    }
  }

  /*------------------谷歌厂商通道集成---------------*/

  ///判断是否为支持FCM手机
  @Deprecated(
      'TPNS SDK would auto-check if the device supports Firebase-messaging.'
  )
  Future<bool> isFcmRom() async {
    final bool isFcm = await _channel?.invokeMethod('isFcmRom');
    return isFcm;
  }

  ///判断是否为谷歌手机
  Future<bool> isGoogleRom() async {
    final bool isGoogle = await _channel?.invokeMethod('isGoogleRom');
    return isGoogle;
  }

  ///开启谷歌手机厂商通道
  @Deprecated(
      'Please call the following apis instead:'
          'XgFlutterPlugin.xgApi.enableOtherPush();'
          'XgFlutterPlugin.xgApi.regPush();'
  )
  void startFcmPush() async {
    final bool isGoogle = await _channel?.invokeMethod('isGoogleRom');
    if (isGoogle) {
      _channel?.invokeMethod('enableOtherPush');
      _channel?.invokeMethod('regPush');
    }
  }

  ///判断是否为360手机
  Future<bool> is360Rom() async {
    final bool is360 = await _channel?.invokeMethod('is360Rom');
    return is360;
  }
}
