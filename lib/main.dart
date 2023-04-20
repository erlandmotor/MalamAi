import 'dart:io';
//import 'dart:math';

// import 'package:chat_playground/logics/dash_counter.dart';
// import 'package:chat_playground/models/app_data.dart';
//import 'package:chat_playground/models/purchases_notifier.dart';
import 'package:chat_playground/define/ui_setting.dart';
import 'package:chat_playground/models/firebase_notifier.dart';
//import 'package:chat_playground/models/iap_repo.dart';
import 'package:chat_playground/models/rc_purchases_notifier.dart';
import 'package:chat_playground/page/chat_page.dart';
import 'package:chat_playground/api/chat_api.dart';
import 'package:chat_playground/define/global_define.dart';
import 'package:chat_playground/models/ui_change_notifier.dart';
//import 'package:chat_playground/page/page_purchase.dart';
import 'package:chat_playground/page/page_setting.dart';
import 'package:chat_playground/page/page_splash_screen.dart';
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
  MobileAds.instance.initialize();

  await Hive.initFlutter(); // Directory Initialize
  Hive.registerAdapter(UIOptionAdapter());

  await Hive.openBox<UIOption>(uiSettingDB); //Open Box
  // if (Platform.isIOS || Platform.isMacOS) {
  //   RCStoreConfig(
  //     store: Store.appleStore,
  //     apiKey: appleApiKey,
  //   );
  // } else

  if (Platform.isAndroid) {
    RCStoreConfig(
      store: RCStore.googlePlay,
      apiKey: googleApiKey,
    );
  } else {
    mgLog(" Platform.isAndroid == false ,  purchase not init");
  }

  runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UIChangeNotifier()),
        ChangeNotifierProvider<FirebaseNotifier>(
          create: (context) =>
              //FirebaseNotifier(context.read<RCPurchasesNotifier>()),
              FirebaseNotifier(),
        ),
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
            //context.read<DashCounter>(),
            context.read<FirebaseNotifier>(),
          ),
          lazy: false,
        ),
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
        //routeNamePurchase: (context) => const PurchasePage(),
        routeChatPage: (context) => ChatPage(chatApi: widget.chatApi),
        routeNameOption: (context) => const PageSetting(),
      },
    );
  }
}
