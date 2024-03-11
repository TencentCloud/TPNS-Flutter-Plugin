import 'package:flutter/material.dart';
import 'flutter_tableview.dart';
import 'package:tpns_flutter_plugin/tpns_flutter_plugin.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

List<String> sectionTitleList = ['关于账号接口', '关于标签接口', '关于用户属性接口', '关于应用接口'];
List<List<String>> sectionList = [
  ['设置账号', '解绑账号', '清除全部账号'],
  ['绑定一个标签', '解绑一个标签', '更新标签', '清除全部标签'],
  ['新增用户属性', '删除用户属性', '更新用户属性', '清除全部用户属性'],
  ['注册推送服务', '注销推送服务', '设备推送标识', '上报当前角标数', 'SDK 版本']
];

class HomeTest extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TPNS Demo'),
      ),
      body: HomeTestBody(),
    );
  }
}

class HomeTestBody extends StatefulWidget {
  @override
  HomeTestBodyState createState() => HomeTestBodyState();
}

class HomeTestBodyState extends State<HomeTestBody> {
  final XgFlutterPlugin tpush = new XgFlutterPlugin();
  String inputStr = "flutter";

  // Get row count.
  int _rowCountAtSection(int section) {
    if (section < sectionList.length) {
      return sectionList[section].length;
    } else {
      return 0;
    }
  }

  String _titleOfSection(int section) {
    if (section < sectionTitleList.length) {
      return sectionTitleList[section];
    } else {
      return 'null';
    }
  }

  String _titleOfRow(int section, int row) {
    if (section < sectionList.length) {
      List<String> tmpList = sectionList[section];
      if (row < tmpList.length) {
        return tmpList[row];
      } else {
        return 'null';
      }
    } else {
      return 'null';
    }
  }

  void _showAlert(int section, int row) {
    String title = sectionList[section][row];
    Alert(
        context: context,
        title: title,
        content: Column(
          children: <Widget>[
            TextField(
              decoration: InputDecoration(
                labelText: '请输入',
              ),
              onChanged: (text) {
                inputStr = text;
              },
            ),
          ],
        ),
        buttons: [
          DialogButton(
            onPressed: () {
              Navigator.pop(context);
              _doAction(section, row);
            },
            child: Text(
              "确认",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          )
        ]).show();
  }

  //信鸽api接口调用函数
  void _doAction(int section, int row) {
    if (section == 0) {
      if (row == 0) {
        tpush.setAccount(inputStr, AccountType.UNKNOWN);
      } else if (row == 1) {
        tpush.deleteAccount(inputStr, AccountType.UNKNOWN);
      } else if (row == 2) {
        tpush.cleanAccounts();
      }
    } else if (section == 1) {
      if (row == 0) {
        tpush.addTags([inputStr]);
      } else if (row == 1) {
        tpush.deleteTags([inputStr]);
      } else if (row == 2) {
        tpush.setTags([inputStr]);
      } else if (row == 3) {
        tpush.cleanTags();
      }
    } else if (section == 2) {
      if (row == 0) {
        Map<String, String> attributes = {'nickname': "testAttribute"};
        tpush.upsertAttributes(attributes);
      } else if (row == 1) {
        List<String> delAttr = ['nickname'];
        tpush.delAttributes(delAttr);
      } else if (row == 2) {
        Map<String, String> attributes = {'nickname': "testAttribute2"};
        tpush.clearAndAppendAttributes(attributes);
      } else if (row == 3) {
        tpush.clearAttributes();
      }
    } else if (section == 3) {
      if (row == 0) {
        tpush.startXg("1600007893", "IX4BGYYG8L4L");
      } else if (row == 1) {
        tpush.stopXg();
      } else if (row == 2) {
        getXgToken();
      } else if (row == 3) {
        tpush.setBadge(int.parse(inputStr));
      } else if (row == 4) {
        getXgSdkVersion();
      }
    }
  }

  // Section header widget builder.
  Widget _sectionHeaderBuilder(BuildContext context, int section) {
    return InkWell(
      onTap: () {},
      child: Container(
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.only(left: 16.0),
        color: Color.fromRGBO(220, 220, 220, 1),
        height: 100,
        child: Text(_titleOfSection(section)),
      ),
    );
  }

  // cell item widget builder.
  Widget _cellBuilder(BuildContext context, int section, int row) {
    return InkWell(
      onTap: () {
        if ((section == 0 && row == 2) ||
            (section == 1 && row == 3) ||
            (section == 2) ||
            (section == 3 && row != 3)) {
          _doAction(section, row);
        } else {
          _showAlert(section, row);
        }
      },
      child: Container(
        padding: EdgeInsets.only(left: 16.0),
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(
          color: Color.fromRGBO(240, 240, 240, 1),
        ))),
        height: 50.0,
        child: Text(_titleOfRow(section, row)),
      ),
    );
  }

  // Each section header height;
  double _sectionHeaderHeight(BuildContext context, int section) {
    return 50.0;
  }

  // Each cell item widget height.
  double _cellHeight(BuildContext context, int section, int row) {
    return 50.0;
  }

  Future<void> getXgSdkVersion() async {
    try {
      String? sdkVersion = await XgFlutterPlugin.xgSdkVersion;
      print('xgSdkVersion: $sdkVersion');
      Alert(context: context, title: sdkVersion, desc: "", buttons: [
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
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> getXgToken() async {
    try {
      String? xgToken = await XgFlutterPlugin.xgToken;
      print('xgtoken: $xgToken');
      Alert(context: context, title: xgToken, desc: "", buttons: [
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
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      //FlutterTableView
      child: FlutterTableView(
        sectionCount: sectionList.length,
        rowCountAtSection: _rowCountAtSection,
        sectionHeaderBuilder: _sectionHeaderBuilder,
        cellBuilder: _cellBuilder,
        sectionHeaderHeight: _sectionHeaderHeight,
        cellHeight: _cellHeight,
      ),
    );
  }
}
