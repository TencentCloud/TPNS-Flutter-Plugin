#import "XgFlutterPlugin.h"
#import <TPNS-iOS/XGPush.h>
#import <TPNS-iOS/XGPushPrivate.h>

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
#import <UserNotifications/UserNotifications.h>
#endif

typedef NS_ENUM(NSUInteger, XGPushTokenAccountType) {
    XGPushTokenAccountTypeUNKNOWN = (0),         // 未知类型，单账号绑定默认使用
    XGPushTokenAccountTypeCUSTOM = (1),          // 自定义
    XGPushTokenAccountTypeIDFA = (1001),         // 广告唯一标识 IDFA
    XGPushTokenAccountTypePHONE_NUMBER = (1002), // 手机号码
    XGPushTokenAccountTypeWX_OPEN_ID = (1003),   // 微信 OPENID
    XGPushTokenAccountTypeQQ_OPEN_ID = (1004),   // QQ OPENID
    XGPushTokenAccountTypeEMAIL = (1005),        // 邮箱
    XGPushTokenAccountTypeSINA_WEIBO = (1006),   // 新浪微博
    XGPushTokenAccountTypeALIPAY = (1007),       // 支付宝
    XGPushTokenAccountTypeTAOBAO = (1008),       // 淘宝
    XGPushTokenAccountTypeDOUBAN = (1009),       // 豆瓣
    XGPushTokenAccountTypeFACEBOOK = (1010),     // FACEBOOK
    XGPushTokenAccountTypeTWITTER = (1011),      // TWITTER
    XGPushTokenAccountTypeGOOGLE = (1012),       // GOOGLE
    XGPushTokenAccountTypeBAIDU = (1013),        // 百度
    XGPushTokenAccountTypeJINGDONG = (1014),     // 京东
    XGPushTokenAccountTypeLINKEDIN = (1015)      // LINKEDIN
};

@interface  XgFlutterPlugin()<XGPushDelegate, XGPushTokenManagerDelegate>

@end


@implementation XgFlutterPlugin

bool withInAppAlert = true;


+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"tpns_flutter_plugin"
            binaryMessenger:[registrar messenger]];
  XgFlutterPlugin* instance = [[XgFlutterPlugin alloc] init];
  instance.channel = channel;
  [registrar addApplicationDelegate:instance];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (id)init {
    self = [super init];
    return self;
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([@"xgSdkVersion" isEqualToString:call.method]) {
    result([[XGPush defaultManager] sdkVersion]);
  } else if([@"getOtherPushToken" isEqualToString:call.method]) {
      result([[XGPushTokenManager defaultTokenManager] deviceTokenString]);
  } else if([@"xgToken" isEqualToString:call.method]) {
      result([[XGPushTokenManager defaultTokenManager] xgTokenString]);
  } else if([@"startXg" isEqualToString:call.method]) {
      [self startXg:call result:result];
  } else if([@"setEnableDebug" isEqualToString:call.method]) {
      [self setEnableDebug:call result:result];
  } else if([@"setAccount" isEqualToString:call.method]) {
      [self setAccount:call result:result];
  } else if([@"deleteAccount" isEqualToString:call.method]) {
      [self deleteAccount:call result:result];
  } else if([@"cleanAccounts" isEqualToString:call.method]) {
      [[XGPushTokenManager defaultTokenManager] clearAccounts];
  } else if([@"addTags" isEqualToString:call.method]) {
      [self addTags:call result:result];
  } else if([@"setTags" isEqualToString:call.method]) {
      [self setTags:call result:result];
  } else if([@"deleteTags" isEqualToString:call.method]) {
      [self deleteTags:call result:result];
  } else if([@"cleanTags" isEqualToString:call.method]) {
      [[XGPushTokenManager defaultTokenManager] clearTags];
  } else if([@"upsertAttributes" isEqualToString:call.method]) {
      [self upsertAttributes:call result:result];
  } else if([@"delAttributes" isEqualToString:call.method]) {
      [self delAttributes:call result:result];
  } else if([@"clearAndAppendAttributes" isEqualToString:call.method]) {
      [self clearAndAppendAttributes:call result:result];
  } else if([@"clearAttributes" isEqualToString:call.method]) {
      [[XGPushTokenManager defaultTokenManager] clearAttributes];
  } else if([@"bindWithIdentifier" isEqualToString:call.method]) {
      [self bindWithIdentifier:call result:result];
  } else if([@"updateBindIdentifier" isEqualToString:call.method]) {
      [self updateBindIdentifier:call result:result];
  } else if([@"unbindWithIdentifier" isEqualToString:call.method]) {
      [self unbindWithIdentifier:call result:result];
  } else if([@"bindWithIdentifiers" isEqualToString:call.method]) {
      [self bindWithIdentifiers:call result:result];
  } else if([@"updateBindIdentifiers" isEqualToString:call.method]) {
      [self updateBindIdentifiers:call result:result];
  } else if([@"unbindWithIdentifiers" isEqualToString:call.method]) {
      [self unbindWithIdentifiers:call result:result];
  } else if([@"clearAllIdentifier" isEqualToString:call.method]) {
      [self clearAllIdentifier:call result:result];
  } else if([@"setBadge" isEqualToString:call.method]) {
      [self setBadge:call result:result];
  } else if([@"setAppBadge" isEqualToString:call.method]) {
      [self setAppBadge:call result:result];
  } else if([@"stopXg" isEqualToString:call.method]) {
      [[XGPush defaultManager] stopXGNotification];
  } else if([@"configureClusterDomainName" isEqualToString:call.method]) {
      [self configureClusterDomainName:call result:result];
  } else {
    result(FlutterMethodNotImplemented);
  }
}

