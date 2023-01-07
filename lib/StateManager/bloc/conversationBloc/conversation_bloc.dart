import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../../../models/conversation.dart';
import '../../../models/user_profile.dart';
import '../../../repositories/local_repository/local_conversation_repository.dart';
import '../../../repositories/remote_repository/remote_conversation_repository.dart';
import '../../../repositories/remote_repository/remote_storage_repository.dart';
import '../../../repositories/remote_repository/remote_user_presence_repository.dart';
import '../../../repositories/remote_repository/remote_user_profile_repository.dart';
import 'conversation_event.dart';
import 'conversation_state.dart';

class ConversationBloc extends Bloc<ConversationEvent, ConversationState> {
  final RemoteConversationRepository remoteConversationRepository;
  final RemoteUserProfileRepository remoteUserProfileRepository;
  final RemoteUserPresenceRepository remoteUserPresenceRepository;
  final RemoteStorageRepository remoteStorageRepository;
  final LocalConversationRepository localConversationRepository;
  final UserProfile userProfile;
  final String? urlUserProfile;
  final BehaviorSubject<Iterable<Conversation>?> _subjectConversations =
      BehaviorSubject();

  Stream<Iterable<Conversation>?> get streamConversations =>
      _subjectConversations.stream;

  Iterable<Conversation> conversations = [];

  ConversationBloc({
    required this.urlUserProfile,
    required this.userProfile,
    required this.remoteConversationRepository,
    required this.remoteUserProfileRepository,
    required this.remoteUserPresenceRepository,
    required this.remoteStorageRepository,
    required this.localConversationRepository,
  }) : super(
          InitializeConversationState(
            userProfile: userProfile,
          ),
        ) {
    on<InitializeConversationEvent>(
      (event, emit) async {
        await localConversationRepository.init();
        remoteConversationRepository
            .getConversationsByUserId(
          userId: userProfile.id!,
        )
            .listen(
          (event) async {
            _subjectConversations.add(event);
            conversations = event ?? [];
            await _handleConversationsBox(conversations: event);
          },
        );
        _subjectConversations.add(
          localConversationRepository.getConversations(),
        );
        emit(
          InitializeConversationState(
            userProfile: userProfile,
          ),
        );
      },
    );
  }

  Future<void> _handleConversationsBox({
    required Iterable<Conversation>? conversations,
  }) async {
    if (conversations != null) {
      for (var element in conversations) {
        await localConversationRepository.createConversation(
          conversation: element,
        );
      }
    }
  }

  @override
  Future<void> close() async {
    await _subjectConversations.drain();
    await _subjectConversations.close();
    return super.close();
  }
}
