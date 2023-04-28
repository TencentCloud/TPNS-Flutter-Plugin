# tpns_flutter_plugin

## 安装
在工程 pubspec.yaml 中加入 dependencies
```
      dependencies:
        tpns_flutter_plugin:
          git:
            url: https://github.com/TencentCloud/TPNS-Flutter-Plugin
            ref: V1.2.3
```


## 使用

- 执行flutter pub get安装好插件后进入iOS文件目录（cd ios）执行：pod install安装依赖库
- 在 xcode8 之后需要点开推送选项： TARGETS -> Capabilities -> Push Notification 设为 on 状态

```dart
      import 'package:tpns_flutter_plugin/tpns_flutter_plugin.dart';
```

      说明(接口使用参考/tpns_flutter_plugin/example/lib/main.dart和/tpns_flutter_plugin/example/lib/ios/homeTest.dart文件)


