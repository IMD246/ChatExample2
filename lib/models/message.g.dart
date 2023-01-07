// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MessageAdapter extends TypeAdapter<Message> {
  @override
  final int typeId = 2;

  @override
  Message read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Message(
      id: fields[0] as String?,
      senderId: fields[1] as String,
      chatId: fields[2] as String,
      content: fields[3] as String?,
      listNameImage: (fields[4] as List).cast<String>(),
      nameRecord: fields[5] as String?,
      stampTime: fields[6] as DateTime,
      typeMessage: fields[7] as String,
      messageStatus: fields[8] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Message obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.senderId)
      ..writeByte(2)
      ..write(obj.chatId)
      ..writeByte(3)
      ..write(obj.content)
      ..writeByte(4)
      ..write(obj.listNameImage)
      ..writeByte(5)
      ..write(obj.nameRecord)
      ..writeByte(6)
      ..write(obj.stampTime)
      ..writeByte(7)
      ..write(obj.typeMessage)
      ..writeByte(8)
      ..write(obj.messageStatus);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MessageAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
