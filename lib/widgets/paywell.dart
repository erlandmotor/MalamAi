import 'package:chat_playground/define/global_define.dart';
import 'package:chat_playground/define/mg_handy.dart';
import 'package:chat_playground/models/rc_purchases_notifier.dart';
import 'package:chat_playground/models/ui_change_notifier.dart';
import 'package:flutter/material.dart';
import 'package:gradient_borders/gradient_borders.dart';
import 'package:provider/provider.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class Paywall extends StatefulWidget {
  const Paywall({super.key});

  @override
  PaywallState createState() => PaywallState();

  //Map map = [{}],
}

class PaywallState extends State<Paywall> {
  late Future<List<Package>> packFuture;
  late RCPurchasesNotifier rcPurchaseNotifier;
  late UIChangeNotifier uiNotifier;

  @override
  Widget build(BuildContext context) {
    uiNotifier = context.read<UIChangeNotifier>();

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
              child: Center(
                  child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 82),
                      decoration: const BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.all(Radius.circular(15))),
                      child: const Text(
                        '이용권 구매',
                        //maxLines: 1,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ))),
            ),
            const SizedBox(height: 50),

            buildPurchaseList(),
            const SizedBox(height: 180),
            // Padding(
            //   padding:
            //       EdgeInsets.only(top: 32, bottom: 16, left: 16.0, right: 16.0),
            //   child:
            SizedBox(
                width: double.infinity,
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    //text: 'Hello ',
                    style: DefaultTextStyle.of(context).style,
                    children: const <TextSpan>[
                      TextSpan(
                          text: '연간',
                          style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold)),
                      TextSpan(text: '을 구매해보세요.\n'),
                      TextSpan(
                          text: '연간',
                          style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold)),
                      TextSpan(text: '을 구매하면 광고없이 사용하며\n 언제든 취소할수 있습니다.'),
                    ],
                  ),
                )),
            //),
            const SizedBox(
              height: 80,
            ),

            buildTrialButton(context),
            const SizedBox(
              height: 50,
            ),
            buildTrialDesc(),
            const SizedBox(
              height: 50,
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
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          //crossAxisAlignment: CrossAxisAlignment.stretch,
          children: buildPurchaseWidgets(),
        ));
  }

  List<Widget> buildPurchaseWidgets() {
    rcPurchaseNotifier = context.watch<RCPurchasesNotifier>();
    List<Widget> widgets = [];
    List<Package> packs = rcPurchaseNotifier.productList;

    //widgets.add(const Spacer());
    for (Package item in packs) {
      widgets.add(buildPurchaseCard(item));
      //widgets.add(Spacer());
    }
    //widgets.add(const Spacer());

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
    //TextStyle tStyle = const TextStyle(fontSize: 12);
    final isReq = item.storeProduct.identifier == 'year1';

    ProductUIDesc productDesc =
        rcPurchaseNotifier.productDescs[item.storeProduct.identifier] ??
            ProductUIDesc();

    return InkWell(
      //style: style,
      onTap: () async {
        final myPack = item;
        try {
          rcPurchaseNotifier.purchasePackage(myPack);
        } catch (e) {
          mgLog(' $e');
        }
        Navigator.pop(context);
      },
      child: Container(
        //color: uiNotifier.materialThemeData.colorScheme.tertiary,
        height: 150,
        width: 110,
        decoration: isReq
            ? BoxDecoration(
                image: const DecorationImage(
                  image: AssetImage('assets/image/purchase_req.jfif'),
                  fit: BoxFit.cover,
                ),
                border: const GradientBoxBorder(
                  gradient: LinearGradient(colors: [
                    //Colors.blueAccent,
                    Colors.blue,
                    Colors.yellowAccent,
                    Colors.greenAccent
                  ], begin: Alignment.bottomLeft, end: Alignment.topRight),
                  width: 7,
                ),
                color: uiNotifier.materialThemeData.colorScheme.secondary
                    .withOpacity(0.4),
                borderRadius: const BorderRadius.all(Radius.circular(12)))
            : BoxDecoration(
                image: const DecorationImage(
                  image: AssetImage('assets/image/purchase.jfif'),
                  fit: BoxFit.cover,
                ),
                border: const GradientBoxBorder(
                  gradient: LinearGradient(
                      colors: [Colors.grey, Colors.blueGrey],
                      //colors: [Colors.blue, Colors.green],
                      begin: Alignment.bottomLeft,
                      end: Alignment.topRight),
                  width: 6,
                ),
                color: uiNotifier.materialThemeData.colorScheme.secondary
                    .withOpacity(0.4),
                borderRadius: const BorderRadius.all(Radius.circular(12))),
        padding: const EdgeInsets.only(
            top: 10.0, left: 5.0, right: 5.0, bottom: 10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          //crossAxisAlignment: CrossAxisAlignment.stretch,
          children: buildPurchaseCardInside(productDesc, isReq),
        ),
      ),
    );
  }

  buildPurchaseCardInside(ProductUIDesc uiDesc, bool isReq) {
    List<Widget> widgets = [];

    TextStyle tStyle = TextStyle(
        fontSize: 10,
        color: uiNotifier.materialThemeData.colorScheme.onSecondary);
    //TextStyle tStyle2 = const TextStyle(fontSize: 10);

    TextStyle tStyle2 = TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: uiNotifier.materialThemeData.colorScheme.secondary);

    if (isReq) {
      widgets.add(Container(
          width: double.infinity,
          decoration: BoxDecoration(
              //color: isReq ? Colors.cyan : Colors.orangeAccent,
              color: uiNotifier.materialThemeData.colorScheme.tertiary,
              //.withOpacity(0.4),
              borderRadius: const BorderRadius.all(Radius.circular(5))),
          child: Text(
            '인기',
            textAlign: TextAlign.center,
            style: tStyle,
          )));
      widgets.add(const Spacer());
    }

    widgets
        .add(Text(uiDesc.title, textAlign: TextAlign.center, style: tStyle2));
    widgets.add(
        Text(uiDesc.priceString, textAlign: TextAlign.center, style: tStyle2));
    // widgets.add(Text('wwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww',
    //     textAlign: TextAlign.center));

    if (isReq) {
      double weekValue = uiDesc.price / 52;

      double weekSubcriptionValue =
          rcPurchaseNotifier.productDescs['subscription1']?.price ?? 1;

      var salePer = (1 - (weekValue / weekSubcriptionValue)) * 100;
      widgets.add(const Spacer());
      widgets.add(Container(
          //padding: const EdgeInsets.symmetric(horizontal: 12),
          width: double.infinity,
          decoration: const BoxDecoration(
              //color: isReq ? Colors.cyan : Colors.orangeAccent,
              color: Colors.green,
              borderRadius: BorderRadius.all(Radius.circular(5))),
          child: Text(
            '할인혜택: ${salePer.floor()}%',
            //maxLines: 1,
            textAlign: TextAlign.center,
            style: tStyle.copyWith(color: Colors.white),
          )));

      widgets.add(Text('주당 ₩${weekValue.floor()}',
          textAlign: TextAlign.center, style: tStyle));
    }

    return widgets;
  }

  Widget buildTrialDesc() {
    final isFreeTrial = rcPurchaseNotifier.firebaseNotifier.isFreeTrial;
    return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Text(
          isFreeTrial ? '3일간 무료체험할수 있습니다.' : '무료체험기간이 끝났습니다.',
          textAlign: TextAlign.center,
        ));
  }

  Widget buildTrialButton(BuildContext context) {
    final isFreeTrial = rcPurchaseNotifier.firebaseNotifier.isFreeTrial;

    return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: FilledButton(
          onPressed: isFreeTrial
              ? () {
                  Navigator.pop<String>(context);
                }
              : null,
          child: const Text('지금 체험하기'),
        ));
  }
}
