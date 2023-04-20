import 'dart:async';

import 'package:chat_playground/api/chat_api.dart';
import 'package:chat_playground/define/mg_handy.dart';
import 'package:chat_playground/models/chat_message.dart';
import 'package:chat_playground/widgets/message_bubble.dart';
import 'package:chat_playground/widgets/message_composer.dart';
import 'package:chat_playground/page/side_drawer.dart';
import 'package:chat_playground/widgets/mg_ad_widget.dart';
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
  final _messages = <ChatMessage>[
    ChatMessage('안녕하세요?', false),
  ];
  var _awaitingResponse = false;
  final ScrollController _controller = ScrollController();

  @override
  void initState() {
    makeBubbleWidget();
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   _controller.jumpTo(_controller.position.maxScrollExtent);
    // });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chat Playground')),
      body: Column(
        children: [
          Expanded(
            // child: ListView(
            //   //reverse: true,
            //   controller: _controller,
            //   children: getChatBubbles(),
            //   //[
            //   // ..._messages.map(
            //   //   (msg) => MessageBubble(
            //   //     content: msg.content,
            //   //     isUserMessage: msg.isUserMessage,
            //   //   ),
            //   // ),
            //   //],
            // ),

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

    Timer(const Duration(milliseconds: 200), () {
      mgLog("잠시 대기");
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

      if (i != 0 && i % 6 == 0) {
        bubbleWidgets.add(const MgAdWidget());
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

  List<Widget> bubbleWidgets = [];
  List<Widget> getChatBubbles() {
    //List<Widget> widgets = [];

    // for (int i = 0; i < _messages.length; i++) {
    //   bubbleWidgets.add(MessageBubble(
    //     content: _messages[i].content,
    //     isUserMessage: _messages[i].isUserMessage,
    //   ));

    //   if (i != 0 && i % 6 == 0) {
    //     bubbleWidgets.add(const MgAdWidget());
    //   }
    // }

    // setState(() {
    //   _scrollDown();
    // });

    //return widgets.reversed.toList();
    return bubbleWidgets;
  }
}
