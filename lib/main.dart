import 'dart:io';
//import 'dart:math';

// import 'package:chat_playground/logics/dash_counter.dart';
// import 'package:chat_playground/models/app_data.dart';
//import 'package:chat_playground/models/purchases_notifier.dart';
//import 'package:chat_playground/define/hive_chat_massage.dart';
import 'package:chat_playground/define/ui_setting.dart';
//import 'package:chat_playground/models/app_data_notifier.dart';
import 'package:chat_playground/models/chatgroup_notifier.dart';
import 'package:chat_playground/models/firebase_notifier.dart';
//import 'package:chat_playground/models/iap_repo.dart';
import 'package:chat_playground/models/rc_purchases_notifier.dart';
//import 'package:chat_playground/page/chat_page.dart';
import 'package:chat_playground/api/chat_api.dart';
import 'package:chat_playground/define/global_define.dart';
import 'package:chat_playground/models/ui_change_notifier.dart';
import 'package:chat_playground/page/page_chat.dart';
import 'package:chat_playground/page/page_purchase.dart';
//import 'package:chat_playground/page/page_purchase.dart';
import 'package:chat_playground/page/page_setting.dart';
import 'package:chat_playground/page/page_splash_screen.dart';
import 'package:chat_playground/page/page_chat_tab_list.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hive_flutter/hive_flutter.dart';
//import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:provider/provider.dart';
//import 'package:purchases_flutter/purchases_flutter.dart';

import 'define/mg_handy.dart';
import 'define/rc_store_config.dart';

// Gives the option to override in tests.
// class IAPConnection {
//   static InAppPurchase? _instance;
//   static set instance(InAppPurchase value) {
//     _instance = value;
//   }

//   static InAppPurchase get instance {
//     _instance ??= InAppPurchase.instance;
//     return _instance!;
//   }
// }

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb == false) {
    MobileAds.instance.initialize();
    if (Platform.isAndroid) {
      RCStoreConfig(
        store: RCStore.googlePlay,
        apiKey: googleApiKey,
      );
    } else {
      mgLog(" Platform.isAndroid == false ,  purchase not init");
    }
  }

  await Hive.initFlutter(); // Directory Initialize

  Hive.registerAdapter(UIOptionAdapter());
  await Hive.openBox<UIOption>(uiSettingDB);

  // mgLog : AppDataNotifier notifier init.......
  // mgLog : UIChangeNotifier notifier init.......
  // mgLog : firebase notifier init.......
  // mgLog : RCPurchasesNotifier notifier init.......

  runApp(MultiProvider(
      providers: [
        //ChangeNotifierProvider(create: (_) => AppDataNotifier(), lazy: false),
        ChangeNotifierProvider(create: (_) => UIChangeNotifier()),
        // ChangeNotifierProxyProvider<AppDataNotifier, UIChangeNotifier>(
        //   create: (_) => UIChangeNotifier(),
        //   update: (context, appData, uidata) {
        //     if (uidata == null) throw ArgumentError.notNull('uidata');
        //     //uidata.uiOption =
        //     return uidata;
        //   },
        //   lazy: false,
        // ),
        ChangeNotifierProvider(create: (_) => FirebaseNotifier()),
        // ChangeNotifierProvider<DashCounter>(create: (_) => DashCounter()),
        // ChangeNotifierProvider<IAPRepo>(
        //   create: (context) => IAPRepo(context.read<FirebaseNotifier>()),
        // ),
        // ChangeNotifierProvider<PurchasesNotifier>(
        //   create: (context) => PurchasesNotifier(
        //     context.read<DashCounter>(),
        //     context.read<FirebaseNotifier>(),
        //     context.read<IAPRepo>(),
        //   ),
        //   lazy: false,
        // ),
        ChangeNotifierProvider<RCPurchasesNotifier>(
          create: (context) => RCPurchasesNotifier(
            context.read<FirebaseNotifier>(),
          ),
          lazy: false,
        ),

        ChangeNotifierProvider(
            create: (_) => ChatGroupNotifier()..appDataInit(), lazy: false),
      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Chat Playground root',
          home: ChatApp(chatApi: ChatApi()))));
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
      //debugShowCheckedModeBanner: false,
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
        //routeNamePurchase: (context) => const PurchasePage(),
        routeNamePurchase: (context) => const PagePurchase(),
        //routeChatPage: (context) => PageChatMain(chatApi: widget.chatApi),
        routeChatPage: (context) => PageChat(chatApi: widget.chatApi),
        routeNameChatTab: (context) => const ChatTabList(),
        routeNameOption: (context) => PageSetting(),
      },
    );
  }
}
