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
          children: <Widget>[
            Image.asset(
              logoImage,
              width: 120,
              height: 120,
            ),
            const SizedBox(height: 80),
            // const Text('정보 확인중...',
            //     style: TextStyle(
            //       fontSize: 20,
            //       fontWeight: FontWeight.w700,
            //       color: Colors.white,
            //     )),
            //const SizedBox(height: 30),
            // const CircularProgressIndicator(
            //     backgroundColor: Colors.white, strokeWidth: 3),
            const SizedBox(height: 30),
            loginWidget(),
          ],
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

    var uiNoti = context.watch<UIChangeNotifier>();
    if (firebaseNotifier.isLoggingIn) {
      return const Center(
        child: Text('Logging in...'),
      );
    }

    return SignInButton(
      uiNoti.isLightMode ? Buttons.Google : Buttons.GoogleDark,
      onPressed: () {
        firebaseNotifier.login();
      },
    );

    // return Center(
    //     child: ElevatedButton.icon(
    //   onPressed: () {
    //     firebaseNotifier.login();
    //   },
    //   label: const Text('SignIn'),
    //   icon: const Icon(Icons),
    // ));
  }
}
