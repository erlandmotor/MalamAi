import 'package:flutter/material.dart';

class PageSetting extends StatelessWidget {
  PageSetting({Key? key}) : super(key: key);

  //Navigator.pushNamed(context, GlobalDefine.RouteNameSetting);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('설정')),
        body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              ListTile(
                title: Row(
                  children: [
                    Expanded(
                        flex: 5,
                        child: Text(
                          '시스템설정 사용',
                        )),
                    Spacer(),
                    Switch(
                      value: true,
                      onChanged: (bool value) {
                        //parent.SetUseSystemSet(value);
                      },
                    ),
                  ],
                ),
              ),
              Divider(thickness: 10),
              ListTile(
                title: Row(
                  children: [
                    Expanded(
                        flex: 5,
                        child: Text(
                          '다크/라이트',
                        )),
                    Spacer(),
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
                    Text(
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
