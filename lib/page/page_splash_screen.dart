import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_playground/define/global_define.dart';
import 'package:chat_playground/models/firebase_notifier.dart';
import 'package:chat_playground/models/ui_change_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    //Future.microtask(() => _init());
  }

  Future<void> _init() async {
    //오래걸리는 작업 수행

    //WILL
    await Future<void>.delayed(const Duration(seconds: 5));
    //Navigator.pushReplacementNamed(context, routeChatPage);
  }

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

  loginWidget() {
    var firebaseNotifier = context.watch<FirebaseNotifier>();
    if (firebaseNotifier.loggedIn) {
      Future.microtask(
          () => Navigator.pushReplacementNamed(context, routeChatPage));

      return Container();
    }

    if (firebaseNotifier.isLoggingIn) {
      return const Center(
        child: Text('Logging in...'),
      );
    }

    var uiNoti = context.watch<UIChangeNotifier>();
    return SignInButton(
      uiNoti.isLightMode ? Buttons.Google : Buttons.GoogleDark,
      onPressed: () {
        firebaseNotifier.login();
      },
    );
  }

  buildCenterWidgets(BuildContext context) {
    List<Widget> _widgets = [];

    var firebaseNotifier = context.watch<FirebaseNotifier>();
    if (firebaseNotifier.loggedIn) {
      // Future.microtask(
      //     () => Navigator.pushReplacementNamed(context, routeChatPage));
      //return Container();
    }

    if (firebaseNotifier.loggedIn == false) {
      _widgets.add(Image.asset(
        logoImage,
        width: 120,
        height: 120,
      ));

      var uiNoti = context.watch<UIChangeNotifier>();
      _widgets.add(SignInButton(
        uiNoti.isLightMode ? Buttons.Google : Buttons.GoogleDark,
        onPressed: () {
          firebaseNotifier.login();
        },
      ));
    } else {
      String url = firebaseNotifier.user?.photoURL ?? "";
      if (url != "") {
        _widgets.add(CachedNetworkImage(imageUrl: url));
      }
      _widgets.add(ElevatedButton(
          onPressed: () {
            Future.microtask(
                () => Navigator.pushReplacementNamed(context, routeChatPage));
          },
          child: Text("시작")));
      _widgets.add(TextButton(
          onPressed: () {
            firebaseNotifier.logout();
          },
          child: Text("SignOut")));
    }

    return _widgets;
    // if (firebaseNotifier.isLoggingIn) {
    //   return const Center(
    //     child: Text('Logging in...'),
    //   );
    // }
  }
}
