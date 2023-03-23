//import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//import 'package:flutter/widgets.dart';

class UIChangeNotifier with ChangeNotifier {
  bool isUseSystemSetting = true;
  bool isLightMode = false;
  bool isCupertinoUI = false;
  double customTextScaleFactor = 1.0;

  late ThemeData materialThemeData;
  //late CupertinoThemeData cupertinoTheme;

  UIChangeNotifier({this.isLightMode = true, this.isCupertinoUI = false}) {
    materialThemeData = updateThemes(isLightMode);
    // cupertinoTheme =
    //     MaterialBasedCupertinoThemeData(materialTheme: materialThemeData);
  }

  setLightMode(bool lightMode) {
    isLightMode = lightMode;
    materialThemeData = updateThemes(isLightMode);
    notifyListeners();
  }

  ThemeData updateThemes(bool useLightMode) {
    return ThemeData(
        colorSchemeSeed: const Color(0xff6750a4),
        useMaterial3: true,
        brightness: useLightMode ? Brightness.light : Brightness.dark);
  }
}