- (NSUInteger)getAccountType:(NSString *)typeStr {
    if ([typeStr isEqualToString:@"UNKNOWN"] || [typeStr isEqualToString:@"IMEI"]) {
        return XGPushTokenAccountTypeUNKNOWN;
    } else if ([typeStr isEqualToString:@"CUSTOM"]) {
        return XGPushTokenAccountTypeCUSTOM;
    } else if ([typeStr isEqualToString:@"IDFA"]) {
        return XGPushTokenAccountTypeIDFA;
    } else if ([typeStr isEqualToString:@"PHONE_NUMBER"]) {
        return XGPushTokenAccountTypePHONE_NUMBER;
    } else if ([typeStr isEqualToString:@"WX_OPEN_ID"]) {
        return XGPushTokenAccountTypeWX_OPEN_ID;
    } else if ([typeStr isEqualToString:@"QQ_OPEN_ID"]) {
        return XGPushTokenAccountTypeQQ_OPEN_ID;
    } else if ([typeStr isEqualToString:@"EMAIL"]) {
        return XGPushTokenAccountTypeEMAIL;
    } else if ([typeStr isEqualToString:@"SINA_WEIBO"]) {
        return XGPushTokenAccountTypeSINA_WEIBO;
    } else if ([typeStr isEqualToString:@"ALIPAY"]) {
        return XGPushTokenAccountTypeALIPAY;
    } else if ([typeStr isEqualToString:@"TAOBAO"]) {
        return XGPushTokenAccountTypeTAOBAO;
    } else if ([typeStr isEqualToString:@"DOUBAN"]) {
        return XGPushTokenAccountTypeDOUBAN;
    } else if ([typeStr isEqualToString:@"FACEBOOK"]) {
        return XGPushTokenAccountTypeFACEBOOK;
    } else if ([typeStr isEqualToString:@"TWITTER"]) {
        return XGPushTokenAccountTypeTWITTER;
    } else if ([typeStr isEqualToString:@"GOOGLE"]) {
        return XGPushTokenAccountTypeGOOGLE;
    } else if ([typeStr isEqualToString:@"BAIDU"]) {
        return XGPushTokenAccountTypeBAIDU;
    } else if ([typeStr isEqualToString:@"JINGDONG"]) {
        return XGPushTokenAccountTypeJINGDONG;
    } else if ([typeStr isEqualToString:@"LINKEDIN"]) {
        return XGPushTokenAccountTypeLINKEDIN;
    } else return XGPushTokenAccountTypeUNKNOWN;
}

