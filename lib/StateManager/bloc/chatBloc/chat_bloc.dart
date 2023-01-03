import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../models/user_profile.dart';
import '../../../repositories/remote_repository/remote_conversation_repository.dart';
import '../../../repositories/remote_repository/remote_storage_repository.dart';
import '../../../repositories/remote_repository/remote_user_presence_repository.dart';
import '../../../repositories/remote_repository/remote_user_profile_repository.dart';
import '../../../services/notification/notification.dart';
import 'chat_event.dart';
import 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final NotificationService noti;
  final RemoteConversationRepository remoteConversationRepository;
  final RemoteUserProfileRepository remoteUserProfileRepository;
  final RemoteUserPresenceRepository remoteUserPresenceRepository;
  final RemoteStorageRepository remoteStorageRepository;
  final UserProfile userProfile;

  ChatBloc({
    required this.userProfile,
    required this.noti,
    required this.remoteConversationRepository,
    required this.remoteUserProfileRepository,
    required this.remoteUserPresenceRepository,
    required this.remoteStorageRepository,
  }) : super(
          InitializeChatState(userProfile: userProfile),
        ) {
    on<GoToMenuSettingEvent>(
      (event, emit) {
        emit(
          WentToSettingMenuChatState(userProfile: userProfile),
        );
      },
    );
    on<GoToSearchFriendChatEvent>(
      (event, emit) {
        emit(
          WentToSearchChatState(userProfile: userProfile),
        );
      },
    );
    on<BackToWaitingChatEvent>(
      (event, emit) {
        emit(
          BackToWaitingChatState(userProfile: userProfile),
        );
      },
    );
    on<InitializeChatEvent>((event, emit) async {
      emit(
        InitializeChatState(userProfile: userProfile),
      );
    });
    on<JoinChatEvent>(
      (event, emit) {
        emit(
          JoinedChatState(
            conversation: event.conversation,
            userProfile: userProfile,
          ),
        );
      },
    );
  }
  @override
  Future<void> close() {
    return super.close();
  }
}
