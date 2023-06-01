import 'package:flutter/material.dart';

class PageUsage extends StatelessWidget {
  const PageUsage({Key? key}) : super(key: key);

// 예시 파이널
// 중년 뱃살을 빼려면 어떻게 해야해?
// 스타트업의 개발팀장처럼 면접 질문을 생성해줘.
// 사이버펑크에 대해서 설명해줄래?
// C++로 HTTP를 구현하는 예제를 보여줄래?

// 주의 사항
// 때때로 부정확한 정보를 생성할 수 있습니다.
// 때때로 유해한 지침이나 편향된 콘텐츠를 생성할 수 있습니다.
// 위사항은 제작사의 입장을 대변하지 않습니다.

  @override
  Widget build(BuildContext context) {
    return Dialog.fullscreen(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Scaffold(
          appBar: AppBar(
            //title: const Text('Full-screen dialog'),
            centerTitle: false,
            leading: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          body: Center(
              child: TextButton(
                  child: const Text('test'),
                  onPressed: () {
                    showDialog<void>(
                      context: context,
                      builder: (context) => AlertDialog(
                        //title: const Text('What is a dialog?'),
                        content: const Column(children: [
                          ListTile(
                            title: Row(
                              children: [
                                Expanded(
                                    flex: 5,
                                    child: Text(
                                      '시스템설정 UI 사용',
                                      textScaleFactor: 1.0,
                                    )),
                                Spacer(),
                                Switch(value: true, onChanged: null),
                              ],
                            ),
                          ),
                        ]),
                        actions: <Widget>[
                          FilledButton(
                            child: const Text('알겠습니다'),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                        ],
                      ),
                    );
                  })),
        ),
      ),
    );
  }
}
