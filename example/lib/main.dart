import 'package:flutter/material.dart';
import 'dart:async';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'ios/homeTest.dart';
import 'package:tpns_flutter_plugin/tpns_flutter_plugin.dart';

void main() => runApp(new MaterialApp(
      home: new MyApp(),
      debugShowCheckedModeBanner: false,
    ));

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final XgFlutterPlugin tpush = new XgFlutterPlugin();

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    /// 开启DEBUG
    tpush.setEnableDebug(true);

    /// 添加回调事件
    tpush.addEventHandler(
      onRegisteredDeviceToken: (String msg) async {
        print("flutter onRegisteredDeviceToken: $msg");
      },
      onRegisteredDone: (String msg) async {
        print("flutter onRegisteredDone: $msg");
        _showAlert("注册成功");
      },
      unRegistered: (String msg) async {
        print("flutter unRegistered: $msg");
        _showAlert(msg);
      },
      onReceiveNotificationResponse: (Map<String, dynamic> msg) async {
        print("flutter onReceiveNotificationResponse $msg");
      },
      onReceiveMessage: (Map<String, dynamic> msg) async {
        print("flutter onReceiveMessage $msg");
      },
      xgPushDidSetBadge: (String msg) async {
        print("flutter xgPushDidSetBadge: $msg");

        /// 在此可设置应用角标
        /// tpush.setAppBadge(0);
        _showAlert(msg);
      },
      xgPushDidBindWithIdentifier: (String msg) async {
        print("flutter xgPushDidBindWithIdentifier: $msg");
        _showAlert(msg);
      },
      xgPushDidUnbindWithIdentifier: (String msg) async {
        print("flutter xgPushDidUnbindWithIdentifier: $msg");
        _showAlert(msg);
      },
      xgPushDidUpdatedBindedIdentifier: (String msg) async {
        print("flutter xgPushDidUpdatedBindedIdentifier: $msg");
        _showAlert(msg);
      },
      xgPushDidClearAllIdentifiers: (String msg) async {
        print("flutter xgPushDidClearAllIdentifiers: $msg");
        _showAlert(msg);
      },
      xgPushClickAction: (Map<String, dynamic> msg) async {
        print("flutter xgPushClickAction $msg");
        _showAlert("clickResponse");
      },
    );

    /// 如果您的应用非广州集群则需要在startXG之前调用此函数
    /// 香港：tpns.hk.tencent.com
    /// 新加坡：tpns.sgp.tencent.com
    /// 上海：tpns.sh.tencent.com
    // tpush.configureClusterDomainName("tpns.hk.tencent.com");

    /// 启动TPNS服务
    /// 注意：为了不影响回调效果，建议在应用启动方法优先添加回调以及调用TPNS注册方法
    tpush.startXg("1600007893", "IX4BGYYG8L4L");
  }

  void _showAlert(String title) {
    Alert(context: context, title: title, buttons: [
      DialogButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: Text(
          "确认",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
      )
    ]).show();
  }

  @override
  Widget build(BuildContext context) {
    return HomeTest();
  }
}
