import 'dart:io';

import 'package:chat_playground/define/global_define.dart';
import 'package:chat_playground/define/mg_handy.dart';
import 'package:chat_playground/define/ui_setting.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class UIChangeNotifier with ChangeNotifier {
  // bool isUseSystemOption = true;
  // bool isLightMode = false;
  // bool isCupertinoUI = false;
  // double customTextScaleFactor = 1.0;

  static const String uiSetBoxName = 'myOption';

  UIOption uiOption = UIOption(true, false, false, 1.0);

  late final Box<UIOption> uiSettingBox;

  late ThemeData materialThemeData;

  bool get isUseSystemOption => uiOption.isUseSystemOption;
  bool get isLightMode => uiOption.isLightMode;
  bool get isCupertinoUI => uiOption.isCupertinoUI;
  double get customTextScaleFactor => uiOption.customTextScaleFactor;

  bool isSetChange = false;

  set isUseSystemOption(bool avalue) {
    uiOption.isUseSystemOption = avalue;
    isSetChange = true;
    notifyListeners();
    //SaveOption();
  }

  set isLightMode(bool avalue) {
    uiOption.isLightMode = avalue;
    uiOption.isUseSystemOption = false;
    isSetChange = true;
    notifyListeners();
    //SaveOption();
  }

  set isCupertinoUI(bool avalue) {
    uiOption.isCupertinoUI = avalue;
    uiOption.isUseSystemOption = false;
    isSetChange = true;
    notifyListeners();
    //SaveOption();
  }

  set customTextScaleFactor(double avalue) {
    uiOption.customTextScaleFactor = avalue;
    uiOption.isUseSystemOption = false;
    isSetChange = true;
    notifyListeners();
    //SaveOption();
  }

  UIChangeNotifier() {
    mgLog('UIChangeNotifier notifier init.......');
    loadUISetting();
    materialThemeData = updateThemes(uiOption.isLightMode);
  }

  loadUISetting() {
    uiSettingBox = Hive.box(uiSettingDB);
    UIOption? option = uiSettingBox.get(uiSetBoxName);
    if (option == null) {
      //uiOption = UIOption(true, false, false, 1.0);
      // setDefault().whenComplete(() {
      //   mgLog('set degault');
      // });
    } else {
      uiOption = option;
    }
  }

  Future<void> saveOption() async {
    //UIOption defaultOption = UIOption(true, false, false, 1.0);
    await uiSettingBox.put(uiSetBoxName, uiOption);
    mgLog("uioption saved");

    //UIOption? option = uiSettingBox.get('myOption');
  }

  ThemeData updateThemes(bool useLightMode) {
    return ThemeData(
        colorSchemeSeed: const Color(0xff6750a4),
        useMaterial3: true,
        brightness: useLightMode ? Brightness.light : Brightness.dark);
  }

  enumUIOption(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    var textScaleFactor = mediaQuery.textScaleFactor;
    Brightness brightness = mediaQuery.platformBrightness;

    // print("textScaleFactor $textScaleFactor");
    // print("brightness $brightness");

    late bool isCurLightMode;
    late bool isCurCupertino;
    //late double curTextScaleFactor;

    if (isUseSystemOption) {
      isCurLightMode = brightness == Brightness.light;

      if (kIsWeb == false) {
        if (Platform.isAndroid) {
          isCurCupertino = false;
        } else {
          isCurCupertino = true;
        }
      } else {
        isCurCupertino = false;
      }

      //curTextScaleFactor = textScaleFactor;

      uiOption.isLightMode = isCurLightMode;
      uiOption.isCupertinoUI = isCurCupertino;
      uiOption.customTextScaleFactor = textScaleFactor;
    } else {
      isCurLightMode = isLightMode;
      isCurCupertino = isCupertinoUI;
      //curTextScaleFactor = customTextScaleFactor;
    }
    if (isSetChange == true) {
      saveOption();
      isSetChange = false;
    }

    materialThemeData = updateThemes(isCurLightMode);
  }
}
