// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_presence.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserPresenceAdapter extends TypeAdapter<UserPresence> {
  @override
  final int typeId = 0;

  @override
  UserPresence read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserPresence(
      fields[0] as String?,
      fields[1] as DateTime,
      fields[2] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, UserPresence obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.stampTime)
      ..writeByte(2)
      ..write(obj.presence);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserPresenceAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
