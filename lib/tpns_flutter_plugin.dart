import 'dart:async';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:tpns_flutter_plugin/android/xg_android_api.dart';

/// 设备token绑定的类型，绑定指定类型之后，就可以在信鸽前端按照指定的类型进行指定范围的推送
/// none:当前设备token不绑定任何类型，可以使用token单推，或者是全量推送（3.2.0+ 不推荐使用 ）
/// account:当前设备token与账号绑定之后，可以使用账号推送
/// tag:当前设备token与指定标签绑定之后，可以使用标签推送
enum XGBindType { none, account, tag }

/// UNKNOWN 未知类型，单账号绑定默认使用
/// CUSTOM 自定义
/// IDFA 广告唯一标识，iOS 专用，安卓侧默认为UNKNOWN类型
/// PHONE_NUMBER 手机号码
/// WX_OPEN_ID 微信 OPENID
/// QQ_OPEN_ID QQ OPENID
/// EMAIL 邮箱
/// SINA_WEIBO 新浪微博
/// ALIPAY 支付宝
/// TAOBAO 淘宝
/// DOUBAN 豆瓣
/// BAIDU 百度
/// JINGDONG 京东
/// IMEI 安卓手机标识，安卓专用，iOS默认为UNKNOWN类型
enum AccountType {
  UNKNOWN,
  CUSTOM,
  IDFA,
  PHONE_NUMBER,
  WX_OPEN_ID,
  QQ_OPEN_ID,
  EMAIL,
  SINA_WEIBO,
  ALIPAY,
  TAOBAO,
  DOUBAN,
  FACEBOOK,
  TWITTER,
  GOOGLE,
  BAIDU,
  JINGDONG,
  LINKEDIN,
  IMEI
}

typedef Future<dynamic> EventHandler(String res);
typedef Future<dynamic> EventHandlerMap(Map<String, dynamic> event);

/* ======TPNS推送接口类====== */

class XgFlutterPlugin {
  static const MethodChannel _channel =
      const MethodChannel('tpns_flutter_plugin');
  static XgAndroidApi xgApi = new XgAndroidApi(_channel);

  /// 注册推送服务失败回调
  EventHandler? _onRegisteredDeviceToken;

  /// 注册推送服务成功回调
  EventHandler? _onRegisteredDone;

  /// 注销推送服务回调
  EventHandler? _unRegistered;

  /// 前台收到通知消息回调
  EventHandlerMap? _onReceiveNotificationResponse;

  /// 收到透传、静默消息回调
  EventHandlerMap? _onReceiveMessage;

  /// 通知点击回调
  EventHandlerMap? _xgPushClickAction;

  /// 设置角标回调仅iOS
  EventHandler? _xgPushDidSetBadge;

  /// 绑定账号和标签回调
  EventHandler? _xgPushDidBindWithIdentifier;

  /// 解绑账号和标签回调
  EventHandler? _xgPushDidUnbindWithIdentifier;

  /// 更新账号和标签回调
  EventHandler _xgPushDidUpdatedBindedIdentifier;

  /// 清除所有账号和标签回调
  EventHandler? _xgPushDidClearAllIdentifiers;

  /// 获取sdk版本号
  static Future<String> get xgSdkVersion async {
    final String version = await _channel.invokeMethod('xgSdkVersion');
    return version;
  }

  /// 获取信鸽token
  static Future<String> get xgToken async {
    final String xgToken = await _channel.invokeMethod('xgToken');
    return xgToken;
  }

  /// 获取安卓厂商 token，当前仅对安卓有效
  static Future<String?> get otherPushToken async {
    if (Platform.isIOS) {

    } else {
      final String otherPushToken = await _channel.invokeMethod(
          'getOtherPushToken');
      return otherPushToken;
    }
  }

  /// 获取安卓厂商品牌，当前仅对安卓有效
  static Future<String?> get otherPushType async {
    if (Platform.isIOS) {

    } else {
      final String otherPushType = await _channel.invokeMethod(
          'getOtherPushType');
      return otherPushType;
    }
  }

