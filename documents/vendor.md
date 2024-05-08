## 厂商通道接入说明

>? TPNS 已封装各厂商推送通道 SDK，请参考下文引入对应厂商推送 SDK 依赖。
> 如您的工程同时接入其他离线推送产品遇到依赖冲突，可对对应冲突依赖筛选使用其一。

### 1. 华为通道接入，可参考移动推送 TPNS [华为通道接入](https://cloud.tencent.com/document/product/548/45909)
#### 1.1 工程配置：
##### 1.1.1 在安卓项目级目录 build.gradle 文件，【buildscript】>【 repositories & dependencies】下分别添加华为仓库地址和 HMS gradle 插件依赖：
```
buildscript {
    repositories {
        google()
        jcenter()
        maven {url 'http://developer.huawei.com/repo/'}     // 华为 maven 仓库地址
    }
    dependencies {
        // 其他classpath配置
        classpath 'com.huawei.agconnect:agcp:1.9.1.301'     // 华为推送 gradle 插件依赖
    }
}
```
##### 1.1.2 在安卓项目级目录 build.gradle 文件，【allprojects】>【repositories】下添加华为依赖仓库地址：
```
allprojects {
    repositories {
        google()
        jcenter()
        maven {url 'http://developer.huawei.com/repo/'}     // 华为 maven 仓库地址
    }
}
```
##### 1.1.3. 将从华为推送平台获取的应用配置文件 agconnect-services.json 拷贝到 app 模块目录下。  
 ![](https://main.qcloudimg.com/raw/338c87faaeb388f648835f17aeddc490.png)
##### 1.1.4. 在 app 模块下 build.gradle 文件添加以下配置：
```
// app 其他 gradle 插件
apply plugin: 'com.huawei.agconnect'      // HMS SDK gradle 插件
android {
    // app 配置内容
}
```
##### 1.1.5. 在 app 模块下 build.gradle 文件内导入华为推送相关依赖：
```
dependencies {
    // ... 程序其他依赖

    // 华为推送 [VERSION] 为当前最新 SDK 版本号，版本号可在 SDK 下载页查看
    // TPNS Android SDK 自 1.2.1.3 版本起正式支持华为推送 V5 版本，请使用 1.2.1.3 及以上版本的 TPNS 华为依赖以避免集成冲突问题。
    implementation 'com.tencent.tpns:huawei:[VERSION]-release'      
    
    // HMS Core Push 模块依赖包
    implementation 'com.huawei.hms:push:6.12.0.300'        
}
```

#### 1.2 开启华为推送
在调用 `regPush()`注册信鸽推送之前调用启用三方通道接口以开启厂商推送：

```dart
      XgFlutterPlugin.xgApi.enableOtherPush();
      XgFlutterPlugin.xgApi.regPush();
```

#### 1.3 代码混淆

```
      -ignorewarnings
      -keepattributes *Annotation*
      -keepattributes Exceptions
      -keepattributes InnerClasses
      -keepattributes Signature
      -keepattributes SourceFile,LineNumberTable
      -keep class com.hianalytics.android.**{*;}
      -keep class com.huawei.updatesdk.**{*;}
      -keep class com.huawei.hms.**{*;}
```



### 2. 小米通道接入，可参考移动推送 TPNS [小米通道接入](https://cloud.tencent.com/document/product/548/36654)

#### 2.1 引入小米推送的依赖

```
      implementation 'com.tencent.tpns:xiaomi:[VERSION]-release'  // 小米推送 [VERSION] 为当前SDK版本号,版本号可在SDK下载页查看
```
#### 2.2 开启小米推送

```dart
      // 设置小米 AppID 和 AppKey。
      XgFlutterPlugin.xgApi.setMiPushAppId(appId:"APP_ID");
      XgFlutterPlugin.xgApi.setMiPushAppKey(appKey: "APPKEY");
      
      // 打开第三方推送并注册
      XgFlutterPlugin.xgApi.enableOtherPush();
      XgFlutterPlugin.xgApi.regPush();
```
#### 2.3 代码混淆

```
      -keep class com.xiaomi.**{*;}
      -keep public class * extends com.xiaomi.mipush.sdk.PushMessageReceiver
```




### 3. 魅族通道接入，可参考移动推送 TPNS [魅族通道接入](https://cloud.tencent.com/document/product/548/36655)
#### 3.1 引入魅族推送的依赖

```
      implementation 'com.tencent.tpns:meizu:[VERSION]-release'  // 魅族推送 [VERSION] 为当前SDK版本号,版本号可在SDK下载页查看
```
#### 3.2 开启魅族推送

```dart
      /// 设置魅族 AppID 和 AppKey
      XgFlutterPlugin.xgApi.setMzPushAppId(appId:"APP_ID");
      XgFlutterPlugin.xgApi.setMzPushAppKey(appKey: "APPKEY");
      
      /// 打开第三方推送
      XgFlutterPlugin.xgApi.enableOtherPush();
      XgFlutterPlugin.xgApi.regPush();
```

#### 3.3 代码混淆

```
      -dontwarn com.meizu.cloud.pushsdk.**
      -keep class com.meizu.cloud.pushsdk.**{*;}
```



### 4. vivo通道接入，可参考移动推送 TPNS  [vivo通道接入](https://cloud.tencent.com/document/product/548/36657)
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
      XgFlutterPlugin.xgApi.enableOtherPush();
      XgFlutterPlugin.xgApi.regPush();
```
#### 4.3代码混淆

```
      -dontwarn com.vivo.push.**
      -keep class com.vivo.push.**{*; }
      -keep class com.vivo.vms.**{*; }
      -keep class com.tencent.android.vivopush.VivoPushMessageReceiver{*;}
```



### 5. OPPO通道接入，可参考移动推送 TPNS  [OPPO通道接入](https://cloud.tencent.com/document/product/548/36658)

#### 5.1 引入 OPPO 推送的依赖

```
      implementation 'com.tencent.tpns:oppo:[VERSION]-release'  // OPPO 推送 [VERSION] 为当前SDK版本号,版本号可在SDK下载页查看
```
#### 5.2 开启推送

```dart
      /// 设置OPPO AppKey 和 AppSecret
      XgFlutterPlugin.xgApi.setOppoPushAppId(appId:"Oppo的AppKey");
      XgFlutterPlugin.xgApi.setOppoPushAppKey(appKey: "Oppo的AppSecret");
      
      /// 打开第三方推送
      XgFlutterPlugin.xgApi.enableOtherPush();
      XgFlutterPlugin.xgApi.regPush();
```
#### 5.3 代码混淆

```
      -keep public class * extends android.app.Service
      -keep class com.heytap.mcssdk.** {*;}
      -keep class com.heytap.msp.push.** { *;}
```



### 6. FCM通道接入，可参考移动推送 TPNS  [FCM通道接入](https://cloud.tencent.com/document/product/548/36656)

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
      XgFlutterPlugin.xgApi.enableOtherPush();
      XgFlutterPlugin.xgApi.regPush();
```

### 7. 荣耀通道接入，可参考移动推送 TPNS  [荣耀通道接入](https://cloud.tencent.com/document/product/548/74465)
#### 7.1 在 App 模块下的 build.gradle 文件内

```
      android: {
        defaultConfig {
          manifestPlaceholders = [
            ....
            HONOR_APPID  : "xxxx"
            .....
          ]
        }
      }
```

```
      /// 引入 vivo 推送的依赖
      implementation 'com.tencent.tpns:honor:[VERSION]-release'  // 荣耀 推送 [VERSION] 为当前SDK版本号,版本号可在SDK下载页查看
```
#### 7.2 启用 荣耀 推送

```dart
      /// 打开第三方推送
      XgFlutterPlugin.xgApi.enableOtherPush();
      XgFlutterPlugin.xgApi.regPush();
```
#### 7.3代码混淆

```
	-ignorewarnings
	-keepattributes *Annotation*
	-keepattributes Exceptions
	-keepattributes InnerClasses
	-keepattributes Signature
	-keepattributes SourceFile,LineNumberTable


	-keep class com.hihonor.push.framework.aidl.**{*;}
	-keep class com.hihonor.push.sdk.**{*;}

```

## 厂商通道注册失败排查指南
如您的应用接入了厂商通道，但在应用运行日志中观察到如下类似日志： 

```
[OtherPushClient] handleUpdateToken other push token is :  other push type: huawei
```

表示您的应用注册该厂商通道失败。您可以通过获取厂商通道注册失败的返回码来进行问题定位和排查，详情参考 [厂商通道注册失败排查指南](https://cloud.tencent.com/document/product/548/45659)。
