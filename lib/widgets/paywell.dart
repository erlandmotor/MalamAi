import 'package:chat_playground/define/mg_handy.dart';
import 'package:chat_playground/models/rc_purchases_notifier.dart';
import 'package:chat_playground/models/ui_change_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
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
                      TextSpan(
                          text:
                              '을 구매하면 광고없이 사용하며\n 언제든 취소할수 있습니다.\n또한 앞으로 추가될 기능도 사용가능합니다.'),
                    ],
                  ),
                )),

            Container(
                //alignment: Alignment.centerRight,
                //alignment: FractionalOffset.centerRight,
                padding: const EdgeInsets.fromLTRB(90, 20, 90, 20),
                child: const Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.check_circle_outline_outlined,
                              color: Colors.green),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(child: Text('광고없이 사용. (연간 유저 전용)')),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.check_circle_outline_outlined,
                              color: Colors.green),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(child: Text('주제별로 대화를 나누어 사용.')),
                        ],
                      ),
                      // Row(
                      //   crossAxisAlignment: CrossAxisAlignment.start,
                      //   children: [
                      //     Icon(Icons.check_circle_outline_outlined,
                      //         color: Colors.green),
                      //     SizedBox(
                      //       width: 10,
                      //     ),
                      //     Expanded(child: Text('추가제공되는 기능을 사용가능.')),
                      //   ],
                      // ),
                    ])),

            //),
            const SizedBox(
              height: 100,
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

    // for (Package item in packs) {
    //   widgets.add(buildPurchaseCard(item));
    // }

    widgets =
        List.generate(packs.length, (index) => buildPurchaseCard(packs[index]));

    widgets = widgets
        .animate(interval: 100.ms)
        .move(begin: const Offset(-26, 0), curve: Curves.easeOutQuad)
        .fadeIn(duration: 500.ms, delay: 100.ms)
        .animate(onPlay: (controller) => controller.repeat(), interval: 300.ms)
        .shimmer(
            delay: 1300.ms,
            duration: 500.ms,
            blendMode: BlendMode.srcOver,
            color: Colors.white)
        .then(delay: 3000.ms);

    // color: uiNotifier.isLightMode
    //     ? Colors.indigo[100]
    //     : Colors.deepPurple[800]);

    //.shimmer(blendMode: BlendMode.srcOver, color: Colors.transparent)
    //.move(begin: const Offset(-16, 0), curve: Curves.easeOutQuad);

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
      //return Card(
      //color: uiNotifier.materialThemeData.colorScheme.tertiary,
      //elevation: 19,
      //margin: const EdgeInsets.all(5),
      //style: style,

      onTap: () {
        final myPack = item;
        try {
          Future<bool> future = rcPurchaseNotifier.purchasePackage(myPack);
          future.then((value) {
            mgLog('purchased - result $value,  pckage -  $myPack');
            if (value) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('구매가 완료되었습니다. 감사합니다.'),
                  action: SnackBarAction(
                    label: '확인',
                    onPressed: () {},
                  ),
                ),
              );

              Navigator.pop<String>(context, 'purchased');
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('에러가 발생했습니다. 다시 시도하세요.'),
                  action: SnackBarAction(
                    label: '확인',
                    onPressed: () {},
                  ),
                ),
              );
            }
          });
        } catch (e) {
          mgLog(' $e');
        }
        //Navigator.pop<String>(context, 'purchased');
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
                borderRadius: const BorderRadius.all(Radius.circular(5)))
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
                borderRadius: const BorderRadius.all(Radius.circular(5))),

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

    TextStyle tStyle2 = const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.bold,
      //color: uiNotifier.materialThemeData.colorScheme.secondary
      color: Colors.black87,
    );

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
            textScaleFactor: 1.0,
            textAlign: TextAlign.center,
            style: tStyle,
          )));
      widgets.add(const Spacer());
    }

    widgets.add(Text(uiDesc.title,
        textAlign: TextAlign.center, textScaleFactor: 1.0, style: tStyle2));
    widgets.add(Text(uiDesc.priceString,
        textAlign: TextAlign.center, textScaleFactor: 1.0, style: tStyle2));
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
            textScaleFactor: 1.0,
            textAlign: TextAlign.center,
            style: tStyle.copyWith(color: Colors.white),
          )));

      widgets.add(Text('주당 ₩${weekValue.floor()}',
          textAlign: TextAlign.center,
          textScaleFactor: 1.0,
          style: tStyle.copyWith(color: Colors.black87)));
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
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('체험중에도 언제든 구매가능합니다.'),
                      action: SnackBarAction(
                        label: '확인',
                        onPressed: () {},
                      ),
                    ),
                  );

                  Navigator.pop<String>(context, '체험하기');
                }
              : null,
          child: const Text('지금 체험하기'),
        ));
  }
}
