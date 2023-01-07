import 'package:hive/hive.dart';

import '../repositories/constants/messages_field_constants.dart';

part 'message.g.dart';

@HiveType(typeId: 2)
class Message {
  @HiveField(0)
  String? id;
  @HiveField(1)
  final String senderId;
  @HiveField(2)
  final String chatId;
  @HiveField(3)
  final String? content;
  @HiveField(4)
  final List<String> listNameImage;
  @HiveField(5)
  final String? nameRecord;
  @HiveField(6)
  final DateTime stampTime;
  @HiveField(7)
  final String typeMessage;
  @HiveField(8)
  final String messageStatus;

  Message({
    required this.id,
    required this.senderId,
    required this.chatId,
    required this.content,
    required this.listNameImage,
    required this.nameRecord,
    required this.stampTime,
    required this.typeMessage,
    required this.messageStatus,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      MessagesFieldConstants.idField: id,
      MessagesFieldConstants.senderIdField: senderId,
      MessagesFieldConstants.chatIdField: chatId,
      MessagesFieldConstants.contentField: content,
      MessagesFieldConstants.listNameImageField: listNameImage,
      MessagesFieldConstants.nameRecordField: nameRecord,
      MessagesFieldConstants.stampTimeField: stampTime.millisecondsSinceEpoch,
      MessagesFieldConstants.typeMessageField: typeMessage,
      MessagesFieldConstants.messageStatusField: messageStatus,
    };
  }

  factory Message.fromMap(
    Map<String, dynamic> map,
    String id,
  ) {
    return Message(
      id: id,
      senderId: map[MessagesFieldConstants.senderIdField] as String,
      chatId: map[MessagesFieldConstants.chatIdField] as String,
      content: map[MessagesFieldConstants.contentField] != null
          ? map[MessagesFieldConstants.contentField] as String
          : null,
      listNameImage: map[MessagesFieldConstants.listNameImageField] != null
          ? List<String>.from(
              (map[MessagesFieldConstants.listNameImageField] as List),
            )
          : [],
      nameRecord: map[MessagesFieldConstants.nameRecordField] != null
          ? map[MessagesFieldConstants.nameRecordField] as String
          : null,
      stampTime: DateTime.fromMillisecondsSinceEpoch(
        map[MessagesFieldConstants.stampTimeField] as int,
      ),
      typeMessage: map[MessagesFieldConstants.typeMessageField] as String,
      messageStatus: map[MessagesFieldConstants.messageStatusField] as String,
    );
  }

  @override
  String toString() {
    return 'Message(id: $id, senderId: $senderId, chatId: $chatId, content: $content, listNameImage: $listNameImage, nameRecord: $nameRecord, stampTime: $stampTime, typeMessage: $typeMessage, messageStatus: $messageStatus)';
  }
}
