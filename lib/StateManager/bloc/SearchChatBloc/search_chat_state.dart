// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:rxdart/rxdart.dart';

import '../../../models/conversation.dart';
import '../../../models/user_presence.dart';
import '../../../models/user_profile.dart';

abstract class SearchChatState {}

class InitializeSearchChatState extends SearchChatState {
  final ReplaySubject<List<UserProfile>?> behaviorSubject;
  InitializeSearchChatState({
    required this.behaviorSubject,
  });
}

class SearchingSearchChatState extends SearchChatState {
  ReplaySubject<List<UserProfile>?> subjectListUserProfile;
  SearchingSearchChatState({
    required this.subjectListUserProfile,
  });
}

class GoToConversationRoomSearchChatState extends SearchChatState {
  final Conversation conversation;
  final UserPresence? userPresence;
  final String? searchText;
  GoToConversationRoomSearchChatState({
    required this.conversation,
    required this.userPresence,
    required this.searchText,
  });
}
