import 'package:chat_playground/models/app_data_notifier.dart';
import 'package:chat_playground/models/ui_change_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:chat_playground/define/mg_handy.dart';

class PageExample extends StatelessWidget {
  const PageExample({Key? key}) : super(key: key);

// 예시 파이널
// 중년 뱃살을 빼려면 어떻게 해야해?
// 스타트업의 개발팀장처럼 면접 질문을 생성해줘.
// 사이버펑크에 대해서 설명해줄래?
// C++로 HTTP를 구현하는 예제를 보여줄래?

// 주의 사항
// 때때로 부정확한 정보를 생성할 수 있습니다.
// 때때로 유해한 지침이나 편향된 콘텐츠를 생성할 수 있습니다.
// 위사항은 제작사의 입장을 대변하지 않습니다.

  static const List<List<String>> descs = [
    [
      'C++로 HTTP를 구현하는 예제를 보여줄래?',
      '사이버펑크에 대해서 설명해줄래?',
      'A* 알고리즘을 사용하여 기본 AI 게임 에이전트를 생성하는 C# 코드를 생성해줄래?',
      '중년 뱃살을 빼려면 어떻게 해야해?',
    ],
    [
      '때때로 부정확한 정보를 생성할 수 있습니다.',
      '때때로 유해한 지침이나 편향된 콘텐츠를 생성할 수 있습니다.',
      'AI답변은 제작사의 입장을 대변하지 않습니다.',
    ],
  ];

  //late UIChangeNotifier uiNoti;

