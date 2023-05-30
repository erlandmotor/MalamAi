import 'package:chat_playground/define/global_define.dart';
import 'package:chat_playground/models/ui_change_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MGSideDrawer extends StatelessWidget {
  const MGSideDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var uiNoti = context.read<UIChangeNotifier>();
    return Drawer(
      backgroundColor: uiNoti.materialThemeData.colorScheme.secondaryContainer,
      shape: const RoundedRectangleBorder(
          // borderRadius: BorderRadius.only(
          //   topRight: Radius.circular(40),
          //   bottomRight: Radius.circular(40),
          //   topLeft: Radius.circular(40),
          //   bottomLeft: Radius.circular(40),
          // ),
          ),
      elevation: 8,
      child: Column(
        //crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.max,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: uiNoti.materialThemeData.colorScheme.secondary,
              image: const DecorationImage(
                  fit: BoxFit.cover,
                  opacity: 1.0,
                  image: AssetImage(wallpaperImage)),
              // borderRadius: const BorderRadius.only(
              //   topRight: Radius.circular(16),
              //   // bottomLeft: Radius.circular(10),
              //   // bottomRight: Radius.circular(10),
              // ),
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
                      ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.asset(
                            logoImage,
                            width: 100,
                            height: 100,
                            //fit: BoxFit.cover,
                          )),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 100),
                        child: VerticalDivider(
                          color: Colors.greenAccent,
                        ),
                      ),

                      /*2*/
                      const Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ListTile(
                              dense: true,
                              title: Text(
                                titleNameMain,
                                textAlign: TextAlign.left,
                                textScaleFactor: 1.0,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    // color: uiNoti.materialThemeData.colorScheme
                                    //      .onSecondary,

                                    //color: Color.fromARGB(255, 29, 1, 80),
                                    color: Colors.white),
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
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: Text(
              '설정',
              textScaleFactor: 1.0,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color:
                    uiNoti.materialThemeData.colorScheme.onSecondaryContainer,
              ),
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, routeNameOption);
            },
          ),
          ListTile(
            leading: const Icon(Icons.view_list),
            title: Text(
              '채팅 그룹 관리',
              textScaleFactor: 1.0,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color:
                    uiNoti.materialThemeData.colorScheme.onSecondaryContainer,
              ),
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, routeNameChatTab);
            },
          ),
          ListTile(
            leading: const Icon(Icons.help_center),
            title: Text(
              '사용법및 예시',
              textScaleFactor: 1.0,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color:
                    uiNoti.materialThemeData.colorScheme.onSecondaryContainer,
              ),
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, routeChatHelp);
            },
          ),
          ListTile(
            leading: const Icon(Icons.payment),
            title: Text(
              '구매',
              textScaleFactor: 1.0,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color:
                    uiNoti.materialThemeData.colorScheme.onSecondaryContainer,
              ),
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, routeNamePurchase);
            },
          ),
          const Spacer(),
          const Align(
              //alignment: FractionalOffset.bottomCenter,
              alignment: Alignment.bottomCenter,
              child: Column(
                children: <Widget>[
                  //Divider(),
                  ListTile(
                      // tileColor: uiNoti.materialThemeData.colorScheme.secondary,
                      // textColor:
                      //     uiNoti.materialThemeData.colorScheme.onSecondary,
                      // iconColor:
                      //     uiNoti.materialThemeData.colorScheme.onSecondary,
                      leading: Icon(Icons.info),
                      title: Text(
                        'Ver $ver',
                        textAlign: TextAlign.right,
                        textScaleFactor: 1.0,
                        style: TextStyle(
                          fontSize: 12,
                          //letterSpacing: 1.0,
                          // color: uiNoti.materialThemeData.colorScheme
                          //     .onSecondaryContainer,
                        ),
                      )),
                ],
              )),
        ],
      ),
    );
  }
}
