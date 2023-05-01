import 'dart:async';

import 'package:chat_playground/api/chat_api.dart';
import 'package:chat_playground/define/global_define.dart';
import 'package:chat_playground/models/chat_message.dart';
import 'package:chat_playground/widgets/message_bubble.dart';
import 'package:chat_playground/widgets/message_composer.dart';
import 'package:chat_playground/page/side_drawer.dart';
import 'package:chat_playground/widgets/mg_ad_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({
    required this.chatApi,
    super.key,
  });

  final ChatApi chatApi;

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  List<ChatMessage> _messages = <ChatMessage>[
    ChatMessage('안녕하세요?', false),
  ];
  var _awaitingResponse = false;
  final ScrollController _controller = ScrollController();
  List<Widget> bubbleWidgets = [];

  @override
  void initState() {
    makeBubbleWidget();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text(titleNameMain, textScaleFactor: 0.7),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.delete),
              //tooltip: 'Hi!',
              onPressed: () {
                openDialog(context);
                // setState(() {
                //   _messages.clear();
                //   _messages = <ChatMessage>[
                //     ChatMessage('안녕하세요?', false),
                //   ];
                //   makeBubbleWidget();
                // });
              },
            ),
            IconButton(
              //icon: const Icon(Icons.assistant_sharp),
              icon: const Icon(Icons.help),

              //tooltip: 'Hi!',
              onPressed: () {
                openDialog(context);
              },
            ),
          ]),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              //reverse: true,
              controller: _controller,
              itemCount: bubbleWidgets.length,
              itemBuilder: (context, index) {
                return bubbleWidgets[index];
              },
            ),
          ),
          MessageComposer(
            onSubmitted: _onSubmitted,
            awaitingResponse: _awaitingResponse,
          ),
        ],
      ),
      drawer: const MGSideDrawer(),
    );
  }

  Future<void> _onSubmitted(String message) async {
    setState(() {
      _messages.add(ChatMessage(message, true));
      makeBubbleWidget();
      //_scrollDown();
      _awaitingResponse = true;
    });

    _controller.jumpTo(_controller.position.maxScrollExtent);

    try {
      final response = await widget.chatApi.completeChat(_messages);
      setState(() {
        _messages.add(ChatMessage(response, false));
        makeBubbleWidget();
        _awaitingResponse = false;
      });
    } catch (err) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An error occurred. Please try again.')),
      );
      setState(() {
        _awaitingResponse = false;
      });
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.jumpTo(_controller.position.maxScrollExtent);
    });
  }

  makeBubbleWidget() {
    bubbleWidgets.clear();
    for (int i = 0; i < _messages.length; i++) {
      bubbleWidgets.add(MessageBubble(
        content: _messages[i].content,
        isUserMessage: _messages[i].isUserMessage,
      ));

      if (kIsWeb == false) {
        if (i != 0 && i % 6 == 0) {
          bubbleWidgets.add(const MgAdWidget());
        }
      }
    }

    /*
    final int length = bubbleWidgets.length;
    final int init = (length + length / 6).toInt();
    for (int i = init; i < _messages.length; i++) {
      bubbleWidgets.add(MessageBubble(
        content: _messages[i].content,
        isUserMessage: _messages[i].isUserMessage,
      ));

      if (bubbleWidgets.isNotEmpty && bubbleWidgets.length % 6 == 0) {
        bubbleWidgets.add(const MgAdWidget());
      }
    }
    */
  }

  void openDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('대화내용 삭제'),
        content: const Text('모두 삭제 하시겠습니까?'),
        actions: <Widget>[
          TextButton(
              child: const Text('삭제'),
              onPressed: () {
                Navigator.of(context).pop();

                setState(() {
                  _messages.clear();
                  _messages = <ChatMessage>[
                    ChatMessage('안녕하세요?', false),
                  ];
                  makeBubbleWidget();
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