  /// 集群域名配置（非广州集群需要在startXg之前调用此函数）
  void configureClusterDomainName(String domainStr) {
    if (Platform.isIOS) {
      _channel.invokeMethod('configureClusterDomainName',
          <String, dynamic>{'domainStr': domainStr});
    }
  }

/* ======信鸽注册反注册和debug接口====== */

  /// 注册推送服务
  /// iOS需传accessId和accessKey
  /// android不需要传参数
  void startXg(String accessId, String accessKey) {
    if (Platform.isIOS) {
      _channel.invokeMethod('startXg',
          <String, dynamic>{'accessId': accessId, 'accessKey': accessKey});
    } else {
      xgApi.regPush();
    }
  }

  /// 注销推送服务（注销后无法再收到任何推送）
  void stopXg() {
    _channel.invokeMethod('stopXg');
  }

  /// debug模式
  void setEnableDebug(bool enableDebug) {
    _channel.invokeMethod(
        'setEnableDebug', <String, dynamic>{'enableDebug': enableDebug});
  }

/* ============账号接口V1.0.4新增============ */

  /// 设置账号
  /// account 账号标识
  /// accountType 账号类型枚举
  void setAccount(String account, AccountType accountType) {
    String _accountType = accountType.toString().split('.').last;
    if (Platform.isIOS) {
      _channel.invokeMethod('setAccount',
          <String, dynamic>{'account': account, 'accountType': _accountType});
    } else {
      xgApi.bindAccountWithType(account: account, accountType: _accountType);
    }
  }

  /// 删除指定账号
  /// account 账号标识
  /// accountType 账号类型枚举
  void deleteAccount(String account, AccountType accountType) {
    String _accountType = accountType.toString().split('.').last;
    if (Platform.isIOS) {
      _channel.invokeMethod('deleteAccount',
          <String, dynamic>{'account': account, 'accountType': _accountType});
    } else {
      xgApi.delAccountWithType(account: account, accountType: _accountType);
    }
  }

  /// 删除所有账号
  void cleanAccounts() {
    if (Platform.isIOS) {
      _channel.invokeMethod('cleanAccounts');
    } else {
      xgApi.delAllAccount();
    }
  }

/* ============标签接口V1.0.4新增============ */

  /// 追加标签
  /// tags类型为字符串数组(标签字符串不允许有空格或者是tab字符) [tagStr]
  void addTags(List<String> tags) {
    if (Platform.isIOS) {
      _channel.invokeMethod('addTags', tags);
    } else {
      xgApi.addXgTags(tagNames: tags);
    }
  }

  /// 覆盖标签(清除所有标签再追加)
  /// tags类型为字符串数组(标签字符串不允许有空格或者是tab字符) [tagStr]
  void setTags(List<String> tags) {
    if (Platform.isIOS) {
      _channel.invokeMethod('setTags', tags);
    } else {
      xgApi.setXgTags(tagNames: tags);
    }
  }

  /// 删除指定标签
  /// tags类型为字符串数组(标签字符串不允许有空格或者是tab字符) [tagStr]
  void deleteTags(List<String> tags) {
    if (Platform.isIOS) {
      _channel.invokeMethod('deleteTags', tags);
    } else {
      xgApi.deleteXgTags(tagNames: tags);
    }
  }

  /// 清除所有标签
  void cleanTags() {
    if (Platform.isIOS) {
      _channel.invokeMethod('cleanTags');
    } else {
      xgApi.cleanXgTags();
    }
  }

/* ======角标====== */

  /// 同步角标值到TPNS服务器
  void setBadge(int badgeSum) {
    if (Platform.isIOS) {
      _channel
          .invokeMethod('setBadge', <String, dynamic>{'badgeSum': badgeSum});
    }
  }