  @override
  Widget build(BuildContext context) {
    var uiNoti = context.read<UIChangeNotifier>();

    return Dialog.fullscreen(
      child: Scaffold(
        //drawer: const MGSideDrawer(),
        backgroundColor: uiNoti.isLightMode
            ? const Color.fromARGB(255, 208, 211, 231)
            : Colors.deepPurple[800],

        appBar: AppBar(
          backgroundColor: uiNoti.isLightMode
              ? const Color.fromARGB(255, 208, 211, 231)
              : Colors.deepPurple[800],
          title: const Text(
            '사용법과 예시',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          centerTitle: false,
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: ListView(children: [
          buildWarn(context),
          buildExample(context),
          buildReplay(context),
          TextButton.icon(
              //icon: const Icon(Icons.arrow_back_ios_new),
              icon: const Icon(Icons.first_page),
              onPressed: () => Navigator.of(context).pop(),
              label: const Text('확인')),
        ]),
      ),
      //),
    );
  }

  Widget buildWarn(BuildContext context) {
    var uiNoti = context.read<UIChangeNotifier>();

    Widget warnCard = Card(
        color: uiNoti.materialThemeData.colorScheme.tertiaryContainer,
        elevation: 8,
        margin: const EdgeInsets.symmetric(horizontal: 20), // .all(20),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            ...List.generate(descs[1].length, (index) {
              return Padding(
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                  child: Row(
                    //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                          width: 5,
                          height: 5,
                          child: Icon(Icons.warning_amber_rounded,
                              color:
                                  uiNoti.materialThemeData.colorScheme.error)),
                      const SizedBox(width: 30),
                      Expanded(child: Text(descs[1][index]))
                    ],
                  ));
            }),
          ]),
        ));

    //warnCard = warnCard
    //.animate() // this wraps the previous Animate in another Animate
    // .slide(
    //     begin: const Offset(-5, 0),
    //     duration: 1800.ms,
    //     curve: Curves.easeOutQuad)
    //.fadeIn(duration: 2800.ms, curve: Curves.easeOutQuad)
    //.animate()
    //.animate(onPlay: (controller) => controller.repeat())
    //.shimmer(delay: 8000.ms, duration: 600.ms, color: Colors.white);

    return warnCard;
  }

  Widget buildExample(BuildContext context) {
    List<Widget> sampleList = List.generate(descs[0].length, (index) {
      return ListTile(
        //leading: Icon(Icons.tips_and_updates_sharp),
        dense: true,
        title: Row(
          children: [
            Flexible(
              fit: FlexFit.loose,
              child: Text(
                descs[0][index],
              ),
            ),
          ],
        ),

        trailing: IconButton(
            icon: const Icon(Icons.copy),
            onPressed: () {
              Clipboard.setData(ClipboardData(text: descs[0][index]));

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('복사되었습니다.'),
                  action: SnackBarAction(
                    label: '확인',
                    onPressed: () {},
                  ),
                ),
              );
            }),
      );
    });

    sampleList = sampleList
        .animate(interval: 200.ms)
        .fadeIn(duration: 500.ms, delay: 200.ms)
        //.shimmer(blendMode: BlendMode.srcOver, color: Colors.white)
        //.shimmer(color: Colors.white)
        .shimmer(blendMode: BlendMode.darken, color: Colors.white12)
        .move(begin: const Offset(-16, 0), curve: Curves.easeOutQuad);

    final uiNoti = context.read<UIChangeNotifier>();

    Widget leadIcon = Icon(Icons.tips_and_updates_outlined,
        color: uiNoti.isLightMode ? Colors.amber[900] : Colors.amber);

    // leadIcon = leadIcon
    //     .animate(onPlay: (controller) => controller.repeat())
    //     .shimmer(
    //         delay: 1000.ms,
    //         duration: 800.ms,
    //         color: Colors.amberAccent) // shimmer +
    //     .shake(hz: 4, curve: Curves.easeInOutCubic) // shake +
    //     .scale(
    //         begin: const Offset(1, 1),
    //         end: const Offset(1.2, 1.2),
    //         duration: 600.ms) // scale up
    //     .then(delay: 600.ms) // then wait and
    //     .scale(
    //         begin: const Offset(1, 1),
    //         end: const Offset(1 / 1.2, 1 / 1.2)); // scale down

    leadIcon = leadIcon
        .animate(onPlay: (controller) => controller.repeat())
        .shimmer(delay: 1000.ms, duration: 800.ms, color: Colors.amberAccent);

    return Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: 20, vertical: 20), // .all(20),
        child: Column(children: [
          ListTile(
            // leading: Icon(Icons.tips_and_updates_outlined,
            //     color: uiNoti.isLightMode ? Colors.amber[900] : Colors.amber),
            leading: leadIcon,

            title: const Text(
              '활용 예시',
              //textScaleFactor: 1.0,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          ...sampleList,
        ]));
  }

  Widget buildReplay(BuildContext context) {
    // Widget askWidget = Padding(
    //     padding: const EdgeInsets.fromLTRB(90, 0, 0, 0),
    //     child: CheckboxListTile(
    //       controlAffinity: ListTileControlAffinity.leading,
    //       title: const Text('다시 보지 않기'),
    //       //secondary: Icon(Icons.ac_unit),
    //       checkColor: Colors.black,
    //       activeColor: Colors.cyanAccent,
    //       value: true,
    //       onChanged: (value) {},
    //     ));

    Widget askWidget = Padding(
      padding: const EdgeInsets.fromLTRB(90, 0, 0, 0),
      child: Selector<AppDataNotifier, bool>(selector: (_, provider) {
        // notebookTest
        mgLog('다시보지않기 참조');
        return provider.isViewExample;
      }, builder: (context, isViewExample, child) {
        mgLog('다시보지않기 변경');
        return CheckboxListTile(
            controlAffinity: ListTileControlAffinity.leading,
            title: const Text('다시 보지 않기'),
            checkColor: Colors.black,
            activeColor: Colors.cyanAccent,
            value: isViewExample,
            onChanged: (value) {
              if (value != null) {
                context.read<AppDataNotifier>().viewExample = value;
              }
            });
      }),
    );

    askWidget = askWidget
        .animate()
        .fadeIn(duration: 200.ms, delay: 1000.ms)
        //.slide(duration: 700.ms, delay: 2000.ms, curve: Curves.easeOutQuad, begin:)
        // .shimmer(
        //     duration: 2000.ms,
        //     blendMode: BlendMode.darken,
        //     color: Colors.cyanAccent)
        .move(
            duration: 200.ms,
            begin: const Offset(0, 16),
            curve: Curves.easeOutQuad);

    return askWidget;
  }
}
