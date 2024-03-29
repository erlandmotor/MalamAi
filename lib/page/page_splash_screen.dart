import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_playground/api/chat_api.dart';
import 'package:chat_playground/define/global_define.dart';
import 'package:chat_playground/define/mg_handy.dart';
import 'package:chat_playground/models/firebase_notifier.dart';
import 'package:chat_playground/models/rc_purchases_notifier.dart';
import 'package:chat_playground/models/ui_change_notifier.dart';
import 'package:chat_playground/widgets/paywell.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:provider/provider.dart';

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
      widgets.add(ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Image.asset(
            logoImage,
            width: 120,
            height: 120,
          )));

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
            //child: firebaseNotifier.photoImage));

            child: CachedNetworkImage(
              imageUrl: firebaseNotifier.user!.photoURL!,
              progressIndicatorBuilder: (context, url, downloadProgress) =>
                  CircularProgressIndicator(value: downloadProgress.progress),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            )));
        widgets.add(const SizedBox(height: 20));
      }
      widgets.add(ElevatedButton(
          onPressed: () async {
            final isActive = rcPurchaseNotifier.entitlementIsActive;

            // 기존 버텀업
            // final navigator = Navigator.of(context);
            // if (!isActive) {
            //   await showBuyPage();
            // }
            // navigator.pushReplacementNamed(routeChatPage);

            //Navigator.pop(context);
            Object? ret;
            if (!isActive) {
              final navigator = Navigator.of(context);
              ret = await Navigator.pushNamed(context, routeNamePurchase,
                  arguments: 'skip');
              mgLog('returned purchase widget - $ret');
              if (ret != null) {
                if (ret == ret_purchased) {
                  mgLog('구매해서 이동');
                  ChatApi.SetApiPurchased();
                } else if (ret == ret_share) {
                  mgLog('체험하기로 이동');
                  ChatApi.SetApiShare();
                }
                navigator.pushReplacementNamed(routeChatPage);
              }
            } else {
              Navigator.pushReplacementNamed(context, routeChatPage);
            }
          },
          child: const Text("시작", textScaleFactor: 1.0)));
      widgets.add(TextButton(
        //icon: const Icon(Icons.logout),
        child: const Text("SignOut", textScaleFactor: 1.0),
        onPressed: () {
          rcPurchaseNotifier.logOut();
        },
      ));
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
