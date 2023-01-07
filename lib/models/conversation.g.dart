// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'conversation.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ConversationAdapter extends TypeAdapter<Conversation> {
  @override
  final int typeId = 1;

  @override
  Conversation read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Conversation(
      id: fields[0] as String?,
      typeMessage: fields[6] as String,
      isActive: fields[5] as bool,
      lastText: fields[3] as String,
      nameChat: fields[4] as String?,
      stampTime: fields[1] as DateTime,
      stampTimeLastText: fields[2] as DateTime,
      listUser: (fields[7] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, Conversation obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.stampTime)
      ..writeByte(2)
      ..write(obj.stampTimeLastText)
      ..writeByte(3)
      ..write(obj.lastText)
      ..writeByte(4)
      ..write(obj.nameChat)
      ..writeByte(5)
      ..write(obj.isActive)
      ..writeByte(6)
      ..write(obj.typeMessage)
      ..writeByte(7)
      ..write(obj.listUser);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ConversationAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
