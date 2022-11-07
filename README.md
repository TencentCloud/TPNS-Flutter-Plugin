# tpns_flutter_plugin

## 安装
- 在工程 pubspec.yaml 中加入 dependencies，在命令行中运行：flutter pub get进行安装
```yaml
      dependencies:
        tpns_flutter_plugin:
          git:
            url: https://github.com/TencentCloud/TPNS-Flutter-Plugin
            ref: V1.2.0
```

- 注意：由于TPNS插件名变更xg_flutter_plugin->tpns_flutter_plugin，更新插件时V1.0.4及以上版本请使用tpns_flutter_plugin


## 使用

### 集群域名配置(如果您的应用非广州集群请按照以下方法进行域名配置，广州集群请忽略)
#### 集群域名：
       中国上海：tpns.sh.tencent.com
       中国香港：tpns.hk.tencent.com
       新加坡：tpns.sgp.tencent.com
- iOS端需要在注册方法startXg之前调用以下域名配置函数
  - domainStr 对应集群域名
```dart
      void configureClusterDomainName(String domainStr);
```
- Android端需要在Manifest 文件 application 标签内添加以下元数据：

```
  <application>
    // 其他安卓组件
    <meta-data
        android:name="XG_SERVER_SUFFIX"
        android:value="其他地区域名" />
  </application>
```

  
      

###  iOS

- 执行flutter pub get安装好插件后进入iOS文件目录（cd ios）执行：pod install安装依赖库
- 在 xcode8 之后需要点开推送选项： TARGETS -> Capabilities -> Push Notification 设为 on 状态

```dart
      import 'package:tpns_flutter_plugin/tpns_flutter_plugin.dart';
```

      说明(接口使用参考/tpns_flutter_plugin/example/lib/main.dart和/tpns_flutter_plugin/example/lib/ios/homeTest.dart文件)




###   Android
#### 1. 环境配置
```groovy
      android: {
         ....
         defaultConfig {
           applicationId "替换成自己应用 ID"
           ...
           ndk {
        /// 选择要添加的对应.so 库。
        abiFilters 'armeabi', 'armeabi-v7a', 'x86', 'x86_64', 'mips', 'mips64', 'arm64-v8a',
           }
           //
           manifestPlaceholders = [
               XG_ACCESS_ID : "替换自己的ACCESS_ID",  // 信鸽官网注册所得ACCESS_ID
               XG_ACCESS_KEY : "替换自己的ACCESS_KEY",  // 信鸽官网注册所得ACCESS_KEY
    
           ]
         }
       }
```

 

#### 2. 代码混淆
```
      -keep public class * extends android.app.Service
      -keep public class * extends android.content.BroadcastReceiver
      -keep class com.tencent.android.tpush.** {*;}
      -keep class com.tencent.tpns.baseapi.** {*;} 
      -keep class com.tencent.tpns.mqttchannel.** {*;}
      -keep class com.tencent.tpns.dataacquisition.** {*;}
    
      -keep class com.tencent.bigdata.baseapi.** {*;}   // TPNS-Android-SDK 1.2.0.1 及以上版本不需要此条配置
      -keep class com.tencent.bigdata.mqttchannel.** {*;}  // TPNS-Android-SDK 1.2.0.1 及以上版本不需要此条配置
```

#### 3. 厂商通道接入说明

**说明** : 提供安卓各厂商通道接入方法。

[点击查看](./documents/vendor.md)



### 启用推送
      /// iOS 需传 accessId 和 accessKey，iOS前台收到通知不希望展示时可将withInAppAlert参数置为false
      /// android 不需要传参数
      /// android 接入厂商通道时，请在此注册方法前调用各厂商通道参数配置接口
```dart
      void startXg(String accessId, String accessKey, {bool withInAppAlert = true});
```

### APIs

**说明** : 提供TPNS的所有业务接口。

[点击查看](./documents/APIs.md)


### TPNS-Flutter 使用常见问题参考
[点击查看](https://cloud.tencent.com/document/product/548/48803)
