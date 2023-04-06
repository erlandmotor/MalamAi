import 'package:chat_playground/define/mg_handy.dart';
import 'package:chat_playground/models/rc_purchases_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
// import 'package:magic_weather_flutter/src/constant.dart';
// import 'package:magic_weather_flutter/src/model/singletons_data.dart';
// import 'package:magic_weather_flutter/src/model/styles.dart';

class Paywall extends StatefulWidget {
  final Offering offering;

  const Paywall({super.key, required this.offering}); // : super(key: key);
  //const Paywall({super.key}) : super(key: key);

  @override
  PaywallState createState() => PaywallState();
}

class PaywallState extends State<Paywall> {
  @override
  Widget build(BuildContext context) {
    var rcPurchaseNotifier = context.watch<RCPurchasesNotifier>();
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
            ListView.builder(
              itemCount: widget.offering.availablePackages.length,
              itemBuilder: (BuildContext context, int index) {
                var myProductList = widget.offering.availablePackages;
                return Card(
                  color: Colors.black,
                  child: ListTile(
                      onTap: () async {
                        try {
                          //rcPurchaseNotifier.isEntitlementActive();
                          rcPurchaseNotifier.purchase(index);
                        } catch (e) {
                          mgLog(' $e');
                        }

                        setState(() {});
                        Navigator.pop(context);
                      },
                      title: Text(
                        myProductList[index].storeProduct.title,
                        //style: kTitleTextStyle,
                      ),
                      subtitle: Text(
                        myProductList[index].storeProduct.description,
                        // style: kDescriptionTextStyle.copyWith(
                        //     fontSize: kFontSizeSuperSmall
                        //     ),
                      ),
                      trailing: Text(
                        myProductList[index].storeProduct.priceString,
                        //style: kTitleTextStyle
                      )),
                );
              },
              shrinkWrap: true,
              physics: const ClampingScrollPhysics(),
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
}
