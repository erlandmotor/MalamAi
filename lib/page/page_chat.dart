import 'dart:async';

import 'package:chat_playground/api/chat_api.dart';
import 'package:chat_playground/define/global_define.dart';
import 'package:chat_playground/define/hive_chat_massage.dart';
import 'package:chat_playground/define/mg_handy.dart';
import 'package:chat_playground/models/app_data_notifier.dart';

import 'package:chat_playground/models/chatgroup_notifier.dart';
import 'package:chat_playground/models/rc_purchases_notifier.dart';
import 'package:chat_playground/widgets/message_bubble.dart';
import 'package:chat_playground/widgets/message_composer.dart';
import 'package:chat_playground/page/side_drawer.dart';
import 'package:chat_playground/widgets/mg_ad_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

class PageChat extends StatefulWidget {
  const PageChat({
    required this.chatApi,
    super.key,
  });

  final ChatApi chatApi;

  @override
  State<PageChat> createState() => PageChatState();
}

class PageChatState extends State<PageChat> {
  var _awaitingResponse = false;
  final ScrollController _controller = ScrollController();
  List<Widget> bubbleWidgets = [];

  static const int adWidgetTerm = 6;

  late Box<MessageItem> chatBox;

  bool isBegin = true;

  @override
  void initState() {
    //makeBubbleWidget();
    chatBox = context.read<ChatGroupNotifier>().openLatest();
    super.initState();

    if (context.read<AppDataNotifier>().dontShowExample == false) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushNamed(context, routeChatHelp);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    //chatBox = context.read<ChatGroupNotifier>().openLatest();
    //final name = context.select<ChatGroupNotifier>((Box<MessageItem> p) => p);
    chatBox = context.select((ChatGroupNotifier p) => p.curChatBox);

    bool isEntitlementIsActive =
        context.select((RCPurchasesNotifier p) => p.entitlementIsActive);

    late Widget? demoButtonWidget;
    //isEntitlementIsActive = true;
    if (isEntitlementIsActive == false) {
      demoButtonWidget = TextButton(
        child: const Text('무료체험중입니다 구매하여 제한없이 사용하세요'),
        onPressed: () {
          Navigator.pushNamed(context, routeNamePurchase);
        },
      );

      demoButtonWidget = demoButtonWidget
          // .animate(interval: 100.ms)
          // .move(begin: const Offset(-26, 0), curve: Curves.easeOutQuad)
          // .fadeIn(duration: 500.ms, delay: 100.ms)
          .animate(onPlay: (controller) => controller.repeat())
          .shimmer(
              delay: 200.ms,
              duration: 2400.ms,
              //blendMode: BlendMode.srcOver,
              blendMode: BlendMode.srcATop,
              color: Colors.amberAccent[100]);
      //.then(delay: 3000.ms);
    } else {
      demoButtonWidget = null;
    }

    return Scaffold(
        drawer: const MGSideDrawer(),
        body: SafeArea(
            child: Column(
          children: [
            Expanded(
              child: ValueListenableBuilder(
                  valueListenable: chatBox.listenable(),
                  builder: (context, Box<MessageItem> box, _) {
                    // if (box.values.isEmpty) {
                    //   return const Center(
                    //     child: Text("메시지 없음"),
                    //   );
                    // }
                    final int myItemCount =
                        box.length + (box.length ~/ adWidgetTerm);

                    return CustomScrollView(
                      //shrinkWrap: true,
                      controller: _controller,
                      slivers: <Widget>[
                        SliverAppBar(
                            pinned: false,
                            snap: false,
                            floating: true,
                            title: Selector<RCPurchasesNotifier, bool>(
                                selector: (_, provider) =>
                                    provider.entitlementIsActive,
                                builder: (context, isActive, child) {
                                  return const Text(titleNameMain,
                                      textScaleFactor: 0.7);
                                  /*
                                  if (isActive) {
                                    return const Text(titleNameMain,
                                        textScaleFactor: 0.7);
                                  } else {
                                    return const Text('무료체험중입니다.',
                                        textScaleFactor: 0.7);                                        
                                  }
                                  */
                                }),
                            bottom: isEntitlementIsActive == false
                                ? PreferredSize(
                                    preferredSize: const Size.fromHeight(48.0),
                                    child: Container(
                                      height: 48.0,
                                      alignment: Alignment.center,
                                      child: demoButtonWidget,
                                    ))
                                : null,
                            actions: <Widget>[
                              IconButton(
                                icon: const Icon(Icons.delete_outlined),
                                onPressed: () {
                                  openDeleteDialog(context);
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.view_list_outlined),
                                onPressed: () {
                                  Navigator.pushNamed(
                                      context, routeNameChatTab);
                                },
                              ),
                            ]),
                        SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (BuildContext context, int index) {
                              if (index > adWidgetTerm - 1 &&
                                  index % adWidgetTerm == 0) {
                                mgLog('index - $index, ad');

                                if (kIsWeb == false) {
                                  return const MgAdWidget();
                                } else {
                                  return const Divider(height: 10);
                                }
                              } else {
                                final dataindex = index - index ~/ adWidgetTerm;
                                final MessageItem? data = box.getAt(dataindex);

                                return MessageBubble(
                                  content: data!.content,
                                  isUserMessage: data.isUserMessage,
                                );
                              }
                            },
                            childCount: myItemCount,
                          ),
                        ),
                      ],
                    ); //),
                  }),
            ),
            MessageComposer(
              onSubmitted: _onSubmitted,
              awaitingResponse: _awaitingResponse,
            ),
          ],
        )));
  }

  Future<void> _onSubmitted(String message) async {
    //var tempContext = context;
    //box.
    await chatBox.add(MessageItem(message, true));

    setState(() {
      _awaitingResponse = true;
    });

    if (chatBox.length > 0) {
      _controller.jumpTo(_controller.position.maxScrollExtent);
    }

    final List<MessageItem> msgs = chatBox.values.toList();

    try {
      final response = await widget.chatApi.completeChat(msgs);
      await chatBox.add(MessageItem(response, false));
      setState(() {
        _awaitingResponse = false;
      });
    } catch (err) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('에러가 발생했습니다. 잠시후 다시 시도하세요.'),
          action: SnackBarAction(
            label: '확인',
            onPressed: () {},
          ),
        ),
      );
      setState(() {
        _awaitingResponse = false;
      });
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.jumpTo(_controller.position.maxScrollExtent);
    });
  }

  void openDeleteDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('대화내용 삭제'),
        content: const Text('대화내용을 모두 삭제 하시겠습니까?'),
        actions: <Widget>[
          TextButton(
              child: const Text('삭제'),
              onPressed: () {
                Navigator.of(context).pop();

                setState(() {
                  chatBox.clear();
                  chatBox.add(MessageItem('안녕하세요?', false));
                });
              }),
          FilledButton(
            child: const Text('취소'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }
}
