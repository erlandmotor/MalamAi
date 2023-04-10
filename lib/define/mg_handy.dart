import 'package:flutter/foundation.dart';

// Black:   \x1B[30m
// Red:     \x1B[31m
// Green:   \x1B[32m
// Yellow:  \x1B[33m
// Blue:    \x1B[34m
// Magenta: \x1B[35m
// Cyan:    \x1B[36m
// White:   \x1B[37m
// Reset:   \x1B[0m
// \x1B[31mHello\x1B[0m
// \x1B  [31m  Hello  \x1B  [0m

mgLog(String log) {
  String logResult;
  if (kDebugMode) {
    logResult = '\x1B[36mmgLog : \x1B[36m$log\x1B[0m';
    print(logResult);
  }
}
