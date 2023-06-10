import 'package:chat_playground/define/global_define.dart';
import 'package:chat_playground/define/mg_handy.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class AppDataNotifier with ChangeNotifier {
  static const String boxFieldViewExample = 'boxFieldViewExample';
  bool isViewExample = false;
  late final Box boxAppSetting;
  AppDataNotifier() {
    mgLog('AppDataNotifier notifier init.......');

    loadAppSetting();
  }

  loadAppSetting() {
    boxAppSetting = Hive.box(appSettingDB);
    bool? valueViewExampleField = boxAppSetting.get(boxFieldViewExample);
    if (valueViewExampleField != null) {
      isViewExample = valueViewExampleField;
    }
  }

  set viewExample(bool avalue) {
    //isViewExample = avalue;
    saveAppData(avalue);
    // .then((value) {
    //   isViewExample = avalue;
    // });
  }

  Future<void> saveAppData(bool avalue) async {
    await boxAppSetting.put(boxFieldViewExample, avalue);
    isViewExample = avalue;
    mgLog("isViewExample saved");

    //notifyListeners();
  }
}
