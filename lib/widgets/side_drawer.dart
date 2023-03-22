import 'package:chat_playground/define/global_define.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class MGSideDrawer extends StatelessWidget {
  const MGSideDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 8,
      child: Column(
        //crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.max,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              //color: colorScheme.secondary,
              // image: DecorationImage(
              //     fit: BoxFit.cover,
              //     opacity: 0.3,
              //     image: AssetImage('assets/images/lake.jpg')),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10),
              ),
            ),
            //),
            child: Row(
              children: [
                Expanded(
                  /*1*/
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    //crossAxisAlignment: CrossAxisAlignment.end,

                    //mainAxisSize: MainAxisSize.min,
                    children: [
                      // Image.asset(
                      //   'assets/icon/cloudy_day_512.png',
                      //   width: 100,
                      //   height: 100,
                      //   fit: BoxFit.cover,
                      // ),
                      // const Padding(
                      //   padding: EdgeInsets.symmetric(vertical: 100),
                      //   child: VerticalDivider(
                      //     color: Colors.greenAccent,
                      //   ),
                      // ),

                      /*2*/
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ElevatedButton(
                                  child: Text('설정'),
                                  onPressed: () {
                                    Navigator.pushNamed(
                                        context, GlobalDefine.RouteNameOption);
                                  }),
                            ),
                            ListTile(
                              dense: true,
                              title: Text(
                                'Chat Playground',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  fontFamily: 'SpoqaHanSansNeo',
                                  //color: colorScheme.onSecondary,
                                ),
                              ),
                            ),
                            ListTile(
                              // leading: Icon(Icons.add_alert_rounded,
                              //     color: Colors.white),
                              dense: true,
                              title: Text(
                                'Ver ${GlobalDefine.Ver}',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontSize: 12,
                                  letterSpacing: 0.5,
                                  //color: colorScheme.onSecondary,
                                  fontFamily: 'SpoqaHanSansNeo',
                                  //fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            ////////////////////////////////
            //CircleAvatar(
            // child: Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 0),
            //   //.only(bottom: 10, right: 10),
            //   child: Icon(
            //     Icons.account_circle,
            //     color: Colors.red.shade800,
            //     size: 90,
            //   ),
            // ),
            //backgroundColor: Colors.brown.shade800,

            //radius: 60.0,
            // child: Icon(
            //   Icons.account_circle,
            //   //color: Colors.red.shade800,
            //   //size: 90,
            // ),
            //child: const Text('HS'),
            /*
            */
            //),
            /////////////////////////////////////////////////////////
          ),

          // const Padding(
          //   padding: EdgeInsets.symmetric(horizontal: 0),
          //   child: Divider(),
          // ),

          // Row(
          //   children: [
          //     Spacer(),
          //     Text(
          //       ' 밝은 화면',
          //     ),
          //     Spacer(),
          //     Switch(
          //       // This bool value toggles the switch.
          //       value: parent!.useLightMode,
          //       //activeColor: Colors.red,
          //       onChanged: (bool value) {
          //         // This is called when the user toggles the switch.
          //         //setState(() {
          //         parent.handleBrightness(value);
          //         //}
          //         //);
          //       },
          //     ),
          //     Spacer(),
          //   ],
          // ),
          // Row(
          //   children: [
          //     Spacer(),
          //     Icon(Icons.flashlight_on),
          //     Text(
          //       ' 밝은 화면',
          //     ),
          //     Spacer(),
          //     Switch(
          //       // This bool value toggles the switch.
          //       value: parent!.useLightMode,
          //       //activeColor: Colors.red,
          //       onChanged: (bool value) {
          //         // This is called when the user toggles the switch.
          //         //setState(() {
          //         parent.handleBrightness(value);
          //         //}
          //         //);
          //       },
          //     ),
          //     Spacer(),
          //   ],
          // ),
          ListTile(
            leading: Icon(Icons.settings),
            title: const Text('설정'),
            onTap: () {
              Navigator.pop(context);
              //Navigator.pushNamed(context, GlobalDefine.RouteNameShortcut);
              Navigator.pushNamed(context, GlobalDefine.RouteNameOption);
            },
          ),

          ListTile(
            leading: Icon(Icons.flashlight_on),
            title: Row(
              children: [
                Text(
                  '밝은 화면',
                ),
                Spacer(),
                Switch(
                  // This bool value toggles the switch.
                  value: true,
                  //activeColor: Colors.red,
                  onChanged: (bool value) {
                    //parent.handleBrightness(value);
                  },
                ),
                Spacer(),
              ],
            ),
            // onTap: () {
            //   Navigator.pop(context);
            //   //Get.back();
            // },
          ),
        ],
      ),
    );
  }
}
