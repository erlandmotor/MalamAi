import 'package:chat_playground/define/global_define.dart';
import 'package:chat_playground/define/mg_handy.dart';
import 'package:chat_playground/models/rc_purchases_notifier.dart';
import 'package:flutter/material.dart';
import 'package:gradient_borders/gradient_borders.dart';
import 'package:provider/provider.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class Paywall extends StatefulWidget {
  @override
  PaywallState createState() => PaywallState();
}

class PaywallState extends State<Paywall> {
  late Future<List<Package>> packFuture;
  late RCPurchasesNotifier rcPurchaseNotifier;

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
                titleNameMain,
                //style: kTitleTextStyle
              )),
            ),
            const Padding(
              padding:
                  EdgeInsets.only(top: 32, bottom: 16, left: 16.0, right: 16.0),
              child: SizedBox(
                width: double.infinity,
                child: Text(
                  titleNameMain,
                  //style: kDescriptionTextStyle,
                ),
              ),
            ),
            buildPurchaseList(),
            // ListView(
            //   shrinkWrap: true,
            //   physics: const ClampingScrollPhysics(),
            //   children: buildPurchaseWidgets(),
            // ),
            const Padding(
              padding:
                  EdgeInsets.only(top: 32, bottom: 16, left: 16.0, right: 16.0),
              child: SizedBox(
                width: double.infinity,
                child: Text(
                  'footer Text',
                  //style: kDescriptionTextStyle,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  buildPurchaseList() {
    //return LayoutBuilder(builder: builder)

    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          //mainAxisAlignment: MainAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,

          //crossAxisAlignment: CrossAxisAlignment.center,
          // direction: Axis.horizontal,
          // clipBehavior: Clip.antiAliasWithSaveLayer,
          children: buildPurchaseWidgets(),
        ));

    // return Wrap(
    //   alignment: WrapAlignment.center,
    //   // direction: Axis.horizontal,
    //   // clipBehavior: Clip.antiAliasWithSaveLayer,
    //   children: buildPurchaseWidgets(),
    // );
  }

  List<Widget> buildPurchaseWidgets() {
    rcPurchaseNotifier = context.watch<RCPurchasesNotifier>();
    List<Widget> widgets = [];
    List<Package> packs = rcPurchaseNotifier.productList ?? [];

    //widgets.add(Spacer());
    for (Package item in packs) {
      widgets.add(buildPurchaseCard(item));
      //widgets.add(Spacer());
    }

    if (rcPurchaseNotifier.firebaseNotifier.isFreeTrial == true) {
      /*
      widgets.add(Card(
          child: ListTile(
        onTap: () {
          Navigator.pop(context);
        },
        title: const Text(
          'Free trial',
        ),
      )));
      */
    } else {
      mgLog(' free trial end!');
    }

    return widgets;
  }

  Widget buildPurchaseCard(Package item) {
    // final ButtonStyle style = ElevatedButton.styleFrom(
    //     textStyle: const TextStyle(fontSize: 20), elevation: 12);
    TextStyle tStyle = const TextStyle(fontSize: 12);
    final isReq = item.storeProduct.identifier == 'month1';

    return Flexible(
        child: GestureDetector(
            //style: style,
            onTap: () async {
              final myPack = item;
              try {
                rcPurchaseNotifier.purchasePackage(myPack);
              } catch (e) {
                mgLog(' $e');
              }
              //setState(() {});
              Navigator.pop(context);
            },
            child: Stack(alignment: AlignmentDirectional.center, children: [
              // Container(
              //   decoration: isReq
              //       ? BoxDecoration(
              //           border: const GradientBoxBorder(
              //             gradient: LinearGradient(
              //                 colors: [Colors.green, Colors.yellow]),
              //             width: 6,
              //           ),
              //           borderRadius: BorderRadius.circular(16))
              //       : null,
              // ),
              Container(
                decoration: isReq
                    ? const BoxDecoration(
                        border: GradientBoxBorder(
                          gradient: LinearGradient(
                              colors: [Colors.green, Colors.yellow]),
                          width: 6,
                        ),
                        //borderRadius: BorderRadius.circular(15)
                        borderRadius: BorderRadius.all(Radius.circular(20)))
                    : const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(12))),

                //elevation: 12,
                //color: isReq ? Colors.cyan : Colors.orangeAccent,
                child: Container(
                    //color: isReq ? Colors.cyan : Colors.orangeAccent,
                    decoration: BoxDecoration(
                        color: isReq ? Colors.cyan : Colors.orangeAccent,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(12))),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 10.0, left: 6.0, right: 6.0, bottom: 6.0),
                      child: Column(
                        //title: Text('Birth of Universe'),
                        children: <Widget>[
                          Text(item.storeProduct.identifier),
                          Text(item.storeProduct.title,
                              //overflow: TextOverflow.ellipsis,
                              style: tStyle),
                          //const Spacer(),
                          Text(item.storeProduct.priceString),
                        ],
                      ),
                    )),
              )
            ])));
  }
}
