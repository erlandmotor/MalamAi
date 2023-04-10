import 'package:chat_playground/define/mg_handy.dart';
import 'package:chat_playground/models/rc_purchases_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
// import 'package:magic_weather_flutter/src/constant.dart';
// import 'package:magic_weather_flutter/src/model/singletons_data.dart';
// import 'package:magic_weather_flutter/src/model/styles.dart';

class Paywall extends StatefulWidget {
  @override
  PaywallState createState() => PaywallState();
}

class PaywallState extends State<Paywall> {
  late Future<List<Package>> packFuture;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SafeArea(
        child: Wrap(
          children: <Widget>[
            Container(
              height: 70.0,
              width: double.infinity,
              decoration: const BoxDecoration(
                  //color: kColorBar,
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(25.0))),
              child: const Center(
                  child: Text(
                '✨ Magic Weather Premium',
                //style: kTitleTextStyle
              )),
            ),
            const Padding(
              padding:
                  EdgeInsets.only(top: 32, bottom: 16, left: 16.0, right: 16.0),
              child: SizedBox(
                width: double.infinity,
                child: Text(
                  'MAGIC WEATHER PREMIUM',
                  //style: kDescriptionTextStyle,
                ),
              ),
            ),
            ListView(
              shrinkWrap: true,
              physics: const ClampingScrollPhysics(),
              children: buildPurchaseWidgets(),
            ),
            const Padding(
              padding:
                  EdgeInsets.only(top: 32, bottom: 16, left: 16.0, right: 16.0),
              child: SizedBox(
                width: double.infinity,
                child: Text(
                  'footerText',
                  //style: kDescriptionTextStyle,
                ),
              ),
            ),
            const Padding(
              padding:
                  EdgeInsets.only(top: 32, bottom: 16, left: 16.0, right: 16.0),
              child: SizedBox(
                width: double.infinity,
                child: Text(
                  'footerText',
                  //style: kDescriptionTextStyle,
                ),
              ),
            ),
            const Padding(
              padding:
                  EdgeInsets.only(top: 32, bottom: 16, left: 16.0, right: 16.0),
              child: SizedBox(
                width: double.infinity,
                child: Text(
                  'footerText',
                  //style: kDescriptionTextStyle,
                ),
              ),
            ),
            const Padding(
              padding:
                  EdgeInsets.only(top: 32, bottom: 16, left: 16.0, right: 16.0),
              child: SizedBox(
                width: double.infinity,
                child: Text(
                  'footerText',
                  //style: kDescriptionTextStyle,
                ),
              ),
            ),
            const Padding(
              padding:
                  EdgeInsets.only(top: 32, bottom: 16, left: 16.0, right: 16.0),
              child: SizedBox(
                width: double.infinity,
                child: Text(
                  'footerText',
                  //style: kDescriptionTextStyle,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> buildPurchaseWidgets() {
    var rcPurchaseNotifier = context.watch<RCPurchasesNotifier>();
    List<Widget> widgets = [];
    List<Package> packs = rcPurchaseNotifier.productList ?? [];

    for (Package item in packs) {
      widgets.add(Card(
        //color: Colors.black,
        child: ListTile(
            onTap: () async {
              final myPack = item;
              try {
                rcPurchaseNotifier.purchasePackage(myPack);
              } catch (e) {
                mgLog(' $e');
              }

              setState(() {});
              Navigator.pop(context);
            },
            title: Text(
              item.storeProduct.title,
            ),
            subtitle: Text(
              item.storeProduct.description,
            ),
            trailing: Text(
              item.storeProduct.priceString,
            )),
      ));
    }

    if (rcPurchaseNotifier.firebaseNotifier.isFreeTrial == true) {
      widgets.add(Card(
          //color: Colors.black,
          child: ListTile(
        onTap: () {
          Navigator.pop(context);
        },
        title: const Text(
          'Free trial',
        ),
      )));
    } else {
      mgLog(' free trial end!');
    }

    return widgets;
  }
}
