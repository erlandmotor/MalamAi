import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_playground/define/global_define.dart';
import 'package:chat_playground/define/mg_handy.dart';
//import 'package:chat_playground/define/mg_handy.dart';
import 'package:chat_playground/models/firebase_notifier.dart';
import 'package:chat_playground/models/rc_purchases_notifier.dart';
import 'package:chat_playground/models/ui_change_notifier.dart';
import 'package:chat_playground/widgets/paywell.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
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

  //   //Future.microtask(() => _init());
  // }

  // Future<void> _init() async {
  //   //오래걸리는 작업 수행
  //   //WILL
  //   await Future<void>.delayed(const Duration(seconds: 5));
  //   //Navigator.pushReplacementNamed(context, routeChatPage);
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: buildCenterWidgets(context),
          //<Widget>[
          // Image.asset(
          //   logoImage,
          //   width: 120,
          //   height: 120,
          // ),
          // const SizedBox(height: 80),
          // const Text('정보 확인중...',
          //     style: TextStyle(
          //       fontSize: 20,
          //       fontWeight: FontWeight.w700,
          //       color: Colors.white,
          //     )),
          //const SizedBox(height: 30),
          // const CircularProgressIndicator(
          //     backgroundColor: Colors.white, strokeWidth: 3),
          // const SizedBox(height: 30),
          // loginWidget(),

          //],
        ),
      ),
    );
  }

  buildCenterWidgets(BuildContext context) {
    List<Widget> widgets = [];

    var firebaseNotifier = context.watch<FirebaseNotifier>();
    var rcPurchaseNotifier = context.watch<RCPurchasesNotifier>();

    if (firebaseNotifier.loggedIn) {
      // Future.microtask(
      //     () => Navigator.pushReplacementNamed(context, routeChatPage));
      //return Container();
    }

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
          rcPurchaseNotifier.logIn();
          //firebaseNotifier.login();
        },
      ));
    } else {
      String url = firebaseNotifier.user?.photoURL ?? "";
      if (url != "") {
        widgets.add(CachedNetworkImage(imageUrl: url));
      }
      widgets.add(ElevatedButton(
          onPressed: () async {
            // Future.microtask(
            //     () => Navigator.pushReplacementNamed(context, routeChatPage));
            //Navigator.pushReplacementNamed(context, routeNamePurchase);

            final navigator = Navigator.of(context);
            //final isActive = await rcPurchaseNotifier.isEntitlementActive();
            final isActive = rcPurchaseNotifier.entitlementIsActive;

            if (isActive) {
              navigator.pushReplacementNamed(routeChatPage);
            } else {
              await showBuyPage();

              navigator.pushReplacementNamed(routeChatPage);
            }
          },
          child: const Text("시작")));
      widgets.add(TextButton(
          onPressed: () {
            //firebaseNotifier.logout();
            rcPurchaseNotifier.logOut();
          },
          child: const Text("SignOut")));
    }

    return widgets;
  }

  // Future<void> showBuyPage() async {
  // await showModalBottomSheet(

  Future<void> showBuyPage() async {
    var result = await showModalBottomSheet(
      useRootNavigator: true,
      isScrollControlled: true,
      isDismissible: false,
      enableDrag: false,
      useSafeArea: true,

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

    mgLog(result);
  }
}
