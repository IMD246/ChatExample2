import '../repositories/constants/messages_field_constants.dart';

class Message {
  String? id;
  final String senderId;
  final String chatId;
  final String? content;
  final List<String>? listNameImage;
  final String? nameRecord;
  final DateTime stampTime;
  final String typeMessage;
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
          : null,
      nameRecord: map[MessagesFieldConstants.nameRecordField] != null
          ? map[MessagesFieldConstants.nameRecordField] as String
          : null,
      stampTime: DateTime.parse(
        map[MessagesFieldConstants.stampTimeField],
      ),
      typeMessage: map[MessagesFieldConstants.typeMessageField] as String,
      messageStatus: map[MessagesFieldConstants.messageStatusField] as String,
    );
  }
}
