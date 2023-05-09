//import 'package:chat_playground/define/global_define.dart';
import 'package:chat_playground/define/hive_chat_massage.dart';
import 'package:chat_playground/define/mg_handy.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ChatGroupNotifier with ChangeNotifier {
  static const keyOtherDB = 'other_set';
  //static const keychatGroupDB = 'chat_group';
  static const keyLatestOpenIndex = 'latest_open_index';
  static const keyTabLists = 'key_tab_lists';

  late Box otherDBBox;
  int curIndex = 0;
  int lastTabIndex = 0;
  late List<int> chatGroups;

  ChatGroupNotifier() {
    mgLog('ChatGroupNotifier notifier init.......');
  }

  appDataInit() async {
    Hive.registerAdapter(HiveChatGroupAdapter());
    Hive.registerAdapter(MessageItemAdapter());
    await Hive.openBox(keyOtherDB);
    otherDBBox = Hive.box(keyOtherDB);

    List<int>? chatTabs = otherDBBox.get(keyTabLists);
    if (chatTabs == null) {
      chatGroups = [
        0,
      ];
      otherDBBox.put(keyTabLists, chatGroups);
    } else {
      chatGroups = chatTabs;
    }

    int? lastTabs = otherDBBox.get(keyLatestOpenIndex);
    if (lastTabs == null) {
      lastTabIndex = 0;
      otherDBBox.put(keyLatestOpenIndex, lastTabIndex);
    } else {
      lastTabIndex = lastTabs;
    }
    //await Hive.openBox<HiveChatGroup>(keychatGroupDB);

    for (var element in chatGroups) {
      await Hive.openBox<MessageItem>(element.toString());
    }
  }

  addTab() async {
    int resultTabKey = 0;
    late bool isFind;
    do {
      isFind = chatGroups.contains(resultTabKey);
      if (isFind == true) {
        resultTabKey++;
      }
    } while (isFind == false);

    chatGroups.add(resultTabKey);
    await Hive.openBox<MessageItem>(resultTabKey.toString());

    Box<MessageItem> myBox = Hive.box(resultTabKey.toString());
    myBox.add(MessageItem('안녕하세요?', false));
    //myBox.close();

    // 열려면
    lastTabIndex = chatGroups.length - 1;
    otherDBBox.put(keyLatestOpenIndex, lastTabIndex);

    notifyListeners();
  }

  removeTab(int index) {
    var tab = chatGroups[index];
    chatGroups.removeAt(index);
    otherDBBox.put(keyTabLists, chatGroups);

    Box<MessageItem> myBox = Hive.box(tab.toString());
    myBox.deleteFromDisk();

    lastTabIndex = lastTabIndex.clamp(0, chatGroups.length - 1);
    otherDBBox.put(keyLatestOpenIndex, lastTabIndex);

    notifyListeners();
  }

  swapTab(int oldIndex, int newIndex) {
    final oldval = chatGroups[oldIndex];
    chatGroups[oldIndex] = chatGroups[newIndex];
    chatGroups[newIndex] = oldval;

    //notifyListeners();
  }

  Box<MessageItem> openLatest() {
    if (lastTabIndex >= chatGroups.length) {
      lastTabIndex = 0;
    }
    Box<MessageItem> myBox = Hive.box(chatGroups[lastTabIndex].toString());

    // try{
    //    myBox = Hive.box(chatGroups[lastTabIndex].toString());
    // }
    // catch{

    // }

    return myBox;
  }

  Box<MessageItem> openChatBox(int index) {
    lastTabIndex = index;
    otherDBBox.put(keyLatestOpenIndex, lastTabIndex);

    Box<MessageItem> myBox = Hive.box(chatGroups[index].toString());
    return myBox;
  }

  String getChatTabLebel(int index) {
    lastTabIndex = index;
    otherDBBox.put(keyLatestOpenIndex, lastTabIndex);

    Box<MessageItem> myBox = Hive.box(chatGroups[index].toString());

    if (myBox.values.length <= 1) {
      return '새 탭';
    }

    try {
      return myBox.values.toList()[1].content;
    } catch (e) {
      return '새 탭';
    }
  }
}
