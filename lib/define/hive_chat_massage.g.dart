// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hive_chat_massage.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HiveChatGroupAdapter extends TypeAdapter<HiveChatGroup> {
  @override
  final int typeId = 2;

  @override
  HiveChatGroup read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HiveChatGroup(
      fields[0] as String,
      (fields[1] as List).cast<ChatMessage>(),
    );
  }

  @override
  void write(BinaryWriter writer, HiveChatGroup obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.groupName)
      ..writeByte(1)
      ..write(obj.contens);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HiveChatGroupAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
