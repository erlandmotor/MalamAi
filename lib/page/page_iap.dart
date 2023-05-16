import 'package:chat_playground/models/ui_change_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PageIAP extends StatelessWidget {
  const PageIAP({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var uiNoti = context.watch<UIChangeNotifier>();

    return Scaffold(
        appBar: AppBar(
            title: const Text(
          '설정',
          textScaleFactor: 1.0,
        )),
        body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              ListTile(
                title: Row(
                  children: [
                    const Expanded(
                        flex: 5,
                        child: Text(
                          '시스템설정 UI 사용',
                          textScaleFactor: 1.0,
                        )),
                    const Spacer(),
                    Switch(
                      value: uiNoti.isUseSystemOption,
                      onChanged: (bool value) =>
                          uiNoti.isUseSystemOption = value,
                    ),
                  ],
                ),
              ),
              const Divider(thickness: 10),
              ListTile(
                title: Row(
                  children: [
                    const Expanded(
                        flex: 5,
                        child: Text(
                          '다크모드',
                          textScaleFactor: 1.0,
                        )),
                    const Spacer(),
                    Switch(
                      value: !uiNoti.isLightMode,
                      //activeColor: Colors.red,
                      onChanged:
                          // uiNoti.isUseSystemOption
                          // ? null
                          // :
                          (bool value) => uiNoti.isLightMode = !value,
                    ),
                  ],
                ),
              ),
              ListTile(
                title: Column(
                  children: [
                    const Text(
                      '글꼴 크기 변경',
                      textScaleFactor: 1.0,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Slider(
                        min: 0.8,
                        max: 3.2,
                        divisions: 8,
                        label: uiNoti.customTextScaleFactor.toStringAsFixed(2),
                        onChanged:
                            // uiNoti.isUseSystemOption
                            // ? null
                            // :
                            (double value) =>
                                uiNoti.customTextScaleFactor = value,
                        value: uiNoti.customTextScaleFactor),
                  ],
                ),
              ),
              const Divider(),
              Container(
                  alignment: Alignment.topLeft,
                  child: Padding(
                      padding: const EdgeInsets.only(left: 40.0), //.all(20),
                      child: Card(
                          color: uiNoti.materialThemeData.colorScheme.secondary
                              .withOpacity(0.4),
                          child: Container(
                              padding: const EdgeInsets.all(30),
                              child: const Text('안녕하세요.\nHello.\nこんにちは.',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold)))))),
              const Divider(thickness: 10),
            ]));
  }
}
