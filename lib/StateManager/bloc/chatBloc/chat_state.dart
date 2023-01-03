import '../../../models/conversation.dart';
import '../../../models/user_profile.dart';

abstract class ChatState {
  final UserProfile userProfile;
  ChatState({
    required this.userProfile,
  });
}

class BackToWaitingChatState extends ChatState {
  BackToWaitingChatState({
    required UserProfile userProfile,
  }) : super(userProfile: userProfile);
}

class InitializeChatState extends ChatState {
  InitializeChatState({
    required UserProfile userProfile,
  }) : super(userProfile: userProfile);
}

class JoinedChatState extends ChatState {
  final Conversation conversation;
  JoinedChatState({
    required this.conversation,
    required super.userProfile,
  });
}

class WentToSettingMenuChatState extends ChatState {
  WentToSettingMenuChatState({required super.userProfile});
}

class WentToSearchChatState extends ChatState {
  WentToSearchChatState({required super.userProfile});
}
