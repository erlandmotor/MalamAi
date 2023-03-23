import 'package:chat_playground/models/ui_change_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PageSetting extends StatelessWidget {
  const PageSetting({Key? key}) : super(key: key);

  //Navigator.pushNamed(context, GlobalDefine.RouteNameSetting);
  @override
  Widget build(BuildContext context) {
    var uiNoti = context.read<UIChangeNotifier>();

    return Scaffold(
        appBar: AppBar(title: const Text('설정')),
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
                          '시스템설정 사용',
                        )),
                    const Spacer(),
                    Switch(
                      value: uiNoti.isUseSystemSetting,
                      onChanged: (bool value) {
                        //parent.SetUseSystemSet(value);
                      },
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
                          '다크/라이트',
                        )),
                    const Spacer(),
                    Switch(
                      value: true,
                      //activeColor: Colors.red,
                      onChanged: //parent.isUseSystemSetting
                          // ? null
                          // :
                          (bool value) {
                        //parent.SetLightMode(value);
                      },
                    ),
                  ],
                ),
              ),
              ListTile(
                title: Column(
                  children: [
                    const Text(
                      '글꼴 크기',
                      overflow: TextOverflow.ellipsis,
                    ),
                    Slider(
                        min: 0.8,
                        max: 4.0,
                        divisions: 8,
                        onChanged:
                            //  parent.isUseSystemSetting
                            // ? null
                            // :
                            (double value) {
                          //parent.SetScaleFactor(value);
                        },
                        value: 1.0 //parent.customTextScaleFactor,
                        ),
                  ],
                ),
              ),
            ]));
  }
}