/// 集群域名配置（非广州集群需要在startXg之前调用此函数）
- (void)configureClusterDomainName:(FlutterMethodCall*)call result:(FlutterResult)result {
    NSDictionary *configurationInfo = call.arguments;
    [[XGPush defaultManager] configureClusterDomainName:configurationInfo[@"domainStr"]];
}


/// 使用APPID/APPKEY启动信鸽
- (void)startXg:(FlutterMethodCall*)call result:(FlutterResult)result {
    NSDictionary *configurationInfo = call.arguments;
    withInAppAlert = [configurationInfo[@"withInAppAlert"] boolValue];
    [[XGPush defaultManager] startXGWithAccessID:(uint32_t)[configurationInfo[@"accessId"] integerValue] accessKey:configurationInfo[@"accessKey"] delegate:self];
}

/// 设置Debug
- (void)setEnableDebug:(FlutterMethodCall*)call result:(FlutterResult)result {
    NSDictionary *configurationInfo = call.arguments;
    [[XGPush defaultManager] setEnableDebug:[configurationInfo[@"enableDebug"] boolValue]];
}

/**===================================V1.0.4新增账号标签接口===================================*/

/// 绑定账号
- (void)setAccount:(FlutterMethodCall*)call result:(FlutterResult)result {
    NSDictionary *configurationInfo = call.arguments;
    [[XGPushTokenManager defaultTokenManager] upsertAccountsByDict:@{ @([self getAccountType:configurationInfo[@"accountType"]]):configurationInfo[@"account"] }];
}

/// 删除指定账号
- (void)deleteAccount:(FlutterMethodCall*)call result:(FlutterResult)result {
    NSDictionary *configurationInfo = call.arguments;
    NSSet *accountsKeys = [[NSSet alloc] initWithObjects:@([self getAccountType:configurationInfo[@"accountType"]]), nil];
    [[XGPushTokenManager defaultTokenManager] delAccountsByKeys:accountsKeys];
}

/// 追加标签
- (void)addTags:(FlutterMethodCall*)call result:(FlutterResult)result {
    NSArray *tags = call.arguments;
    [[XGPushTokenManager defaultTokenManager] appendTags:tags];
}

/// 覆盖标签(清除所有标签再追加)
- (void)setTags:(FlutterMethodCall*)call result:(FlutterResult)result {
    NSArray *tags = call.arguments;
    [[XGPushTokenManager defaultTokenManager] clearAndAppendTags:tags];
}

/// 删除指定标签
- (void)deleteTags:(FlutterMethodCall*)call result:(FlutterResult)result {
    NSArray *tags = call.arguments;
    [[XGPushTokenManager defaultTokenManager] delTags:tags];
}

/**===================================V1.1.5新增用户属性接口===================================*/

/// 新增用户属性
- (void)upsertAttributes:(FlutterMethodCall*)call result:(FlutterResult)result {
    NSDictionary *attributes = call.arguments;
    [[XGPushTokenManager defaultTokenManager] upsertAttributes:attributes];
}

 /// 删除用户属性
- (void)delAttributes:(FlutterMethodCall*)call result:(FlutterResult)result {
    NSArray *attributeList = call.arguments;
    NSSet *attributeKeys = [[NSSet alloc] initWithArray:attributeList];
    [[XGPushTokenManager defaultTokenManager] delAttributes:attributeKeys];
}

  /// 更新用户属性
- (void)clearAndAppendAttributes:(FlutterMethodCall*)call result:(FlutterResult)result {
    NSDictionary *attributes = call.arguments;
    [[XGPushTokenManager defaultTokenManager] clearAndAppendAttributes:attributes];
}

