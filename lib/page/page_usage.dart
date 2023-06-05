import 'package:chat_playground/models/ui_change_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class PageUsage extends StatelessWidget {
  PageUsage({Key? key}) : super(key: key);

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
      //'스타트업의 개발팀장처럼 면접 질문을 생성해줘.',
      '사이버펑크에 대해서 설명해줄래?',
      '중년 뱃살을 빼려면 어떻게 해야해?',
    ],
    [
      '때때로 부정확한 정보를 생성할 수 있습니다.',
      '때때로 유해한 지침이나 편향된 콘텐츠를 생성할 수 있습니다.',
      '위사항은 제작사의 입장을 대변하지 않습니다.',
    ],
  ];

  late UIChangeNotifier uiNoti;

  @override
  Widget build(BuildContext context) {
    uiNoti = context.read<UIChangeNotifier>();

    return Dialog.fullscreen(
      child: Scaffold(
        //drawer: const MGSideDrawer(),
        appBar: AppBar(
          title: const Text('사용법과 예시'),
          centerTitle: false,
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: ListView(children: [
          buildTotal(),
          TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('알겠습니다')),
        ]),
      ),
      //),
    );
  }

  Widget buildTotal() {
    return Column(children: [
      //  그룹( 예시, 주의등등)

      // buildGroup(),
      buildWarn(),
      buildGroup(),

      //]
      //),
    ]);
  }

  Widget buildGroup() {
    return Card(
      elevation: 8,
      margin: const EdgeInsets.all(20),
      child: Column(children: [
        const ListTile(
          leading: Icon(Icons.tips_and_updates_sharp),
          title: Text(
            '활용 예시',
            //textScaleFactor: 1.0,
          ),
        ),
        ...List.generate(descs[0].length, (index) {
          return ListTile(
            //leading: Icon(Icons.tips_and_updates_sharp),
            title: Row(
              children: [
                Flexible(
                  fit: FlexFit.tight,
                  child: Text(
                    descs[0][index],
                  ),
                ),
              ],
            ),

            trailing: IconButton(
              icon: const Icon(Icons.copy),
              onPressed: () =>
                  Clipboard.setData(ClipboardData(text: descs[0][index])),
            ),
          );
        }),
      ]),
    );
  }

  Widget buildWarn() {
    return Card(
      color: uiNoti.materialThemeData.colorScheme.tertiaryContainer,
      elevation: 8,
      margin: const EdgeInsets.all(20),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const ListTile(
              leading: Icon(Icons.warning),
              title: Text(
                '제한 사항',
                //textScaleFactor: 1.0,
              ),
            ),
            ...List.generate(descs[1].length, (index) {
              return ListTile(
                //leading: Icon(Icons.tips_and_updates_sharp),
                //style: ListTileStyle.drawer,
                dense: true,
                // title: Row(
                //   children: [
                //     Flexible(
                //       fit: FlexFit.tight,
                //       child: Text(
                //         descs[1][index],
                //       ),
                //     ),
                //   ],
                // ),

                title: Text(
                  descs[1][index],
                ),
              );

              // return Text(
              //   descs[1][index],
              // );
            }),
          ]),
    );
  }
}
