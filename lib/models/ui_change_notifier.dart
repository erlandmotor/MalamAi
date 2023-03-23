import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class UIChangeNotifier with ChangeNotifier {
  bool isUseSystemOption = true;
  bool isLightMode = false;
  bool isCupertinoUI = false;
  double customTextScaleFactor = 1.0;

  late ThemeData materialThemeData;

  UIChangeNotifier({this.isLightMode = true, this.isCupertinoUI = false}) {
    materialThemeData = updateThemes(isLightMode);
  }

  ThemeData updateThemes(bool useLightMode) {
    return ThemeData(
        colorSchemeSeed: const Color(0xff6750a4),
        useMaterial3: true,
        brightness: useLightMode ? Brightness.light : Brightness.dark);
  }

  setLightMode(bool lightMode) {
    isLightMode = lightMode;
    //materialThemeData = updateThemes(isLightMode);
    notifyListeners();
  }

  setTextScaleFactor(double argCustomTextScaleFactor) {
    customTextScaleFactor = argCustomTextScaleFactor;
    notifyListeners();
  }

  setSystemOption(bool systemOption) {
    isUseSystemOption = systemOption;
    notifyListeners();
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

      isLightMode = isCurLightMode;
      isCupertinoUI = isCurCupertino;
      customTextScaleFactor = textScaleFactor;
    } else {
      isCurLightMode = isLightMode;
      isCurCupertino = isCupertinoUI;
      //curTextScaleFactor = customTextScaleFactor;
    }

    materialThemeData = updateThemes(isCurLightMode);
  }
}
