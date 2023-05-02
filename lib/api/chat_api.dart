import 'package:chat_playground/define/hive_chat_massage.dart';
//import 'package:chat_playground/models/chat_message.dart';
//import 'package:chat_playground/secrets.dart';
import 'package:dart_openai/openai.dart';

class ChatApi {
  static const _model = 'gpt-3.5-turbo';

  ChatApi() {
    OpenAI.apiKey = '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';
    //OpenAI.organization = openAiOrg;
  }

  late int checklength;
  late int checkindex;
  late List<MessageItem> calcedMessages;
  Future<String> completeChat(List<MessageItem> messages) async {
    //--- test
    final msgContents =
        messages.fold<int>(0, (value, e) => value + (e.content.length));

    if (msgContents > 4000) {
      checklength = msgContents;
      checkindex = 0;

      for (var item in messages) {
        checkindex++;
        checklength -= item.content.length;
        if (checklength < 4000) {
          break;
        }
      }
      //List<int> subList1 = list.sublist(3);
      calcedMessages = messages.sublist(checkindex);

      final msgContents2 =
          calcedMessages.fold<int>(0, (value, e) => value + (e.content.length));
    } else {
      calcedMessages = messages;
    }

    //-----------------
    // final chatCompletion = await OpenAI.instance.chat.create(
    //   model: _model,
    //   messages: messages
    //       .map((e) => OpenAIChatCompletionChoiceMessageModel(
    //             //role: e.isUserMessage ? 'user' : 'assistant',
    //             role: e.isUserMessage
    //                 ? OpenAIChatMessageRole.user
    //                 : OpenAIChatMessageRole.assistant,
    //             content: e.content,
    //           ))
    //       .toList(),
    // );

    final chatCompletion = await OpenAI.instance.chat.create(
      model: _model,
      messages: calcedMessages
          .map((e) => OpenAIChatCompletionChoiceMessageModel(
                //role: e.isUserMessage ? 'user' : 'assistant',
                role: e.isUserMessage
                    ? OpenAIChatMessageRole.user
                    : OpenAIChatMessageRole.assistant,
                content: e.content,
              ))
          .toList(),
    );

    return chatCompletion.choices.first.message.content;
  }
}
