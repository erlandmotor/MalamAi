import 'package:flutter/material.dart';

class PageUsage extends StatelessWidget {
  const PageUsage({Key? key}) : super(key: key);

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
            // actions: [
            //   TextButton(
            //     child: const Text('Close'),
            //     onPressed: () => Navigator.of(context).pop(),
            //   ),
            // ],
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
                          // TextButton(
                          //   child: const Text('Okay'),
                          //   onPressed: () => Navigator.of(context).pop(),
                          // ),
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
