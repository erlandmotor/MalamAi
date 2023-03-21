import 'package:flutter/material.dart';
import 'package:progress_indicators/progress_indicators.dart';

class MessageComposer extends StatelessWidget {
  MessageComposer({
    required this.onSubmitted,
    required this.awaitingResponse,
    super.key,
  });

  final TextEditingController _messageController = TextEditingController();

  final void Function(String) onSubmitted;
  final bool awaitingResponse;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      color: Theme.of(context).colorScheme.secondaryContainer.withOpacity(0.05),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: !awaitingResponse
                  ? TextField(
                      controller: _messageController,
                      onSubmitted: onSubmitted,
                      decoration: const InputDecoration(
                        //hintText: 'Write your message here...',
                        hintText: '메시지를 입력하세요...',
                        border: InputBorder.none,
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // SizedBox(
                        //   height: 24,
                        //   width: 24,
                        //   //child: CircularProgressIndicator(),
                        //   child: const JumpingDotsProgressIndicator(
                        //     fontSize: 28.0,
                        //   ),
                        // ),

                        // JumpingDotsProgressIndicator(
                        //   fontSize: 28.0,
                        // ),

                        // SizedBox(
                        //   height: 24,
                        //   width: 24,
                        //   child: JumpingDotsProgressIndicator(
                        //     fontSize: 28.0,
                        //   ),
                        // ),

                        // Padding(
                        //   padding: EdgeInsets.all(16),
                        //   child: Text('응답 대기중...'),
                        // ),

                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: JumpingText('응답 대기중...'),
                        ),
                      ],
                    ),
            ),
            IconButton(
              onPressed: !awaitingResponse
                  ? () => onSubmitted(_messageController.text)
                  : null,
              icon: const Icon(Icons.send),
            ),
          ],
        ),
      ),
    );
  }
}
