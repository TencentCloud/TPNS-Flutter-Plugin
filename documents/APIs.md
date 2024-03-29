## 通用 API 接口说明

#### 1. 注册推送服务
      /// iOS前台收到通知不希望展示时可将withInAppAlert参数置为false
      /// android接入厂商通道时，请先参考 [厂商通道接入说明](vendor.md) 配置各厂商通道参数信息后，再调用此注册方法。
```dart
      void startXg(String accessId, String accessKey, {bool withInAppAlert = true});
```

#### 2. 注销推送服务
```dart
      void stopXg();
```

#### 3. 设置debug模式
```dart
      void setEnableDebug(bool enableDebug);
```

#### 4. 账号类型枚举
      /// UNKNOWN 默认类型，当前只支持此类型的推送
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
```dart
      enum AccountType { UNKNOWN, CUSTOM, IDFA, PHONE_NUMBER, WX_OPEN_ID, QQ_OPEN_ID, EMAIL, SINA_WEIBO, ALIPAY, TAOBAO, DOUBAN, FACEBOOK, TWITTER, GOOGLE, BAIDU, JINGDONG, LINKEDIN, IMEI }
```

#### 5. 设置账号
      /// account 账号标识
      /// accountType 账号类型枚举
      /// note 同一账号类型对应一个唯一账号，覆盖操作，多账号体系请使用不同账号类型
```dart
      void setAccount(String account, AccountType accountType);
```

#### 6. 删除指定账号
      /// account 账号标识
      /// accountType 账号类型枚举
```dart
      void deleteAccount(String account, AccountType accountType);
```

#### 7. 删除所有账号
```dart
      void cleanAccounts();
```

####  8. 追加标签
      /// tags 标签字符串数组(标签字符串不允许有空格或者是tab字符)
```dart
      void addTags(List<String> tags);
```

#### 9. 覆盖标签(清除所有标签再追加)
      /// tags 标签字符串数组(标签字符串不允许有空格或者是tab字符)
```dart
      void setTags(List<String> tags);
```

#### 10. 删除指定标签
      /// tags 标签字符串数组(标签字符串不允许有空格或者是tab字符)
```dart
      void deleteTags(List<String> tags);
```

#### 11. 清除所有标签
```dart
      void cleanTags();
```

#### 12. 同步角标（同步角标值到TPNS，仅iOS）
      /// badgeSum 角标值
```dart
      void setBadge(int badgeSum);
```

#### 13. 设置应用角标（同步到TPNS成功后用于设置应用角标数，仅iOS）
      /// badgeSum 角标值
```dart
      void setAppBadge(int badgeSum);
```

#### 14. 获取 XgAndroidApi
    /// 获取 XgAndroidApi 调用Android里的api接口
```dart
    XgAndroidApi getXgAndroidApi();
```

#### 15. 新增用户属性
    /// attributes 类型为 Map 字典(k, v字符串不允许有空格或者是tab字符)
```dart
  void upsertAttributes(Map<String, String> attributes);
```

#### 16. 删除用户属性
    /// attributes 类型为要删除属性 key 的字符串数组(字符串不允许有空格或者是tab字符)
```dart
  void delAttributes(List<String> attributes);
```

#### 17. 更新用户属性
    /// attributes 类型为 Map 字典(k, v字符串不允许有空格或者是tab字符)
```dart
  void clearAndAppendAttributes(Map<String, String> attributes);
```

#### 18. 清除全部用户属性
```dart
  void clearAttributes();
```


##  回调接口说明

#### 1 静默消息(iOS)/透传消息(Android)回调
```dart
    _onReceiveMessage 数据类型 Map<String, Object> para: iOS/Android返回不同的消息体，以双端返回kv为准
```

#### 2 收到通知消息回调
```dart
    _onReceiveNotificationResponse    数据类型 Map<String, Object> para: iOS/Android返回不同的消息体，以双端返回kv为准
```

