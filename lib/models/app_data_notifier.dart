import 'dart:io';

//import 'package:chat_playground/define/global_define.dart';
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
  int lastTabIndex = 0;
  late List<String> chatGroups;
  late List<Box<HiveChatGroup>> chatGroupBoxs;

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
    Hive.registerAdapter(MessageItemAdapter());
    await Hive.openBox(otherDB);

    // uiSettingBox = Hive.box(uiSettingDB);
    // UIOption? option = uiSettingBox.get(uiSetBoxName);

    var otherDBBox = Hive.box(otherDB);
    //chatGroups = uiSettingBox.get(uiSettingDB) ?? ['DEFAULT',];

    var chatTabs = otherDBBox.get('chatTabs');
    if (chatTabs == null) {
      chatGroups = [
        'DEF_TAB',
      ];
      otherDBBox.put('chatTabs', chatGroups);
    } else {
      chatGroups = chatTabs;
    }

    var lastTabs = otherDBBox.get('lastTab');
    if (lastTabs == null) {
      lastTabIndex = 0;
      otherDBBox.put('lastTab', lastTabIndex);
    } else {
      lastTabIndex = lastTabs;
    }

    await Hive.openBox<HiveChatGroup>(chatGroupDB);
    chatGroupBoxs = [];
    chatGroups.forEach((element) async {
      // await Hive.openBox<HiveChatGroup>(element);
      // var groupBox = Hive.box<HiveChatGroup>(element);
      // chatGroupBoxs.add(groupBox);
    });

    await openBox(index: 0);
  }

  Future<void> openBox({required int index}) async {
    //assert(curIndex != null);
    //chatGroups[index]
    //curIndex
    late Box myBox;

    // bool exist = Hive.isBoxOpen(chatGroups[index]);
    // var exist2 = await Hive.boxExists(chatGroups[index]);

    if (Hive.isBoxOpen(chatGroups[index]) == false) {
      await Hive.openBox(chatGroups[index]);
    }
    myBox = Hive.box(chatGroups[index]);

    // myBox = Hive.box(chatGroups[index]);
    // myBox ??= await Hive.openBox(chatGroups[index]);

    //notifyListeners();
  }
}
