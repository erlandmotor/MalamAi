import 'package:chat_playground/logics/dash_counter.dart';
import 'package:chat_playground/logics/dash_purchases.dart';
import 'package:chat_playground/models/firebase_notifier.dart';
import 'package:chat_playground/models/iap_repo.dart';
import 'package:chat_playground/page/chat_page.dart';
import 'package:chat_playground/api/chat_api.dart';
import 'package:chat_playground/define/global_define.dart';
import 'package:chat_playground/models/ui_change_notifier.dart';
import 'package:chat_playground/page/page_purchase.dart';
import 'package:chat_playground/page/page_setting.dart';
import 'package:chat_playground/page/page_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:provider/provider.dart';

// Gives the option to override in tests.
class IAPConnection {
  static InAppPurchase? _instance;
  static set instance(InAppPurchase value) {
    _instance = value;
  }

  static InAppPurchase get instance {
    _instance ??= InAppPurchase.instance;
    return _instance!;
  }
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) => UIChangeNotifier(isLightMode: true)),
        ChangeNotifierProvider<FirebaseNotifier>(
            create: (_) => FirebaseNotifier()),
        ChangeNotifierProvider<DashCounter>(create: (_) => DashCounter()),
        ChangeNotifierProvider<IAPRepo>(
          create: (context) => IAPRepo(context.read<FirebaseNotifier>()),
        ),
        // ChangeNotifierProvider<DashPurchases>(
        //   create: (context) => DashPurchases(
        //     context.read<DashCounter>(),
        //     context.read<FirebaseNotifier>(),
        //     context.read<IAPRepo>(),
        //   ),
        //   lazy: false,
        // ),
      ],
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
      initialRoute: routeNameRoot,
      routes: {
        routeNameRoot: (context) => const SplashScreen(),
        routeNamePurchase: (context) => const PurchasePage(),
        routeChatPage: (context) => ChatPage(chatApi: widget.chatApi),
        routeNameOption: (context) => const PageSetting(),
      },
    );
  }
}
