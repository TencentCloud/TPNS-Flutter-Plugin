## 厂商通道接入说明
### 1. 华为通道接入，可参考信鸽SDK[华为通道接入](https://cloud.tencent.com/document/product/548/36653)
#### 1.1 在 App 模块下的 build.gradle 文件内添加以下配置：

```
      android: {
        defaultConfig {
          manifestPlaceholders = [
            ....
            /// 配置华为 APPID               
            HW_APPID: "华为的APPID"
            .....
          ]
        }
      }
```

```
        // 导入华为推送相关依赖
        implementation 'com.tencent.tpns:huawei:[VERSION]-release'// 华为推送 [VERSION] 为当前SDK版本号,版本号可在SDK下载页查看
```

#### 1.2 开启华为推送
在调用 `regPush()`注册信鸽推送之前调用启用三方通道接口以开启厂商推送：

```dart
      XgAndroidApi.enableOtherPush();
      XgAndroidApi.regPush();
```

#### 1.3 代码混淆

```
      -ignorewarning
      -keepattributes *Annotation*
      -keepattributes Exceptions
      -keepattributes InnerClasses
      -keepattributes Signature
      -keepattributes SourceFile,LineNumberTable
      -keep class com.hianalytics.android.**{*;}
      -keep class com.huawei.updatesdk.**{*;}
      -keep class com.huawei.hms.**{*;}
      -keep class com.huawei.android.hms.agent.**{*;}
```



### 2. 小米通道接入，可参考信鸽SDK[小米通道接入](https://cloud.tencent.com/document/product/548/36653)

#### 2.1 引入小米推送的依赖

```
      implementation 'com.tencent.tpns:xiaomi:[VERSION]-release'  // 小米推送 [VERSION] 为当前SDK版本号,版本号可在SDK下载页查看
```
#### 2.2 开启小米推送

```dart
      // 设置小米 AppID 和 AppKey。
      XgAndroidApi.setMiPushAppId(appId:"APP_ID");
      XgAndroidApi.setMiPushAppKey(appKey: "APPKEY");
      
      // 打开第三方推送并注册
      XgAndroidApi.enableOtherPush();
      XgAndroidApi.regPush();
```
#### 2.3 代码混淆

```
      -keep class com.xiaomi.**{*;}
      -keep public class * extends com.xiaomi.mipush.sdk.PushMessageReceiver
```




### 3. 魅族通道接入，可参考信鸽SDK[魅族通道接入](https://cloud.tencent.com/document/product/548/36655)
#### 3.1 引入魅族推送的依赖

```
      implementation 'com.tencent.tpns:meizu:[VERSION]-release'  // 魅族推送 [VERSION] 为当前SDK版本号,版本号可在SDK下载页查看
```
#### 3.2 开启魅族推送

```dart
      /// 设置魅族 AppID 和 AppKey
      XgAndroidApi.setMzPushAppId(appId:"APP_ID");
      XgAndroidApi.setMzPushAppKey(appKey: "APPKEY");
      
      /// 打开第三方推送
      XgAndroidApi.enableOtherPush();
      XgAndroidApi.regPush();
```

#### 3.3 代码混淆

```
      -dontwarn com.meizu.cloud.pushsdk.**
      -keep class com.meizu.cloud.pushsdk.**{*;}
```



### 4. vivo通道接入，可参考信鸽SDK [vivo通道接入](https://cloud.tencent.com/document/product/548/36657)
#### 4.1 在 App 模块下的 build.gradle 文件内

```
      android: {
        defaultConfig {
          manifestPlaceholders = [
            ....
            VIVO_APPID: "VIVO的APPID"
            VIVO_APPKEY:"VIVO的APP_KEy",
            .....
          ]
        }
      }
```

```
      /// 引入 vivo 推送的依赖
      implementation 'com.tencent.tpns:vivo:[VERSION]-release'  // vivo 推送 [VERSION] 为当前SDK版本号,版本号可在SDK下载页查看
```
#### 4.2 启用 vivo 推送

```dart
      /// 打开第三方推送
      XgAndroidApi.enableOtherPush();
      XgAndroidApi.regPush();
```
#### 4.3代码混淆

```
      -dontwarn com.vivo.push.**
      -keep class com.vivo.push.**{*; }
      -keep class com.vivo.vms.**{*; }
      -keep class com.tencent.android.vivopush.VivoPushMessageReceiver{*;}
```



### 5. OPPO通道接入，可参考信鸽SDK [OPPO通道接入](https://cloud.tencent.com/document/product/548/36658)

#### 5.1 引入 OPPO 推送的依赖

```
      implementation 'com.tencent.tpns:oppo:[VERSION]-release'  // OPPO 推送 [VERSION] 为当前SDK版本号,版本号可在SDK下载页查看
```
#### 5.2 请求通知栏权限（可选），在调用腾讯移动推送`XgAndroidApi.regPush()`前，调用以下代码：

```dart
      /// TPNS-OPPO 依赖包版本在 1.1.5.1 及以上支持，系统 ColorOS 5.0 以上有效
      XgAndroidApi.enableOppoNotification();
```
#### 5.3 开启推送

```
      /// 设置OPPO AppKey 和 AppSecret
      XgAndroidApi.setOppoPushAppId(appId:"Oppo的AppKey");
      XgAndroidApi.setOppoPushAppKey(appKey: "Oppo的AppSecret");
      
      /// 打开第三方推送
      XgAndroidApi.enableOtherPush();
      XgAndroidApi.regPush();
```
#### 5.4 代码混淆

```
      -keep public class * extends android.app.Service
      -keep class com.heytap.mcssdk.** {*;}
      -keep class com.heytap.msp.push.** { *;}
```



### 6. FCM通道接入，可参考信鸽SDK [FCM通道接入](https://cloud.tencent.com/document/product/548/36656)

#### 6.1 添加 google-services.json 文件，请参考[FCM通道配置文件](https://cloud.tencent.com/document/product/548/36656#.E9.85.8D.E7.BD.AE.E5.86.85.E5.AE.B9)。
#### 6.2 在项目级的 build.gradle 文件中的 dependencies 节点中添加下面代码，集成谷歌 service

```
      classpath 'com.google.gms:google-services:4.2.0'
```
#### 6.3 在应用级的 build.gradle 文件中，添加依赖：

```
      implementation 'com.tencent.tpns:fcm:[VERSION]-release'  // fcm 推送 [VERSION] 为当前SDK版本号,版本号可在SDK下载页查看
      implementation  'com.google.firebase:firebase-messaging:17.6.0'
```

　　并在应用级的 build.gradle 文件末尾新增：
```
      apply plugin: 'com.google.gms.google-services'
```
#### 6.4 启用 FCM 推送

```dart
      /// 打开第三方推送
      XgAndroidApi.enableOtherPush();
      XgAndroidApi.regPush();
```