import '../../../models/conversation.dart';

abstract class ChatEvent {}

class JoinChatEvent extends ChatEvent {
  final Conversation conversation;
  JoinChatEvent({
    required this.conversation,
  });
}

class BackToWaitingChatEvent extends ChatEvent {
  BackToWaitingChatEvent();
}

class InitializeChatEvent extends ChatEvent {
  InitializeChatEvent();
}

class GoToSearchFriendChatEvent extends ChatEvent {
  GoToSearchFriendChatEvent();
}

class GoToMenuSettingEvent extends ChatEvent {
  GoToMenuSettingEvent();
}
