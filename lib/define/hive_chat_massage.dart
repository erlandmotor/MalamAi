//import 'package:chat_playground/models/chat_message.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'hive_chat_massage.g.dart';

//flutter packages pub run build_runner build

@HiveType(typeId: 1)
class MessageItem {
  @HiveField(0)
  String content;

  @HiveField(1)
  bool isUserMessage;

  MessageItem(this.content, this.isUserMessage);
}

@HiveType(typeId: 2)
class HiveChatGroup {
  @HiveField(0)
  String groupName;

  @HiveField(1)
  List<MessageItem> contens;

  HiveChatGroup(this.groupName, this.contens);
}

@HiveType(typeId: 3)
class HiveChatTab {
  @HiveField(0)
  String groupName;

  @HiveField(1)
  DateTime updateTime;

  HiveChatTab(this.groupName, this.updateTime);
}
