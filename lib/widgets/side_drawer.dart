import 'package:chat_playground/define/global_define.dart';
import 'package:flutter/material.dart';

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
            decoration: const BoxDecoration(
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
                      Image.asset(
                        'assets/icons/robot2.png',
                        width: 100,
                        height: 100,
                        //fit: BoxFit.cover,
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 100),
                        child: VerticalDivider(
                          color: Colors.greenAccent,
                        ),
                      ),

                      /*2*/
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const ListTile(
                              dense: true,
                              title: Text(
                                'Chat Playground',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  //fontFamily: 'SpoqaHanSansNeo',
                                  //color: colorScheme.onSecondary,
                                ),
                              ),
                            ),
                            ListTile(
                              // leading: Icon(Icons.add_alert_rounded,
                              //     color: Colors.white),
                              dense: true,
                              title: Text(
                                'Ver ${GlobalDefine.ver}',
                                textAlign: TextAlign.left,
                                style: const TextStyle(
                                  fontSize: 12,
                                  letterSpacing: 0.5,
                                  //color: colorScheme.onSecondary,
                                  //fontFamily: 'SpoqaHanSansNeo',
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
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('설정'),
            onTap: () {
              Navigator.pop(context);
              //Navigator.pushNamed(context, GlobalDefine.RouteNameShortcut);
              Navigator.pushNamed(context, GlobalDefine.routeNameOption);
            },
          ),
        ],
      ),
    );
  }
}
