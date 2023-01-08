// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:rxdart/rxdart.dart';

import '../../../models/conversation.dart';
import '../../../models/user_presence.dart';
import '../../../models/user_profile.dart';

abstract class SearchChatState {
  final UserProfile ownerUserProfile;
  SearchChatState({
    required this.ownerUserProfile,
  });
}

class InitializeSearchChatState extends SearchChatState {
  final ReplaySubject<List<UserProfile>?> behaviorSubject;
  InitializeSearchChatState({
    required this.behaviorSubject,
    required super.ownerUserProfile
  });
}

class SearchingSearchChatState extends SearchChatState {
  ReplaySubject<List<UserProfile>?> subjectListUserProfile;
  SearchingSearchChatState({
    required this.subjectListUserProfile,
    required super.ownerUserProfile
  });
}

class GoToConversationRoomSearchChatState extends SearchChatState {
  final Conversation conversation;
  final String? searchText;
  GoToConversationRoomSearchChatState({
    required this.conversation,
    required this.searchText,
    required super.ownerUserProfile,
  });
}