/**===================================V1.0.4废弃账号标签接口===================================*/

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-implementations"
/// 绑定标签或账号
- (void)bindWithIdentifier:(FlutterMethodCall*)call result:(FlutterResult)result {
    NSDictionary *configurationInfo = call.arguments;
    [[XGPushTokenManager defaultTokenManager] bindWithIdentifier:configurationInfo[@"identify"] type:[configurationInfo[@"bindType"] integerValue]];
}

/// 更新标签或账号
- (void)updateBindIdentifier:(FlutterMethodCall*)call result:(FlutterResult)result {
    NSDictionary *configurationInfo = call.arguments;
    if ([configurationInfo[@"bindType"] integerValue] == XGPushTokenBindTypeAccount) {
        [[XGPushTokenManager defaultTokenManager] updateBindedIdentifiers:@[@{@"account" : configurationInfo[@"identify"], @"accountType" : @(0)}] bindType:[configurationInfo[@"bindType"] integerValue]];
    } else if ([configurationInfo[@"bindType"] integerValue] == XGPushTokenBindTypeTag) {
        [[XGPushTokenManager defaultTokenManager] updateBindedIdentifiers:@[configurationInfo[@"identify"]] bindType:[configurationInfo[@"bindType"] integerValue]];
    }
}

/// 解绑标签或账号
- (void)unbindWithIdentifier:(FlutterMethodCall*)call result:(FlutterResult)result {
    NSDictionary *configurationInfo = call.arguments;
    [[XGPushTokenManager defaultTokenManager] unbindWithIdentifer:configurationInfo[@"identify"] type:[configurationInfo[@"bindType"] integerValue]];
}

/// 批量绑定标签或账号
- (void)bindWithIdentifiers:(FlutterMethodCall*)call result:(FlutterResult)result {
    NSDictionary *configurationInfo = call.arguments;
    [[XGPushTokenManager defaultTokenManager] bindWithIdentifiers:configurationInfo[@"identifys"] type:[configurationInfo[@"bindType"] integerValue]];
}

/// 批量更新标签或账号
- (void)updateBindIdentifiers:(FlutterMethodCall*)call result:(FlutterResult)result {
    NSDictionary *configurationInfo = call.arguments;
    [[XGPushTokenManager defaultTokenManager] updateBindedIdentifiers:configurationInfo[@"identifys"] bindType:[configurationInfo[@"bindType"] integerValue]];
}

/// 批量解绑标签或账号
- (void)unbindWithIdentifiers:(FlutterMethodCall*)call result:(FlutterResult)result {
    NSDictionary *configurationInfo = call.arguments;
    [[XGPushTokenManager defaultTokenManager] unbindWithIdentifers:configurationInfo[@"identifys"] type:[configurationInfo[@"bindType"] integerValue]];
}

/// 清除所有标签或账号
- (void)clearAllIdentifier:(FlutterMethodCall*)call result:(FlutterResult)result {
    NSDictionary *configurationInfo = call.arguments;
    [[XGPushTokenManager defaultTokenManager] clearAllIdentifiers:[configurationInfo[@"bindType"] integerValue]];
}

#pragma clang diagnostic pop

/**==========================================================================*/


/// 同步角标值到TPNS服务器
- (void)setBadge:(FlutterMethodCall*)call result:(FlutterResult)result {
    NSDictionary *configurationInfo = call.arguments;
    [[XGPush defaultManager] setBadge:[configurationInfo[@"badgeSum"] integerValue]];
}

/// 设置应用角标
- (void)setAppBadge:(FlutterMethodCall*)call result:(FlutterResult)result {
    NSDictionary *configurationInfo = call.arguments;
    dispatch_async(dispatch_get_main_queue(), ^{
        [XGPush defaultManager].xgApplicationBadgeNumber = [configurationInfo[@"badgeSum"] integerValue];
    });
}

#pragma mark - XGPushDelegate
- (void)xgPushDidFinishStart:(BOOL)isSuccess error:(NSError *)error {
    if ([XGPush defaultManager].isEnableDebug) {
        NSLog(@"%s, result %@, error %@", __FUNCTION__, isSuccess?@"OK":@"NO", error);
    }
}

