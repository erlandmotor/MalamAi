import 'package:chat_playground/chat_page.dart';
import 'package:chat_playground/api/chat_api.dart';
import 'package:chat_playground/define/global_define.dart';
import 'package:chat_playground/models/ui_change_notifier.dart';
import 'package:chat_playground/widgets/page_setting.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
          create: (_) => UIChangeNotifier(isLightMode: true)),
    ],
    child: ChatApp(chatApi: ChatApi()),
  ));
}

class ChatApp extends StatefulWidget {
  const ChatApp({required this.chatApi, super.key});

  final ChatApi chatApi;

  @override
  State<ChatApp> createState() => _ChatAppState();
}

class _ChatAppState extends State<ChatApp> {
  bool isUseSystemSetting = true;
  bool isLightMode = false;
  bool isCupertinoUI = false;
  double customTextScaleFactor = 1.0;

  @override
  void initState() {
    super.initState();

    // try {
    //   if (kIsWeb) {
    //     isWeb = true;
    //   } else {
    //     print('not web');
    //     isWeb = false;
    //   }
    // } catch (e) {
    //   print(e);
    //   isWeb = false;
    // }

    // useLightMode = true;
    // themeData = updateThemes(useLightMode);

    // LoadLightMode().then((value) {
    //   if (useLightMode != value) {
    //     setState(() {
    //       useLightMode = value;
    //       themeData = updateThemes(useLightMode);
    //     });
    //   }
    // });
  }

  @override
  Widget build(BuildContext context) {
    var uiNoti = context.read<UIChangeNotifier>();
    var themeData = uiNoti.materialThemeData;

    return MaterialApp(
      title: 'Chat Playground',
      theme: themeData,
      //home: ChatPage(chatApi: widget.chatApi),
      initialRoute: GlobalDefine.routeNameRoot,
      routes: {
        GlobalDefine.routeNameRoot: (context) =>
            ChatPage(chatApi: widget.chatApi),
        GlobalDefine.routeNameOption: (context) => const PageSetting(),
      },
    );

    /*
    var mediaQuery = MediaQuery.of(context);
    return Theme(
      data: themeData,
      child: PlatformProvider(
        initialPlatform:
            uiNoti.isCupertinoUI ? TargetPlatform.iOS : TargetPlatform.android,
        settings: PlatformSettingsData(
          iosUsesMaterialWidgets: true,
          iosUseZeroPaddingForAppbarPlatformIcon: true,
        ),
        builder: (context) => PlatformApp(
          builder: (context, child) {
            return MediaQuery(
                data: mediaQuery.copyWith(
                    textScaleFactor: uiNoti.customTextScaleFactor),
                child: child!);
          },
          title: 'ChatGPT Client',
          material: (_, __) => MaterialAppData(
            theme: uiNoti.materialThemeData,
          ),
          cupertino: (_, __) => CupertinoAppData(
            theme: uiNoti.cupertinoTheme,
          ),
          initialRoute: GlobalDefine.RouteNameRoot,
          routes: {
            GlobalDefine.RouteNameRoot: (context) =>
                ChatPage(chatApi: widget.chatApi),
            //GlobalDefine.RouteNameOption: (context) => Rootlist(),
          },
        ),
      ),
    );

    */
  }
}
