//import 'package:chat_playground/define/global_define.dart';
import 'package:chat_playground/define/hive_chat_massage.dart';
import 'package:chat_playground/define/mg_handy.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ChatGroupNotifier with ChangeNotifier {
  static const otherDB = 'other_set';
  static const chatGroupDB = 'chat_group';

  int curIndex = 0;
  int lastTabIndex = 0;
  late List<String> chatGroups;

  ChatGroupNotifier() {
    mgLog('ChatGroupNotifier notifier init.......');
    appDataInit();
  }

  appDataInit() async {
    Hive.registerAdapter(HiveChatGroupAdapter());
    Hive.registerAdapter(MessageItemAdapter());
    await Hive.openBox(otherDB);
    var otherDBBox = Hive.box(otherDB);

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

    for (String element in chatGroups) {
      await Hive.openBox<MessageItem>(element);
    }
  }

  Box<MessageItem> openChatBox({required int index}) {
    Box<MessageItem> myBox = Hive.box(chatGroups[index]);

    return myBox;
  }
}
