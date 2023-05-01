//import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_playground/define/global_define.dart';
import 'package:chat_playground/define/hive_chat_massage.dart';
import 'package:chat_playground/define/ui_setting.dart';
//import 'package:chat_playground/define/mg_handy.dart';
//import 'package:chat_playground/define/mg_handy.dart';
import 'package:chat_playground/models/firebase_notifier.dart';
import 'package:chat_playground/models/rc_purchases_notifier.dart';
import 'package:chat_playground/models/ui_change_notifier.dart';
import 'package:chat_playground/widgets/paywell.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
//import 'package:purchases_flutter/models/offering_wrapper.dart';
//import 'package:purchases_flutter/models/offerings_wrapper.dart';
//import 'package:purchases_flutter/purchases_flutter.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  // @override
  // void initState() {
  //   super.initState();

  //   Future.microtask(() => _init());
  // }

  // Future<void> _init() async {
  //   //오래걸리는 작업 수행
  //   //WILL
  //   //await Future<void>.delayed(const Duration(seconds: 5));
  //   //Navigator.pushReplacementNamed(context, routeChatPage);

  //   MobileAds.instance.initialize();

  //   await Hive.initFlutter(); // Directory Initialize
  //   Hive.registerAdapter(UIOptionAdapter());
  //   Hive.registerAdapter(HiveChatGroupAdapter());

  //   await Hive.openBox(otherDB);
  //   await Hive.openBox<HiveChatGroup>(chatGroupDB);
  //   await Hive.openBox<UIOption>(uiSettingDB);
  // }

  @override
  Widget build(BuildContext context) {
    final uiNoti = context.read<UIChangeNotifier>();
    return Scaffold(
      backgroundColor: uiNoti.materialThemeData.colorScheme.primaryContainer,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: buildCenterWidgets(context),
        ),
      ),
    );
  }

  buildCenterWidgets(BuildContext context) {
    List<Widget> widgets = [];

    var firebaseNotifier = context.watch<FirebaseNotifier>();
    var rcPurchaseNotifier = context.watch<RCPurchasesNotifier>();

    // if (firebaseNotifier.loggedIn) {
    //   // Future.microtask(
    //   //     () => Navigator.pushReplacementNamed(context, routeChatPage));
    //   //return Container();
    // }

    if (firebaseNotifier.loggedIn == false) {
      widgets.add(Image.asset(
        logoImage,
        width: 120,
        height: 120,
      ));

      var uiNoti = context.watch<UIChangeNotifier>();
      widgets.add(SignInButton(
        uiNoti.isLightMode ? Buttons.Google : Buttons.GoogleDark,
        onPressed: () {
          if (kIsWeb == false) {
            rcPurchaseNotifier.logIn();
          } else {
            final navigator = Navigator.of(context);
            navigator.pushReplacementNamed(routeChatPage);
          }
        },
      ));
    } else {
      String url = firebaseNotifier.user?.photoURL ?? "";
      if (url != "") {
        widgets.add(ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: firebaseNotifier.photoImage));
        widgets.add(const SizedBox(height: 20));
      }
      widgets.add(ElevatedButton(
          onPressed: () async {
            final isActive = rcPurchaseNotifier.entitlementIsActive;
            final navigator = Navigator.of(context);
            if (!isActive) {
              await showBuyPage();
            }
            navigator.pushReplacementNamed(routeChatPage);
          },
          child: const Text("시작", textScaleFactor: 1.0)));
      widgets.add(TextButton(
          onPressed: () {
            rcPurchaseNotifier.logOut();
          },
          child: const Text("SignOut", textScaleFactor: 1.0)));
    }

    return widgets;
  }

  Future<void> showBuyPage() async {
    var uiNoti = context.read<UIChangeNotifier>();

    await showModalBottomSheet(
      useRootNavigator: true,
      isScrollControlled: true,
      isDismissible: false,
      enableDrag: false,
      useSafeArea: true,
      backgroundColor: uiNoti.materialThemeData.colorScheme.tertiaryContainer,

      //backgroundColor: kColorBackground,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setModalState) {
          return const Paywall();
        });
      },
    );
  }
}
