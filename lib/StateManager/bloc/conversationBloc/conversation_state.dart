import '../../../models/user_profile.dart';

abstract class ConversationState {
  final UserProfile userProfile;
  ConversationState({
    required this.userProfile,
  });
}

class InitializeConversationState extends ConversationState {
  InitializeConversationState({
    required super.userProfile,
  });
}
