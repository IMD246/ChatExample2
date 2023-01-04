import '../../../models/user_presence.dart';

abstract class SearchChatEvent {
  SearchChatEvent();
}

class InitializeSearchChatEvent extends SearchChatEvent {
  InitializeSearchChatEvent();
}

class SearchingSearchChatEvent extends SearchChatEvent {
  final String? searchText;
  SearchingSearchChatEvent({
    this.searchText,
  });
}

class GoToConversationRoomSearchChatEvent extends SearchChatEvent {
  final String ownerUserId;
  final String userIdPicked;
  final UserPresence? userPresence;
  final String? searchText;
  GoToConversationRoomSearchChatEvent({
    required this.ownerUserId,
    required this.userIdPicked,
    required this.userPresence,
    required this.searchText,
  });
}
