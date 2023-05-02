//import 'dart:io';

//import 'package:chat_playground/define/global_define.dart';
//import 'package:chat_playground/define/hive_chat_massage.dart';
import 'package:chat_playground/define/mg_handy.dart';
// import 'package:chat_playground/define/rc_store_config.dart';
// import 'package:chat_playground/define/ui_setting.dart';
import 'package:flutter/material.dart';
//import 'package:google_mobile_ads/google_mobile_ads.dart';
//import 'package:hive_flutter/hive_flutter.dart';

class AppDataNotifier with ChangeNotifier {
  AppDataNotifier() {
    mgLog('AppDataNotifier notifier init.......');
    //Future.microtask(() => loadUISetting());
  }
}
