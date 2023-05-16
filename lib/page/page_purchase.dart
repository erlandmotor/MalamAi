import 'package:chat_playground/widgets/paywell.dart';
import 'package:flutter/material.dart';

class PagePurchase extends StatelessWidget {
  const PagePurchase({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text(
        '구매',
        textScaleFactor: 1.0,
      )),
      body: const Paywall(),
    );
  }
}
