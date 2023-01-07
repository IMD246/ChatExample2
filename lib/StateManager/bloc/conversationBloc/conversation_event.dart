import '../../../models/conversation.dart';

abstract class ConversationEvent {}

class JoinConversationEvent extends ConversationEvent {
  final Conversation conversation;
  JoinConversationEvent({
    required this.conversation,
  });
}

class InitializeConversationEvent extends ConversationEvent {
  InitializeConversationEvent();
}