- (void)xgPushDidFinishStop:(BOOL)isSuccess error:(NSError *)error {
    NSString *resultStr = @"";
    if (error) {
        resultStr = [error domain];
    } else {
        resultStr = @"注销完成";
    }
    [_channel invokeMethod:@"unRegistered" arguments:resultStr];
}

/// 注册推送服务成功回调
/// @param deviceToken APNs 生成的Device Token
/// @param xgToken TPNS 生成的 Token，推送消息时需要使用此值。TPNS 维护此值与APNs 的 Device Token的映射关系
/// @param error 错误信息，若error为nil则注册推送服务成功
- (void)xgPushDidRegisteredDeviceToken:(nullable NSString *)deviceToken xgToken:(nullable NSString *)xgToken error:(nullable NSError *)error {
    if (!error) {
        [_channel invokeMethod:@"onRegisteredDone" arguments:xgToken];
        [[XGPushTokenManager defaultTokenManager] setDelegate:self];
    } else {
        NSString *describeStr = [NSString stringWithFormat:@"TPNS token:%@ error:%@", xgToken, error.description];
        [_channel invokeMethod:@"onRegisteredDeviceToken" arguments:describeStr];
    }
}

/// 统一接收消息的回调
/// @param notification 消息对象(有2种类型NSDictionary和UNNotification具体解析参考示例代码)
/// @note 此回调为前台收到通知消息及所有状态下收到静默消息的回调（消息点击需使用统一点击回调）
/// 区分消息类型说明：xg字段里的msgtype为1则代表通知消息msgtype为2则代表静默消息
- (void)xgPushDidReceiveRemoteNotification:(nonnull id)notification withCompletionHandler:(nullable void (^)(NSUInteger))completionHandler {
    NSDictionary *notificationDic = nil;
    if ([notification isKindOfClass:[UNNotification class]]) {
        notificationDic = ((UNNotification *)notification).request.content.userInfo;
        if(withInAppAlert) {
            completionHandler(UNNotificationPresentationOptionBadge | UNNotificationPresentationOptionSound | UNNotificationPresentationOptionAlert);
        }else {
            completionHandler(UNNotificationPresentationOptionBadge | UNNotificationPresentationOptionSound);
        }
    } else if ([notification isKindOfClass:[NSDictionary class]]) {
        notificationDic = notification;
        completionHandler(UIBackgroundFetchResultNewData);
    }
    
    if ([XGPush defaultManager].isEnableDebug) {
        NSLog(@"[TPNS Demo] receive notification %@", notificationDic);
    }
    
    NSDictionary *tpnsInfo = notificationDic[@"xg"];
    NSNumber *msgType = tpnsInfo[@"msgtype"];
    if ([UIApplication sharedApplication].applicationState == UIApplicationStateActive && msgType.integerValue == 1) {
        /// 前台收到通知消息
        [_channel invokeMethod:@"onReceiveNotificationResponse" arguments:notificationDic];
    } else {
        /// 静默消息
        [_channel invokeMethod:@"onReceiveMessage" arguments:notificationDic];
    }
}

/// 统一点击回调
/// @param response 如果iOS 10+/macOS 10.14+则为UNNotificationResponse，低于目标版本则为NSDictionary
- (void)xgPushDidReceiveNotificationResponse:(nonnull id)response withCompletionHandler:(nonnull void (^)(void))completionHandler {
    NSDictionary *notificationDic = nil;
    if ([response isKindOfClass:[UNNotificationResponse class]]) {
        /// iOS10+消息体获取
        notificationDic = ((UNNotificationResponse *)response).notification.request.content.userInfo;
    } else if ([response isKindOfClass:[NSDictionary class]]) {
        /// <IOS10消息体获取
        notificationDic = response;
    }
    
    if ([XGPush defaultManager].isEnableDebug) {
        NSLog(@"[TPNS Demo] click notification %@", notificationDic);
    }
    
    [_channel invokeMethod:@"xgPushClickAction" arguments:notificationDic];
    completionHandler();
}

