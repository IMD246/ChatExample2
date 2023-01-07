import '../../../models/user_presence.dart';
import '../../../models/user_profile.dart';

abstract class ConversationState {
  final UserProfile userProfile;
  final UserPresence? userPresence;
  final String? urlUserProfile;
  ConversationState({
    required this.userProfile,
    required this.userPresence,
    required this.urlUserProfile,
  });
}

class InitializeConversationState extends ConversationState {
  InitializeConversationState({
    required super.userProfile,
    required super.userPresence,
    required super.urlUserProfile,
  });
}
