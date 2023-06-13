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
                            bottom: PreferredSize(
                                preferredSize: const Size.fromHeight(48.0),
                                child: Container(
                                  height: 48.0,
                                  alignment: Alignment.center,
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Text('무료체험중입니다.'),
                                        TextButton.icon(
                                            onPressed: () {
                                              Navigator.pushNamed(
                                                  context, routeNamePurchase);
                                            },
                                            icon: const Icon(
                                                Icons.payment_outlined),
                                            label: const Text('구매')),
                                      ]),
                                )),
                            //expandedHeight: 20.0,
                            //backgroundColor: Colors.transparent, //투명색.
                            // flexibleSpace: ClipRect(
                            //   child: BackdropFilter(
                            //     filter:
                            //         ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                            //     child: FlexibleSpaceBar(
                            //       centerTitle: true, //child를 중앙에 놓는다.
                            //       title: Text('title'),
                            //     ),
                            //   ),
                            // ),
                            title: Selector<RCPurchasesNotifier, bool>(
                                selector: (_, provider) =>
                                    provider.entitlementIsActive,
                                builder: (context, isActive, child) {
                                  if (isActive) {
                                    return const Text(titleNameMain,
                                        textScaleFactor: 0.7);
                                  } else {
                                    return const Text('무료체험중입니다.',
                                        textScaleFactor: 0.7);
                                  }
                                }),
                            actions: <Widget>[
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () {
                                  openDeleteDialog(context);
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.view_list),
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
          content: const Text('에러가 발생했습니다. 다시 시도하세요.'),
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
