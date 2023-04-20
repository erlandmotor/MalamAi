// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ui_setting.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UIOptionAdapter extends TypeAdapter<UIOption> {
  @override
  final int typeId = 0;

  @override
  UIOption read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UIOption(
      fields[0] == null ? true : fields[0] as bool,
      fields[1] == null ? false : fields[1] as bool,
      fields[2] == null ? false : fields[2] as bool,
      fields[3] == null ? 1.0 : fields[3] as double,
    );
  }

  @override
  void write(BinaryWriter writer, UIOption obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.isUseSystemOption)
      ..writeByte(1)
      ..write(obj.isLightMode)
      ..writeByte(2)
      ..write(obj.isCupertinoUI)
      ..writeByte(3)
      ..write(obj.customTextScaleFactor);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UIOptionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
