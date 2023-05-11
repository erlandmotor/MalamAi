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
  static const keyTabUpdateTime = 'key_tab_update';

  late Box otherDBBox;
  int curIndex = 0;
  int lastTabIndex = 0;
  late List<int> chatGroupsOrder;
  late Map<int, DateTime> chatTimes;

  ChatGroupNotifier() {
    mgLog('ChatGroupNotifier notifier init.......');
  }

  appDataInit() async {
    Hive.registerAdapter(HiveChatGroupAdapter());
    Hive.registerAdapter(MessageItemAdapter());
    await Hive.openBox(keyOtherDB);
    otherDBBox = Hive.box(keyOtherDB);

    List<int>? chatTabs = otherDBBox.get(keyTabLists);
    if (chatTabs == null || chatTabs.isEmpty) {
      chatGroupsOrder = [
        0,
      ];
      otherDBBox.put(keyTabLists, chatGroupsOrder);
    } else {
      chatGroupsOrder = chatTabs;
    }

    Map<dynamic, dynamic>? chatUpdateTimes = otherDBBox.get(keyTabUpdateTime);
    chatTimes = {};
    if (chatUpdateTimes == null || chatUpdateTimes.isEmpty) {
      //chatTimes = {0: DateTime.now()};
      for (var item in chatGroupsOrder) {
        chatTimes[item] = DateTime.now();
      }

      otherDBBox.put(keyTabUpdateTime, chatTimes);
    } else {
      //chatTimes = chatUpdateTimes;
      chatUpdateTimes.forEach((key, value) {
        chatTimes[key] = value;
      });
    }

    int? lastTabs = otherDBBox.get(keyLatestOpenIndex);
    if (lastTabs == null) {
      lastTabIndex = 0;
      otherDBBox.put(keyLatestOpenIndex, lastTabIndex);
    } else {
      lastTabIndex = lastTabs;
    }
    //await Hive.openBox<HiveChatGroup>(keychatGroupDB);

    for (var element in chatGroupsOrder) {
      await Hive.openBox<MessageItem>(element.toString());
    }
  }

  addTab() async {
    int resultTabKey = 0;
    late bool isFind;
    do {
      isFind = chatGroupsOrder.contains(resultTabKey);
      if (isFind == true) {
        resultTabKey++;
      }
    } while (isFind == true);

    chatGroupsOrder.add(resultTabKey);
    otherDBBox.put(keyTabLists, chatGroupsOrder);
    await Hive.openBox<MessageItem>(resultTabKey.toString());

    Box<MessageItem> myBox = Hive.box(resultTabKey.toString());
    myBox.add(MessageItem('안녕하세요?', false));
    //myBox.close();

    // 열려면
    lastTabIndex = chatGroupsOrder.length - 1;
    otherDBBox.put(keyLatestOpenIndex, lastTabIndex);

    notifyListeners();
  }

  removeTab(int index) {
    if (chatGroupsOrder.length <= 1) {
      mgLog('챗 그룹이 하나이하');
      notifyListeners();
      return;
    }

    var tab = chatGroupsOrder[index];
    chatGroupsOrder.removeAt(index);
    otherDBBox.put(keyTabLists, chatGroupsOrder);

    Box<MessageItem> myBox = Hive.box(tab.toString());
    myBox.deleteFromDisk();

    lastTabIndex = lastTabIndex.clamp(0, chatGroupsOrder.length - 1);
    otherDBBox.put(keyLatestOpenIndex, lastTabIndex);

    notifyListeners();
  }

  swapTab(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }

    final oldval = chatGroupsOrder[oldIndex];
    chatGroupsOrder[oldIndex] = chatGroupsOrder[newIndex];
    chatGroupsOrder[newIndex] = oldval;

    otherDBBox.put(keyTabLists, chatGroupsOrder);
    notifyListeners();
  }

  Box<MessageItem> openLatest() {
    if (lastTabIndex >= chatGroupsOrder.length) {
      lastTabIndex = 0;
    }
    Box<MessageItem> myBox = Hive.box(chatGroupsOrder[lastTabIndex].toString());

    if (myBox.isEmpty) {
      //myBox.put(key, value);
      myBox.add(MessageItem('안녕하세요?', false));
    }

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

    Box<MessageItem> myBox = Hive.box(chatGroupsOrder[index].toString());
    return myBox;
  }

  String getChatTabLebel(int index) {
    lastTabIndex = index;
    otherDBBox.put(keyLatestOpenIndex, lastTabIndex);

    Box<MessageItem> myBox = Hive.box(chatGroupsOrder[index].toString());

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
