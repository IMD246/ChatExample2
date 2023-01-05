import '../repositories/constants/conversation_field_constants.dart';

class Conversation {
  String? id;
  final DateTime stampTime;
  final DateTime stampTimeLastText;
  final String lastText;
  String? nameChat = "";
  bool isActive;
  final String typeMessage;
  List<String> listUser = [];

  Conversation({
    this.id,
    required this.typeMessage,
    required this.isActive,
    required this.lastText,
    this.nameChat,
    required this.stampTime,
    required this.stampTimeLastText,
    required this.listUser,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      ConversationFieldConstants.chatID: id,
      ConversationFieldConstants.stampTime: stampTime.millisecondsSinceEpoch,
      ConversationFieldConstants.stampTimeLastText:
          stampTimeLastText.millisecondsSinceEpoch,
      ConversationFieldConstants.lastText: lastText,
      ConversationFieldConstants.nameChat: nameChat,
      ConversationFieldConstants.isActive: isActive,
      ConversationFieldConstants.typeMessage: typeMessage,
      ConversationFieldConstants.listUser: listUser,
    };
  }

  factory Conversation.fromMap(Map<String, dynamic> map, String id) {
    return Conversation(
      id: id,
      stampTime: DateTime.fromMillisecondsSinceEpoch(
        map[ConversationFieldConstants.stampTime] as int,
      ),
      stampTimeLastText: DateTime.fromMillisecondsSinceEpoch(
        map[ConversationFieldConstants.stampTimeLastText] as int,
      ),
      lastText: map[ConversationFieldConstants.lastText] as String,
      nameChat: map[ConversationFieldConstants.nameChat] != null
          ? map['nameChat'] as String
          : null,
      isActive: map[ConversationFieldConstants.isActive] as bool,
      typeMessage: map[ConversationFieldConstants.typeMessage] as String,
      listUser: List<String>.from(
        map[ConversationFieldConstants.listUser] as List,
      ),
    );
  }

  Conversation copyWith({
    String? id,
    DateTime? stampTime,
    DateTime? stampTimeChat,
    String? lastText,
    String? nameChat,
    bool? isActive,
    String? typeMessage,
    List<String>? listUser,
  }) {
    return Conversation(
      id: id ?? this.id,
      stampTime: stampTime ?? this.stampTime,
      stampTimeLastText: stampTimeLastText,
      lastText: lastText ?? this.lastText,
      nameChat: nameChat ?? this.nameChat,
      isActive: isActive ?? this.isActive,
      typeMessage: typeMessage ?? this.typeMessage,
      listUser: listUser ?? this.listUser,
    );
  }

  @override
  String toString() {
    return 'Conversation(id: $id, stampTime: $stampTime, stampTimeLastText: $stampTimeLastText, lastText: $lastText, nameChat: $nameChat, isActive: $isActive, typeMessage: $typeMessage, listUser: $listUser)';
  }
}