- (void)xgPushDidSetBadge:(BOOL)isSuccess error:(NSError *)error {
    NSString *argumentDescribe = @"设置角标成功";
    if (error) {
        argumentDescribe = [NSString stringWithFormat:@"设置角标失败：%@",error.description];
    }
    [_channel invokeMethod:@"xgPushDidSetBadge" arguments:argumentDescribe];
}

/// TPNS长链接连接成功，仅iOS
- (void)xgPushNetworkConnected {
    [_channel invokeMethod:@"xgPushNetworkConnected" arguments:@"TPNS长链接已建立"];
    if ([XGPush defaultManager].isEnableDebug) {
        NSLog(@"TPNS connection connected."); 
    }
}


#pragma mark - XGPushTokenManagerDelegate

/**===============================账号和标签回调，V1.1.5新增===============================*/

- (void)xgPushDidUpsertAccountsByDict:(NSDictionary *)accountsDict error:(NSError *)error {
    NSString *msg = error == nil ? @"bindAccount successful" : [NSString stringWithFormat:@"bindAccount fail，error:%@", error.description];
    NSNumber *code = error == nil ? @(0) : @(error.code);
    NSDictionary *resultDic = @{@"code":code, @"type":@"account", @"msg":msg};
    [_channel invokeMethod:@"xgPushDidBindWithIdentifier" arguments:resultDic];
}
- (void)xgPushDidDelAccountsByKeys:(NSSet<NSNumber *> *)accountsKeys error:(NSError *)error {
    NSString *msg = error == nil ? @"delAccountsByKeys successful" : [NSString stringWithFormat:@"delAccountsByKeys fail，error:%@", error.description];
    NSNumber *code = error == nil ? @(0) : @(error.code);
    NSDictionary *resultDic = @{@"code":code, @"type":@"account", @"msg":msg};
    [_channel invokeMethod:@"xgPushDidUnbindWithIdentifier" arguments:resultDic];
}

- (void)xgPushDidClearAccountsError:(NSError *)error {
    NSString *msg = error == nil ? @"clearAccounts successful" : [NSString stringWithFormat:@"clearAccounts fail，error:%@", error.description];
    NSNumber *code = error == nil ? @(0) : @(error.code);
    NSDictionary *resultDic = @{@"code":code, @"type":@"account", @"msg":msg};
    [_channel invokeMethod:@"xgPushDidClearAllIdentifiers" arguments:resultDic];
}

- (void)xgPushDidAppendTags:(NSArray<NSString *> *)tags error:(NSError *)error {
    NSString *msg = error == nil ? @"appendTags successful" : [NSString stringWithFormat:@"appendTags fail，error:%@", error.description];
    NSNumber *code = error == nil ? @(0) : @(error.code);
    NSDictionary *resultDic = @{@"code":code, @"type":@"tag", @"msg":msg};
    [_channel invokeMethod:@"xgPushDidBindWithIdentifier" arguments:resultDic];
}
- (void)xgPushDidDelTags:(NSArray<NSString *> *)tags error:(NSError *)error {
    NSString *msg = error == nil ? @"delTags successful" : [NSString stringWithFormat:@"delTags fail，error:%@", error.description];
    NSNumber *code = error == nil ? @(0) : @(error.code);
    NSDictionary *resultDic = @{@"code":code, @"type":@"tag", @"msg":msg};
    [_channel invokeMethod:@"xgPushDidUnbindWithIdentifier" arguments:resultDic];
}
- (void)xgPushDidClearAndAppendTags:(NSArray<NSString *> *)tags error:(NSError *)error {
    NSString *msg = error == nil ? @"clearAndAppendTags successful" : [NSString stringWithFormat:@"clearAndAppendTags fail，error:%@", error.description];
    NSNumber *code = error == nil ? @(0) : @(error.code);
    NSDictionary *resultDic = @{@"code":code, @"type":@"tag", @"msg":msg};
    [_channel invokeMethod:@"xgPushDidUpdatedBindedIdentifier" arguments:resultDic];
}

