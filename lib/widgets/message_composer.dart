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
      height: 80,
      padding: const EdgeInsets.all(12),
      color: Theme.of(context).colorScheme.secondaryContainer.withOpacity(0.05),
      //color: Colors.amber,
      child:
          //  SafeArea(
          //   child:
          Row(
        children: [
          Expanded(
            child: !awaitingResponse
                ? TextField(
                    controller: _messageController,
                    onSubmitted: onSubmitted,
                    decoration: const InputDecoration(
                      suffixIcon: Icon(Icons.send),
                      //floatingLabelAlignment: FloatingLabelAlignment.center,
                      hintText: '메시지를 입력하세요...',

                      border: InputBorder.none,
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          borderSide: BorderSide(
                            color: Colors.cyan,
                          )),
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: JumpingText('응답 대기중...'),
                      ),
                    ],
                  ),
          ),
          // Align(
          //   alignment: Alignment.topRight,
          //   child: IconButton(
          //     onPressed: !awaitingResponse
          //         ? () => onSubmitted(_messageController.text)
          //         : null,
          //     icon: const Icon(Icons.send),
          //   ),
          // ),
        ],
      ),
      //),
      //)
    );
  }
}