  /// 设置应用角标(当同步角标值到TPNS成功后，用户设置应用角标为对应的值)
  void setAppBadge(int badgeSum) {
    if (Platform.isIOS) {
      _channel
          .invokeMethod('setAppBadge', <String, dynamic>{'badgeSum': badgeSum});
    }
  }

/* ======获取信鸽AndroidApi====== */

  /// 获取XgAndroidApi
  XgAndroidApi getXgAndroidApi() {
    return xgApi;
  }

/*****************************************账号和标签废弃接口,V1.0.4废弃请使用新接口*********************************/

  /* ======单个操作账号和标签====== */

  /// 绑定账号或标签
  void bindWithIdentifier({
    required String identify,
    required XGBindType bindType,
  }) {
    if (Platform.isIOS) {
      _channel.invokeMethod('bindWithIdentifier',
          {'identify': identify, 'bindType': bindType.index});
    } else {
      if (bindType.index == XGBindType.tag.index) {
        xgApi.addXgTags(tagNames: [identify]);
      } else if (bindType.index == XGBindType.account.index) {
        xgApi.appendAccount(account: identify);
      }
    }
  }

  /// 更新账号或标签
  void updateBindIdentifier({
    required String identify,
    required XGBindType bindType,
  }) {
    if (Platform.isIOS) {
      _channel.invokeMethod('updateBindIdentifier',
          {'identify': identify, 'bindType': bindType.index});
    } else {
      if (bindType.index == XGBindType.tag.index) {
        xgApi.setXgTag(tagName: identify);
      } else if (bindType.index == XGBindType.account.index) {
        xgApi.bindAccount(account: identify);
      }
    }
  }

  /// 解绑账号或标签
  void unbindWithIdentifier({
    required String identify,
    required XGBindType bindType,
  }) {
    if (Platform.isIOS) {
      _channel.invokeMethod('unbindWithIdentifier',
          {'identify': identify, 'bindType': bindType.index});
    } else {
      if (bindType.index == XGBindType.tag.index) {
        xgApi.deleteXgTag(tagName: identify);
      } else if (bindType.index == XGBindType.account.index) {
        xgApi.delAccount(account: identify);
      }
    }
  }

  /// 批量绑定账号或标签
  /// ios 对于账号操作. List类型为dic数组[{'account':identifyStr, 'accountType':0}]
  /// ios 对于标签操作，List类型为字符串数组(标签字符串不允许有空格或者是tab字符) [identifyStr]
  /// android List类型为字符串数组(标签字符串不允许有空格或者是tab字符) [identifyStr]
  void bindWithIdentifiers({
    required List identifys,
    required XGBindType bindType,
  }) {
    if (Platform.isIOS) {
      _channel.invokeMethod('bindWithIdentifiers',
          {'identifys': identifys, 'bindType': bindType.index});
    } else {
      if (bindType.index == XGBindType.tag.index) {
        xgApi.addXgTags(tagNames: identifys);
      }
    }
  }

  /// 批量更新账号或标签
  /// ios 对于账号操作. List类型为dic数组[{'account':identifyStr, 'accountType':0}]
  /// ios 对于标签操作，List类型为字符串数组(标签字符串不允许有空格或者是tab字符) [identifyStr]
  /// android List类型为字符串数组(标签字符串不允许有空格或者是tab字符) [identifyStr]
  void updateBindIdentifiers({
    required List identifys,
    required XGBindType bindType,
  }) {
    if (Platform.isIOS) {
      _channel.invokeMethod('updateBindIdentifiers',
          {'identifys': identifys, 'bindType': bindType.index});
    } else {
      if (bindType.index == XGBindType.tag.index) {
        xgApi.setXgTags(tagNames: identifys);
      }
    }
  }

