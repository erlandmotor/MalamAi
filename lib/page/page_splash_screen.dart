import 'package:chat_playground/define/global_define.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() => _init());
  }

  Future<void> _init() async {
    //오래걸리는 작업 수행

    //WILL
    await Future<void>.delayed(const Duration(seconds: 5));

    Navigator.pushReplacementNamed(context, GlobalDefine.routeChatPage);
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
              GlobalDefine.logoImage,
              width: 120,
              height: 120,
            ),
            const SizedBox(height: 80),
            const Text('정보 확인중...',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                )),
            const SizedBox(height: 30),
            const CircularProgressIndicator(
                backgroundColor: Colors.white, strokeWidth: 3)
          ],
        ),
      ),
    );
  }
}
