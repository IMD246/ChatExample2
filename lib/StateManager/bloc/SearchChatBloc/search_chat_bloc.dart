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
              ownerUserProfile: ownerUserProfile),
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
                ownerUserProfile: ownerUserProfile),
          );
        } catch (e) {
          log(e.toString());
          emit(
            SearchingSearchChatState(
                subjectListUserProfile: subjectListUserProfileRecom,
                ownerUserProfile: ownerUserProfile),
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
                  ownerUserProfile: ownerUserProfile),
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
                  ownerUserProfile: ownerUserProfile),
            );
          }
        } catch (e) {
          log(
            e.toString(),
          );
          emit(
            SearchingSearchChatState(
                subjectListUserProfile: ReplaySubject(),
                ownerUserProfile: ownerUserProfile),
          );
        }
      },
    );
    on<GoToConversationRoomSearchChatEvent>(
      (event, emit) async {
        try {
          await remoteConversationRepository.createConversation(
            listUserIdConversation: event.listUserId,
            conversation: Conversation(
              typeMessage: TypeMessage.text.toString(),
              isActive: false,
              lastText: "Rất vui được làm quen",
              stampTime: DateTime.now(),
              stampTimeLastText: DateTime.now(),
              listUser: event.listUserId,
            ),
          );
          final conversation =
              await remoteConversationRepository.getConversationByListUserId(
            listUserId: event.listUserId,
          );
          if (conversation != null) {
            emit(
              GoToConversationRoomSearchChatState(
                  conversation: conversation,
                  searchText: event.searchText,
                  ownerUserProfile: ownerUserProfile),
            );
          } else {
            emit(
              SearchingSearchChatState(
                  subjectListUserProfile: subjectListUserOutputSearch,
                  ownerUserProfile: ownerUserProfile),
            );
          }
        } catch (e) {
          log(e.toString());
          emit(
            SearchingSearchChatState(
                subjectListUserProfile: subjectListUserOutputSearch,
                ownerUserProfile: ownerUserProfile),
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
