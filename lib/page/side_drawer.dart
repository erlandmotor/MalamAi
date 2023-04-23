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
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: const [
                            ListTile(
                              dense: true,
                              title: Text(
                                //'Chat Playground',
                                titleNameMain,
                                textAlign: TextAlign.left,
                                textScaleFactor: 1.0,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22,
                                  //fontFamily: 'SpoqaHanSansNeo',
                                  //color: colorScheme.onSecondary,
                                ),
                              ),
                            ),
                            ListTile(
                              dense: true,
                              title: Text(
                                'Ver $ver',
                                textAlign: TextAlign.left,
                                textScaleFactor: 1.0,
                                style: TextStyle(
                                  fontSize: 15,
                                  letterSpacing: 0.5,
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
            title: const Text(
              '설정',
              textScaleFactor: 1.0,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22,
                //fontFamily: 'SpoqaHanSansNeo',
                //color: colorScheme.onSecondary,
              ),
            ),
            onTap: () {
              Navigator.pop(context);
              //Navigator.pushNamed(context, GlobalDefine.RouteNameShortcut);
              Navigator.pushNamed(context, routeNameOption);
            },
          ),
        ],
      ),
    );
  }
}
