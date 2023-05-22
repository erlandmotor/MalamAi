import 'package:chat_playground/define/mg_handy.dart';
import 'package:chat_playground/models/rc_purchases_notifier.dart';
import 'package:chat_playground/models/ui_change_notifier.dart';
import 'package:chat_playground/widgets/paywell.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PagePurchase extends StatelessWidget {
  const PagePurchase({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments;
    mgLog('args - $args');

    final uiNotifier = context.read<UIChangeNotifier>();
    //final purchaseNotifier = context.read<RCPurchasesNotifier>();
    return Scaffold(
        backgroundColor: uiNotifier.isLightMode
            ? Colors.indigo[100]
            : Colors.deepPurple[800],
        appBar: AppBar(
          //automaticallyImplyLeading: false,
          title: const Text(
            '구매',
            textScaleFactor: 1.0,
          ),
          backgroundColor: uiNotifier.isLightMode
              ? Colors.indigo[100]
              : Colors.deepPurple[800],
        ),
        body: Selector<RCPurchasesNotifier, bool>(
            selector: (_, provider) => provider.entitlementIsActive,
            builder: (context, isActive, child) {
              if (isActive) {
                return buildActiveUser(context);
              } else {
                return const Paywall();
              }
            }));
  }

  Widget buildActiveUser(BuildContext context) {
    List<Widget> elements = [];

    elements.add(
      const Padding(
        padding: EdgeInsets.only(left: 16, top: 32, right: 16, bottom: 16),
        child: Icon(
          Icons.check_circle,
          size: 48,
          //color: Theme.of(context).iconTheme.color,
          color: Colors.green,
        ),
      ),
    );

    elements.add(
      Center(
        child: Padding(
          padding:
              const EdgeInsets.only(left: 16, top: 0, right: 16, bottom: 0),
          child: Text(
            '활성 상태 입니다.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      ),
    );

    elements.add(
      Center(
        child: Padding(
          padding:
              const EdgeInsets.only(left: 16, top: 8, right: 16, bottom: 8),
          child: Text(
            '구매해 주셔서 감사합니다.',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ),
      ),
    );

    elements.add(
      Container(
          padding: const EdgeInsets.only(top: 8, bottom: 8),
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            TextButton(
              child: const Text("확인"),
              onPressed: () {
                //print("let‘s go to the home widget again");
                Navigator.pop<String>(context, 'purchased');
              },
            )
          ])),
    );

    return ListView(
      primary: false,
      shrinkWrap: true,
      physics: const ClampingScrollPhysics(),
      children: elements,
    );
  }
}
