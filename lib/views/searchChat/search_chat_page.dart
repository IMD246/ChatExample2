import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../../StateManager/bloc/SearchChatBloc/search_chat_bloc.dart';
import '../../StateManager/bloc/SearchChatBloc/search_chat_event.dart';
import '../../StateManager/bloc/SearchChatBloc/search_chat_state.dart';
import '../../StateManager/provider/conversation_provider.dart';
import '../../StateManager/provider/storage_provider.dart';
import '../../StateManager/provider/user_presence_provider.dart';
import '../../StateManager/provider/user_profile_provider.dart';
import '../../helpers/navigation/helper_navigation.dart';
import '../../models/user_profile.dart';
import 'components/body_search_chat_screen.dart';

class SearchChatPage extends StatelessWidget {
  final UserProfile ownerUserProfile;
  const SearchChatPage({
    Key? key,
    required this.ownerUserProfile,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final storageProvider = Provider.of<StorageProvider>(context);
    final userProfileProvider = Provider.of<UserProfileProvider>(context);
    final userPresenceProvider = Provider.of<UserPresenceProvider>(context);
    final conversationProvider = Provider.of<ConversationProvider>(context);
    return BlocProvider<SearchChatBloc>(
      create: (context) => SearchChatBloc(
        remoteUserPresenceRepository:
            userPresenceProvider.remoteUserPresenceRepository,
        remoteStorageRepository: storageProvider.remoteStorageRepository,
        remoteUserProfileRepository:
            userProfileProvider.remoteUserProfileRepository,
        ownerUserProfile: ownerUserProfile,
        remoteConversationRepository:
            conversationProvider.remoteConversationRepository,
      )..add(
          InitializeSearchChatEvent(),
        ),
      child: Scaffold(
        body: BlocConsumer<SearchChatBloc, SearchChatState>(
          listener: (context, state) async {
            if (state is GoToConversationRoomSearchChatState) {
              HelperNavigation.push(
                context: context,
                widget: Scaffold(
                  body: Column(
                    children: [
                      Text(
                        state.conversation.toString(),
                      ),
                      Text(
                        state.userPresence.toString(),
                      ),
                    ],
                  ),
                ),
              ).then(
                (value) {
                  context.read<SearchChatBloc>().add(
                        SearchingSearchChatEvent(
                          searchText: state.searchText,
                        ),
                      );
                },
              );
              //   MesssageScreen(
              //  conversation: state.conversation,
              //  ownerUserProfile: ownerUserProfile,
              //  userPresence: state.userPresence,
              //   ),
              // ).then(
              //   (value) {
              //     context.read<SearchChatBloc>().add(
              //           SearchingSearchChatEvent(
              //             searchText: state.searchText,
              //           ),
              //         );
              //   },
              // );
            }
          },
          builder: (context, state) {
            if (state is InitializeSearchChatState) {
              return BodySearchChatScreen(
                userProfile: ownerUserProfile,
                valueStream: state.behaviorSubject.stream,
              );
            } else if (state is SearchingSearchChatState) {
              return BodySearchChatScreen(
                userProfile: ownerUserProfile,
                valueStream: state.subjectListUserProfile.stream,
              );
            } else {
              return const Text(
                "This state is not available!",
              );
            }
          },
        ),
      ),
    );
  }
}
