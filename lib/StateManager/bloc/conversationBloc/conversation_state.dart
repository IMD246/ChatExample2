import '../../../models/conversation.dart';
import '../../../models/user_profile.dart';

abstract class ConversationState {
  final UserProfile userProfile;
  ConversationState({
    required this.userProfile,
  });
}

class InitializeConversationState extends ConversationState {
  final Stream<Iterable<Conversation>?> streamConversations;
  final String conversationsUserId;
  InitializeConversationState({
    required super.userProfile,
    required this.streamConversations,
    required this.conversationsUserId,
  });
}
