import 'package:chat_playground/api/chat_api.dart';
import 'package:chat_playground/models/chat_message.dart';
import 'package:chat_playground/widgets/message_bubble.dart';
import 'package:chat_playground/widgets/message_composer.dart';
import 'package:chat_playground/widgets/side_drawer.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chat Playground')),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                ..._messages.map(
                  (msg) => MessageBubble(
                    content: msg.content,
                    isUserMessage: msg.isUserMessage,
                  ),
                ),
              ],
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
      _awaitingResponse = true;
    });
    try {
      final response = await widget.chatApi.completeChat(_messages);
      setState(() {
        _messages.add(ChatMessage(response, false));
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
  }
}
