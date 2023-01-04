import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../../../enum/enum.dart';
import '../../../models/conversation.dart';
import '../../../models/user_profile.dart';
import '../../../repositories/remote_repository/remote_conversation_repository.dart';
import '../../../repositories/remote_repository/remote_storage_repository.dart';
import '../../../repositories/remote_repository/remote_user_presence_repository.dart';
import '../../../repositories/remote_repository/remote_user_profile_repository.dart';
import 'search_chat_event.dart';
import 'search_chat_state.dart';

class SearchChatBloc extends Bloc<SearchChatEvent, SearchChatState> {
  final RemoteStorageRepository remoteStorageRepository;
  final RemoteUserProfileRepository remoteUserProfileRepository;
  final RemoteUserPresenceRepository remoteUserPresenceRepository;
  final RemoteConversationRepository remoteConversationRepository;
  final UserProfile ownerUserProfile;

  ReplaySubject<List<UserProfile>?> subjectListUserProfileRecom =
      ReplaySubject<List<UserProfile>>();

  ReplaySubject<List<UserProfile>?> subjectListUserOutputSearch =
      ReplaySubject<List<UserProfile>>();
  String? searchText;
  SearchChatBloc({
    required this.remoteStorageRepository,
    required this.remoteUserProfileRepository,
    required this.remoteUserPresenceRepository,
    required this.ownerUserProfile,
    required this.remoteConversationRepository,
  }) : super(
          InitializeSearchChatState(
            behaviorSubject: ReplaySubject(),
          ),
        ) {
    on<InitializeSearchChatEvent>(
      (event, emit) async {
        try {
          final listUser = await remoteUserProfileRepository.getAllUserProfile(
            limit: 10,
          );
          subjectListUserProfileRecom.add(listUser);
          emit(
            SearchingSearchChatState(
              subjectListUserProfile: subjectListUserProfileRecom,
            ),
          );
        } catch (e) {
          log(e.toString());
          emit(
            SearchingSearchChatState(
              subjectListUserProfile: subjectListUserProfileRecom,
            ),
          );
        }
      },
    );
    on<SearchingSearchChatEvent>(
      (event, emit) async {
        try {
          searchText = event.searchText;
          if (event.searchText == null) {
            emit(
              SearchingSearchChatState(
                subjectListUserProfile: subjectListUserProfileRecom,
              ),
            );
          } else {
            final listUser =
                await remoteUserProfileRepository.getAllUserProfileBySearchText(
              searchText: searchText,
            );
            subjectListUserOutputSearch.add(listUser);
            emit(
              SearchingSearchChatState(
                subjectListUserProfile: subjectListUserOutputSearch,
              ),
            );
          }
        } catch (e) {
          log(
            e.toString(),
          );
          emit(
            SearchingSearchChatState(
              subjectListUserProfile: ReplaySubject(),
            ),
          );
        }
      },
    );
    on<GoToConversationRoomSearchChatEvent>(
      (event, emit) async {
        try {
          await remoteConversationRepository.createConversation(
            ownerUserId: event.ownerUserId,
            userId: event.userIdPicked,
            conversation: Conversation(
              typeMessage: TypeMessage.text.toString(),
              isActive: false,
              lastText: "Rất vui được làm quen",
              stampTime: DateTime.now(),
              stampTimeLastText: DateTime.now(),
              listUser: [
                event.ownerUserId,
                event.userIdPicked,
              ],
            ),
          );
          final conversation =
              await remoteConversationRepository.getConversationByListUserId(
            listUserId: [
              event.ownerUserId,
              event.userIdPicked,
            ],
          );
          if (conversation != null) {
            emit(
              GoToConversationRoomSearchChatState(
                userPresence: event.userPresence,
                conversation: conversation,
                searchText: event.searchText
              ),
            );
          } else {
            emit(
              SearchingSearchChatState(
                subjectListUserProfile: subjectListUserOutputSearch,
              ),
            );
          }
        } catch (e) {
          print(e.toString());
          emit(
            SearchingSearchChatState(
              subjectListUserProfile: subjectListUserOutputSearch,
            ),
          );
        }
      },
    );
  }
  @override
  Future<void> close() async {
    await subjectListUserOutputSearch.close();
    await subjectListUserProfileRecom.drain();
    await subjectListUserProfileRecom.close();
    await subjectListUserOutputSearch.drain();
    return super.close();
  }
}
