import 'package:chat_playground/page/chat_page.dart';
import 'package:chat_playground/api/chat_api.dart';
import 'package:chat_playground/define/global_define.dart';
import 'package:chat_playground/models/ui_change_notifier.dart';
import 'package:chat_playground/page/page_setting.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) => UIChangeNotifier(isLightMode: true)),
      ],
      //child: ChatApp(chatApi: ChatApi()),
      child: MaterialApp(
          title: 'Chat Playground root', home: ChatApp(chatApi: ChatApi()))));
}

class ChatApp extends StatefulWidget {
  const ChatApp({required this.chatApi, super.key});

  final ChatApi chatApi;

  @override
  State<ChatApp> createState() => _ChatAppState();
}

class _ChatAppState extends State<ChatApp> {
  @override
  Widget build(BuildContext context) {
    var uiNoti = context.watch<UIChangeNotifier>();

    uiNoti.enumUIOption(context);

    return MaterialApp(
      title: 'Chat Playground',
      theme: uiNoti.materialThemeData,
      builder: (BuildContext context, Widget? childArg) {
        final MediaQueryData data = MediaQuery.of(context);
        return MediaQuery(
          data: data.copyWith(textScaleFactor: uiNoti.customTextScaleFactor),
          child: childArg!,
        );
      },
      initialRoute: GlobalDefine.routeNameRoot,
      routes: {
        GlobalDefine.routeNameRoot: (context) =>
            ChatPage(chatApi: widget.chatApi),
        GlobalDefine.routeNameOption: (context) => const PageSetting(),
      },
    );
  }
}
