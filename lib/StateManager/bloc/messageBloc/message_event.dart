import '../../../models/message.dart';

abstract class MessageEvent {}

class InitializingMessageEvent extends MessageEvent {
  InitializingMessageEvent();
}

class LeaveChatMessageEvent extends MessageEvent {
  final String chatID;
  final String userID;
  LeaveChatMessageEvent({
    required this.chatID,
    required this.userID,
  });
}

class SendTextMessageEvent extends MessageEvent {
  final String chatID;
  final Message message;
  SendTextMessageEvent({
    required this.chatID,
    required this.message,
  });
}
