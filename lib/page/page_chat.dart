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
        child: const Text('Uji coba gratis. Beli dan gunakan tanpa batasan.'),
        onPressed: () {
          Navigator.pushNamed(context, routeNamePurchase);
        },
      );

      demoButtonWidget = demoButtonWidget
          .animate(onPlay: (controller) => controller.repeat())
          .shimmer(
              delay: 200.ms,
              duration: 2400.ms,
              //blendMode: BlendMode.srcOver,
              blendMode: BlendMode.srcATop,
              color: Colors.amberAccent[100]);
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
                    //     child: Text("Tidak ada pesan"),
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
                                    return const Text('Ini adalah uji coba gratis.',
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

    await context.read<ChatGroupNotifier>().requestChatAI(message);

    //await chatBox.add(MessageItem(message, true));

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
          content: const Text('Terjadi kesalahan. Silakan coba lagi nanti.'),
          action: SnackBarAction(
            label: 'memeriksa',
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
        title: const Text('Hapus konten percakapan'),
        content: const Text('Apakah Anda ingin menghapus semua percakapan??'),
        actions: <Widget>[
          TextButton(
              child: const Text('menghapus'),
              onPressed: () {
                Navigator.of(context).pop();

                setState(() {
                  chatBox.clear();
                  chatBox.add(MessageItem('Halo?', false));
                });
              }),
          FilledButton(
            child: const Text('pembatalan'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }
}
