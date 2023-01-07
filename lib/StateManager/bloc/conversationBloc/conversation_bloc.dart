import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:rxdart/rxdart.dart';

import '../../../models/conversation.dart';
import '../../../models/user_presence.dart';
import '../../../models/user_profile.dart';
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
  final UserProfile userProfile;
  final UserPresence? userPresence;
  final String? urlUserProfile;
  final BehaviorSubject<Iterable<Conversation>?> _subjectConversations =
      BehaviorSubject();

  Stream<Iterable<Conversation>?> get streamConversations =>
      _subjectConversations.stream;

  Iterable<Conversation> conversations = [];

  late Box<Conversation> _conversationBox;

  ConversationBloc({
    required this.userPresence,
    required this.urlUserProfile,
    required this.userProfile,
    required this.remoteConversationRepository,
    required this.remoteUserProfileRepository,
    required this.remoteUserPresenceRepository,
    required this.remoteStorageRepository,
  }) : super(
          InitializeConversationState(
            userProfile: userProfile,
            urlUserProfile: urlUserProfile,
            userPresence: userPresence,
          ),
        ) {
    _subjectConversations.listen(
      (value) {
        conversations = value ?? [];
      },
    );
    on<InitializeConversationEvent>(
      (event, emit) async {
        await _init();
        // _subjectConversations.add(
        //   _conversationBox.values,
        // );
        remoteConversationRepository
            .getConversationsByUserId(
          userId: userProfile.id!,
        )
            .listen(
          (event) async {
            _subjectConversations.add(event);
            await _handleConversationsBox(conversations: event);
          },
        );
        emit(
          InitializeConversationState(
            userProfile: userProfile,
            urlUserProfile: urlUserProfile,
            userPresence: userPresence,
          ),
        );
      },
    );
  }
  Future<void> _init() async {
    if (!Hive.isAdapterRegistered(ConversationAdapter().typeId)) {
      Hive.registerAdapter(ConversationAdapter());
    }
    _conversationBox = await Hive.openBox('conversations:${userProfile.id}');
  }

  Future<void> _handleConversationsBox({
    required Iterable<Conversation>? conversations,
  }) async {
    if (conversations != null) {
      for (var element in conversations) {
        if (_conversationBox.containsKey(
              element.id!,
            ) ==
            false) {
          await _conversationBox.put(
            element.id,
            element,
          );
        }
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
