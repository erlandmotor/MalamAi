import 'package:hive_flutter/hive_flutter.dart';

part 'ui_setting.g.dart';

@HiveType(typeId: 0)
class UIOption {
  @HiveField(0, defaultValue: true)
  bool isUseSystemOption;

  @HiveField(1, defaultValue: false)
  bool isLightMode;

  @HiveField(2, defaultValue: false)
  bool isCupertinoUI;

  @HiveField(3, defaultValue: 1.0)
  double customTextScaleFactor;

  UIOption(this.isUseSystemOption, this.isLightMode, this.isCupertinoUI,
      this.customTextScaleFactor);
}