- (void)xgPushDidClearTagsError:(NSError *)error {
    NSString *msg = error == nil ? @"clearTags successful" : [NSString stringWithFormat:@"clearTags fail，error:%@", error.description];
    NSNumber *code = error == nil ? @(0) : @(error.code);
    NSDictionary *resultDic = @{@"code":code, @"type":@"tag", @"msg":msg};
    [_channel invokeMethod:@"xgPushDidClearAllIdentifiers" arguments:resultDic];
}

/**===============================用户属性回调，V1.1.5新增===============================*/

- (void)xgPushDidUpsertAttributes:(NSDictionary *)attributes invalidKeys:(NSArray *)keys error:(NSError *)error {
    NSString *msg = error == nil ? @"upsertAttributes successful" : [NSString stringWithFormat:@"upsertAttributes fail，error:%@", error.description];
    NSNumber *code = error == nil ? @(0) : @(error.code);
    NSDictionary *resultDic = @{@"code":code, @"type":@"attributes", @"msg":msg};
    [_channel invokeMethod:@"xgPushDidBindWithIdentifier" arguments:resultDic];
}

- (void)xgPushDidDelAttributeKeys:(NSSet *)attributeKeys invalidKeys:(NSArray *)keys error:(NSError *)error {
    NSString *msg = error == nil ? @"delAttributeKeys successful" : [NSString stringWithFormat:@"delAttributeKeys fail，error:%@", error.description];
    NSNumber *code = error == nil ? @(0) : @(error.code);
    NSDictionary *resultDic = @{@"code":code, @"type":@"attributes", @"msg":msg};
    [_channel invokeMethod:@"xgPushDidUnbindWithIdentifier" arguments:resultDic];
}

- (void)xgPushDidClearAndAppendAttributes:(NSDictionary *)attributes invalidKeys:(NSArray *)keys error:(NSError *)error {
    NSString *msg = error == nil ? @"clearAndAppendAttributes successful" : [NSString stringWithFormat:@"clearAndAppendAttributes fail，error:%@", error.description];
    NSNumber *code = error == nil ? @(0) : @(error.code);
    NSDictionary *resultDic = @{@"code":code, @"type":@"attributes", @"msg":msg};
    [_channel invokeMethod:@"xgPushDidUpdatedBindedIdentifier" arguments:resultDic];
}

- (void)xgPushDidClearAttributesWithError:(NSError *)error {
    NSString *msg = error == nil ? @"clearAttributes successful" : [NSString stringWithFormat:@"clearAttributes fail，error:%@", error.description];
    NSNumber *code = error == nil ? @(0) : @(error.code);
    NSDictionary *resultDic = @{@"code":code, @"type":@"attributes", @"msg":msg};
    [_channel invokeMethod:@"xgPushDidClearAllIdentifiers" arguments:resultDic];
}


/**=======================================================================*/

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-implementations"
- (void)xgPushDidBindWithIdentifier:(NSString *)identifier type:(XGPushTokenBindType)type error:(NSError *)error {
    NSString *msg = error == nil ? @"bindWithIdentifier successful" : [NSString stringWithFormat:@"bindWithIdentifier fail，error:%@", error.description];
    NSNumber *code = error == nil ? @(0) : @(error.code);
    NSString *typeStr = type == XGPushTokenBindTypeAccount ? @"account" : @"tag";
    NSDictionary *resultDic = @{@"code":code, @"type":typeStr, @"msg":msg};
    [_channel invokeMethod:@"xgPushDidBindWithIdentifier" arguments:resultDic];
}

- (void)xgPushDidUnbindWithIdentifier:(NSString *)identifier type:(XGPushTokenBindType)type error:(NSError *)error {
    NSString *msg = error == nil ? @"unbindWithIdentifier successful" : [NSString stringWithFormat:@"unbindWithIdentifier fail，error:%@", error.description];
    NSNumber *code = error == nil ? @(0) : @(error.code);
    NSString *typeStr = type == XGPushTokenBindTypeAccount ? @"account" : @"tag";
    NSDictionary *resultDic = @{@"code":code, @"type":typeStr, @"msg":msg};
    [_channel invokeMethod:@"xgPushDidUnbindWithIdentifier" arguments:resultDic];
}

