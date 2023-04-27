import 'dart:io';

import 'package:chat_playground/define/global_define.dart';
import 'package:chat_playground/define/hive_chat_massage.dart';
import 'package:chat_playground/define/mg_handy.dart';
// import 'package:chat_playground/define/rc_store_config.dart';
// import 'package:chat_playground/define/ui_setting.dart';
import 'package:flutter/material.dart';
//import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hive_flutter/hive_flutter.dart';

class AppDataNotifier with ChangeNotifier {
  //late final Box<HiveChatGroup> uiSettingBox;

  static const otherDB = 'other_set';
  static const chatGroupDB = 'chat_group';

  int curIndex = 0;
  List<String> chatGroups = [];

  AppDataNotifier() {
    mgLog('AppDataNotifier notifier init.......');
    //Future.microtask(() => loadUISetting());
    appDataInit();
  }

  appDataInit() async {
    // MobileAds.instance.initialize();

    // await Hive.initFlutter(); // Directory Initialize
    // Hive.registerAdapter(UIOptionAdapter());
    // await Hive.openBox<UIOption>(uiSettingDB);

    Hive.registerAdapter(HiveChatGroupAdapter());
    await Hive.openBox(otherDB);
    await Hive.openBox<HiveChatGroup>(chatGroupDB);

    // uiSettingBox = Hive.box(uiSettingDB);
    // UIOption? option = uiSettingBox.get(uiSetBoxName);

    Box uiSettingBox = Hive.box(otherDB);

    List<String> chatGroups = uiSettingBox.get('chatGroups') ?? [];

    chatGroups.forEach((element) {
      Box<HiveChatGroup> t = Hive.box<HiveChatGroup>(element);
    });
  }

  Future<void> openBox({required int index}) async {
    //assert(curIndex != null);
    //chatGroups[index]
    //curIndex
    Box myBox = await Hive.openBox(chatGroups[index]);
    curIndex = index;
    notifyListeners();
  }
}
