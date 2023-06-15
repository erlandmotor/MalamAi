//import 'package:chat_playground/define/global_define.dart';
import 'package:chat_playground/define/hive_chat_massage.dart';
import 'package:chat_playground/define/mg_handy.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ntp/ntp.dart';

class ChatGroupNotifier with ChangeNotifier {
  static const keyOtherDB = 'other_set';
  //static const keychatGroupDB = 'chat_group';
  static const keyLatestOpenIndex = 'latest_open_index';
  static const keyTabLists = 'key_tab_lists';
  static const keyTabUpdateTime = 'key_tab_update';
  static const keyToday = 'key_today';
  static const keyTodayCount = 'key_today_count';

  late Box otherDBBox;
  int curIndex = 0;
  int lastTabIndex = 0;
  late List<int> chatGroupsOrder;
  late Map<int, DateTime> chatTimes;

  late Box<MessageItem> curChatBox;
  late DateTime chatToday;
  late int chatTodayCount;

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
      var now = await NTP.now();
      for (var item in chatGroupsOrder) {
        chatTimes[item] = now;
      }
      otherDBBox.put(keyTabUpdateTime, chatTimes);
    } else {
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

//
    chatToday = otherDBBox.get(keyToday);
    chatTodayCount = otherDBBox.get(keyTodayCount);
//

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

////
    var now = await NTP.now();
    chatTimes[resultTabKey] = now;
    otherDBBox.put(keyTabUpdateTime, chatTimes);

////
    await Hive.openBox<MessageItem>(resultTabKey.toString());

    Box<MessageItem> myBox = Hive.box(resultTabKey.toString());
    myBox.add(MessageItem('안녕하세요?', false));

    // 열려면
    // lastTabIndex = chatGroupsOrder.length - 1;
    // otherDBBox.put(keyLatestOpenIndex, lastTabIndex);

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

////
    chatTimes.remove(tab);
    otherDBBox.put(keyTabUpdateTime, chatTimes);
////
    Box<MessageItem> myBox = Hive.box(tab.toString());
    myBox.deleteFromDisk();

    lastTabIndex = lastTabIndex.clamp(0, chatGroupsOrder.length - 1);
    openChatBox(lastTabIndex);

    notifyListeners();
  }

  swapTab(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }

    final oldval = chatGroupsOrder[oldIndex];
    chatGroupsOrder[oldIndex] = chatGroupsOrder[newIndex];
    chatGroupsOrder[newIndex] = oldval;

    if (lastTabIndex == oldIndex) {
      lastTabIndex = newIndex;
      otherDBBox.put(keyLatestOpenIndex, lastTabIndex);
    } else {
      if (lastTabIndex == newIndex) {
        lastTabIndex = oldIndex;
        otherDBBox.put(keyLatestOpenIndex, lastTabIndex);
      }
    }

    otherDBBox.put(keyTabLists, chatGroupsOrder);
    notifyListeners();
  }

  setTabIndex(int tabindex) {
    //lastTabIndex = tabindex;

    mgLog('setting tab - $tabindex');
    openChatBox(tabindex);

    notifyListeners();
  }

  Box<MessageItem> openLatest() {
    if (lastTabIndex >= chatGroupsOrder.length) {
      lastTabIndex = 0;
    }
    curChatBox = Hive.box(chatGroupsOrder[lastTabIndex].toString());

    if (curChatBox.isEmpty) {
      //myBox.put(key, value);
      curChatBox.add(MessageItem('안녕하세요?', false));
    }

    return curChatBox;
  }

  Box<MessageItem> openChatBox(int index) {
    lastTabIndex = index;
    otherDBBox.put(keyLatestOpenIndex, lastTabIndex);

    curChatBox = Hive.box(chatGroupsOrder[index].toString());
    return curChatBox;
  }

  String getChatTabLebel(int index) {
    // lastTabIndex = index;
    // otherDBBox.put(keyLatestOpenIndex, lastTabIndex);
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

  Future<int> requestChatAI(String message) async {
    int ret = await curChatBox.add(MessageItem(message, true));
    return ret;
  }
}