#### 3 通知点击回调
```dart
    _xgPushClickAction   数据类型 Map<String, Object> para: iOS/Android返回不同的消息体，以双端返回kv为准
```

#### 4 注册成功回调
```dart
    _onRegisteredDone   数据类型 String para: 注册成功信息
```

#### 5 注册失败回调
```dart
    _onRegisteredDeviceToken   数据类型 String para: xgToken，注册失败如果有xgToken则返回
```

#### 6 注销完成的回调
```dart
   _unRegistered   数据类型 String para:  注销成功或者失败信息
```

#### 7 绑定账号/标签/用户属性回调
**说明**V1.2.8开始返回类型由String->Map，新增code及type标识！
```dart
   _xgPushDidBindWithIdentifier   数据类型 Map<String, Object> para: 
        key: 
            code:int类型，操作结果，0代表成功
            type: String类型，操作类型，取值为account/tag/attributes
            msg: String类型，提示信息
```

#### 8 解绑账号/标签/用户属性回调
**说明**V1.2.8开始返回类型由String->Map，新增code及type标识！
```dart
   _xgPushDidUnbindWithIdentifier   数据类型 Map<String, Object> para: 
        key: 
            code:int类型，操作结果，0代表成功
            type: String类型，操作类型，取值为account/tag/attributes
            msg: String类型，提示信息
```

#### 9 更新标签/用户属性回调
**说明**V1.2.8开始返回类型由String->Map，新增code及type标识！
```dart
   _xgPushDidUpdatedBindedIdentifier   数据类型 Map<String, Object> para: 
        key: 
            code:int类型，操作结果，0代表成功
            type: String类型，操作类型，取值为tag/attributes
            msg: String类型，提示信息
```

#### 10 清除所有账号/标签/用户属性回调
**说明**V1.2.8开始返回类型由String->Map，新增code及type标识！
```dart
   _xgPushDidClearAllIdentifiers   数据类型 Map<String, Object> para:
        key: 
            code:int类型，操作结果，0代表成功
            type: String类型，操作类型，取值为account/tag/attributes
            msg: String类型，提示信息
```



## 安卓端 XgAndroidApi 接口说明

> 说明：XgAndroidApi 为针对安卓独立接口的内部再次封装，可以通过 `XgFlutterPlugin.xgApi` 直接访问，例如：
> ```dart
>     // 调用示例：开启厂商其他推送接口
>     XgFlutterPlugin.xgApi.enableOtherPush()
> ```

#### 1. 开启其他推送
```dart
    enableOtherPush();
```

#### 2. 设置小米推送的APP_ID
```dart
    setMiPushAppId({String appId});
```

#### 3. 设置小米推送的APP_KEY
```dart
    setMiPushAppKey({String appKey});
```

#### 4. 设置魅族推送所需appID
```dart
    setMzPushAppId({String appId});
```

#### 5. 设置魅族推送所需appKey
```dart
    setMzPushAppKey({String appKey});
```

#### 6. 开启Oppo通知
```dart
    enableOppoNotification();
```

#### 7. 设置Oppo推送ID
```dart
    setOppoPushAppId({String appId});
```

#### 8. 设置Oppo推送Key
```dart
     setOppoPushAppKey({String appKey});
```

#### 9. 清空当前应用在通知栏的通知
```dart
     cancelAllNotification();
```

#### 10. 配置是否关闭拉起其他 App；填入 false 为不拉起，默认为 true
```dart
     enablePullUpOtherApp({bool enable})
```

#### 11. 安卓角标设置，支持华为、OPPO、vivo，其中 OPPO 需另外向厂商申请角标展示权限
```dart
     setBadgeNum({int badgeNum})
```

#### 12. 设置手机应用角标归0，支持华为、OPPO、vivo，其中 OPPO 需另外向厂商申请角标展示权限
```dart
     resetBadgeNum()
```

