import 'package:chat_playground/define/global_define.dart';
import 'package:chat_playground/define/hive_chat_massage.dart';
import 'package:chat_playground/define/mg_handy.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ChatGroupNotifier with ChangeNotifier {
  //late final Box<HiveChatGroup> uiSettingBox;

  late final Box<HiveChatGroup> uiSettingBox;

  ChatGroupNotifier() {
    mgLog('ChatGroupNotifier notifier init.......');
    loadUISetting();
  }

  loadUISetting() {
    //uiSettingBox = Hive.box(chatGroupDB);

    // HiveChatGroup? option = uiSettingBox.get(uiSetBoxName);
    // if (option == null) {
    //   //uiOption = UIOption(true, false, false, 1.0);
    //   // setDefault().whenComplete(() {
    //   //   mgLog('set degault');
    //   // });
    // } else {
    //   //_uiOption = option;
    // }
  }
}