- (void)xgPushDidBindWithIdentifiers:(NSArray<NSString *> *)identifiers type:(XGPushTokenBindType)type error:(NSError *)error {
    NSString *msg = error == nil ? @"bindWithIdentifiers successful" : [NSString stringWithFormat:@"bindWithIdentifiers fail，error:%@", error.description];
    NSNumber *code = error == nil ? @(0) : @(error.code);
    NSString *typeStr = type == XGPushTokenBindTypeAccount ? @"account" : @"tag";
    NSDictionary *resultDic = @{@"code":code, @"type":typeStr, @"msg":msg};
    [_channel invokeMethod:@"xgPushDidBindWithIdentifier" arguments:resultDic];
}

- (void)xgPushDidUnbindWithIdentifiers:(NSArray<NSString *> *)identifiers type:(XGPushTokenBindType)type error:(NSError *)error {
    NSString *msg = error == nil ? @"unbindWithIdentifiers successful" : [NSString stringWithFormat:@"unbindWithIdentifiers fail，error:%@", error.description];
    NSNumber *code = error == nil ? @(0) : @(error.code);
    NSString *typeStr = type == XGPushTokenBindTypeAccount ? @"account" : @"tag";
    NSDictionary *resultDic = @{@"code":code, @"type":typeStr, @"msg":msg};
    [_channel invokeMethod:@"xgPushDidUnbindWithIdentifier" arguments:resultDic];
}

- (void)xgPushDidUpdatedBindedIdentifiers:(NSArray<NSString *> *)identifiers bindType:(XGPushTokenBindType)type error:(NSError *)error {
    NSString *msg = error == nil ? @"updatedBindedIdentifiers successful" : [NSString stringWithFormat:@"updatedBindedIdentifiers fail，error:%@", error.description];
    NSNumber *code = error == nil ? @(0) : @(error.code);
    NSString *typeStr = type == XGPushTokenBindTypeAccount ? @"account" : @"tag";
    NSDictionary *resultDic = @{@"code":code, @"type":typeStr, @"msg":msg};
    [_channel invokeMethod:@"xgPushDidUpdatedBindedIdentifier" arguments:resultDic];
}

- (void)xgPushDidClearAllIdentifiers:(XGPushTokenBindType)type error:(NSError *)error {
    NSString *msg = error == nil ? @"clearAllIdentifiers successful" : [NSString stringWithFormat:@"clearAllIdentifiers fail，error:%@", error.description];
    NSNumber *code = error == nil ? @(0) : @(error.code);
    NSString *typeStr = type == XGPushTokenBindTypeAccount ? @"account" : @"tag";
    NSDictionary *resultDic = @{@"code":code, @"type":typeStr, @"msg":msg};
    [_channel invokeMethod:@"xgPushDidClearAllIdentifiers" arguments:resultDic];
}
#pragma clang diagnostic pop

#pragma mark - AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    /// 远程通知APNs通道
    NSDictionary *remoteNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if (!remoteNotification) {
        /// 远程通知TPNS通道
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        UILocalNotification *localNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
        if (localNotification && [localNotification isKindOfClass:[UILocalNotification class]]) {
        NSDictionary *tpnsInfo = [localNotification.userInfo objectForKey:@"xg"];
        if (tpnsInfo && [tpnsInfo isKindOfClass:[NSDictionary class]]) {
            NSNumber *msgType = [tpnsInfo objectForKey:@"msgtype"];
            if (msgType && [msgType isKindOfClass:[NSNumber class]] && msgType.intValue == 1) {
                remoteNotification = localNotification.userInfo;
            }
        }
#pragma clang diagnostic pop
    }
    }
    if (remoteNotification && [remoteNotification isKindOfClass:[NSDictionary class]]) {
        [XGPush defaultManager].launchOptions = [launchOptions mutableCopy];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self->_channel invokeMethod:@"xgPushClickAction" arguments:remoteNotification];
        });
    }
    return YES;
}

@end