  /// 批量解绑账号或标签
  /// ios 对于账号操作. List类型为dic数组[{'account':identifyStr, 'accountType':0}]
  /// ios 对于标签操作，List类型为字符串数组(标签字符串不允许有空格或者是tab字符) [identifyStr]
  /// android List类型为字符串数组(标签字符串不允许有空格或者是tab字符) [identifyStr]
  void unbindWithIdentifiers({
    required List identifys,
    required XGBindType bindType,
  }) {
    if (Platform.isIOS) {
      _channel.invokeMethod('unbindWithIdentifiers',
          {'identifys': identifys, 'bindType': bindType.index});
    } else {
      if (bindType.index == XGBindType.tag.index) {
        xgApi.deleteXgTags(tagNames: identifys);
      }
    }
  }

  /// 清除全部账号或标签
  void clearAllIdentifier(XGBindType bindType) {
    if (Platform.isIOS) {
      _channel.invokeMethod(
          'clearAllIdentifier', <String, dynamic>{'bindType': bindType.index});
    } else {
      if (bindType.index == XGBindType.tag.index) {
        xgApi.cleanXgTags();
      } else if (bindType.index == XGBindType.account.index) {
        xgApi.delAllAccount();
      }
    }
  }

/*******************************************请不要再使用以上账号和标签接口****************************************************/

/* ======信鸽callback====== */

  void addEventHandler({
    EventHandler? onRegisteredDeviceToken,
    EventHandler? onRegisteredDone,
    EventHandler? unRegistered,
    EventHandlerMap? onReceiveNotificationResponse,
    EventHandlerMap? onReceiveMessage,
    EventHandler? xgPushDidSetBadge,
    EventHandler? xgPushDidBindWithIdentifier,
    EventHandler? xgPushDidUnbindWithIdentifier,
    EventHandler? xgPushDidUpdatedBindedIdentifier,
    EventHandler? xgPushDidClearAllIdentifiers,
    EventHandlerMap? xgPushClickAction,
  }) {
    _onRegisteredDeviceToken = onRegisteredDeviceToken;
    _onRegisteredDone = onRegisteredDone;
    _unRegistered = unRegistered;
    _onReceiveNotificationResponse = onReceiveNotificationResponse;
    _onReceiveMessage = onReceiveMessage;
    _xgPushDidSetBadge = xgPushDidSetBadge;
    _xgPushDidBindWithIdentifier = xgPushDidBindWithIdentifier;
    _xgPushDidUnbindWithIdentifier = xgPushDidUnbindWithIdentifier;
    _xgPushDidUpdatedBindedIdentifier = xgPushDidUpdatedBindedIdentifier;
    _xgPushDidClearAllIdentifiers = xgPushDidClearAllIdentifiers;
    _xgPushClickAction = xgPushClickAction;
    _channel.setMethodCallHandler(_handleMethod);
  }

  Future<dynamic> _handleMethod(MethodCall call) async {
    switch (call.method) {
      case "onRegisteredDeviceToken":
        return _onRegisteredDeviceToken!(call.arguments);
      case "onRegisteredDone":
        return _onRegisteredDone!(call.arguments);
      case "unRegistered":
        return _unRegistered!(call.arguments);
      case "onReceiveNotificationResponse":
        return _onReceiveNotificationResponse!(
            call.arguments.cast<String, dynamic>());
      case "onReceiveMessage":
        return _onReceiveMessage!(call.arguments.cast<String, dynamic>());
      case "xgPushDidSetBadge":
        return _xgPushDidSetBadge!(call.arguments);
      case "xgPushDidBindWithIdentifier":
        return _xgPushDidBindWithIdentifier!(call.arguments);
      case "xgPushDidUnbindWithIdentifier":
        return _xgPushDidUnbindWithIdentifier!(call.arguments);
      case "xgPushDidUpdatedBindedIdentifier":
        return _xgPushDidUpdatedBindedIdentifier!(call.arguments);
      case "xgPushDidClearAllIdentifiers":
        return _xgPushDidClearAllIdentifiers!(call.arguments);
      case "xgPushClickAction":
        return _xgPushClickAction!(call.arguments.cast<String, dynamic>());
      default:
        throw new UnsupportedError("Unrecongnized Event");
    }
  }
}
