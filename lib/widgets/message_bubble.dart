import 'package:chat_playground/models/ui_change_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:markdown_widget/markdown_widget.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

class MessageBubble extends StatelessWidget {
  const MessageBubble({
    required this.content,
    required this.isUserMessage,
    super.key,
  });

  final String content;
  final bool isUserMessage;

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final uiNoti = context.watch<UIChangeNotifier>();
    return Container(
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: isUserMessage
            ? themeData.colorScheme.primary.withOpacity(0.4)
            : themeData.colorScheme.secondary.withOpacity(0.4),
        borderRadius: const BorderRadius.all(Radius.circular(12)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  isUserMessage ? '나의 말' : 'AI 답변',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 8),
            MarkdownWidget(
              data: content,
              shrinkWrap: true,
              config: uiNoti.isLightMode
                  ? MarkdownConfig.defaultConfig
                  : MarkdownConfig.darkConfig,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Spacer(),
                IconButton(
                    onPressed: () {
                      String adjust = content;
                      //adjust = adjust.replaceAll(RegExp(r'^.*[`].*$'), '\n\n');

                      adjust = adjust
                          .split("\n")
                          .where((line) => !line.contains("```"))
                          .join("\n");

                      Clipboard.setData(ClipboardData(text: adjust));
                    },
                    icon: const Icon(Icons.copy_rounded)),
                IconButton(
                    onPressed: () async {
                      final box = context.findRenderObject() as RenderBox?;
                      await Share.share(content,
                          //subject: link,
                          sharePositionOrigin:
                              box!.localToGlobal(Offset.zero) & box.size);
                    },
                    icon: const Icon(Icons.share_rounded)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
