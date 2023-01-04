import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../../StateManager/bloc/chatBloc/chat_bloc.dart';
import '../../StateManager/bloc/chatBloc/chat_event.dart';
import '../../StateManager/bloc/chatBloc/chat_state.dart';
import '../../StateManager/provider/config_app_provider.dart';
import '../../StateManager/provider/conversation_provider.dart';
import '../../StateManager/provider/storage_provider.dart';
import '../../StateManager/provider/user_presence_provider.dart';
import '../../StateManager/provider/user_profile_provider.dart';
import '../../models/user_profile.dart';
import '../../widget/animated_switcher_widget.dart';
import '../searchChat/search_chat_page.dart';
import '../setting/components/setting_screen.dart';
import 'components/body_conversation_screen.dart';

class ConversationScreen extends StatefulWidget {
  const ConversationScreen({
    Key? key,
    required this.userProfile,
  }) : super(key: key);
  final UserProfile userProfile;
  @override
  State<ConversationScreen> createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  int count = 0;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final configAppProvider = Provider.of<ConfigAppProvider>(context);
    final userProfileProvider = Provider.of<UserProfileProvider>(context);
    final userPresenceProvider = Provider.of<UserPresenceProvider>(context);
    final storageProvider = Provider.of<StorageProvider>(context);
    final conversationProvider = Provider.of<ConversationProvider>(context);
    return BlocProvider<ChatBloc>(
      create: (context) => ChatBloc(
        noti: configAppProvider.noti,
        userProfile: widget.userProfile,
        remoteConversationRepository:
            conversationProvider.remoteConversationRepository,
        remoteUserPresenceRepository:
            userPresenceProvider.remoteUserPresenceRepository,
        remoteUserProfileRepository:
            userProfileProvider.remoteUserProfileRepository,
        remoteStorageRepository: storageProvider.remoteStorageRepository,
      )..add(
          InitializeChatEvent(),
        ),
      child: BlocConsumer<ChatBloc, ChatState>(
        listener: (context, state) {
          // if (state is InitializeChatState) {
          //   configAppProvider.handlerNotification(
          //     context: context,
          //     userInformation: state.userProfile,
          //   );
          // }
          _listeningState(
            context: context,
            state: state,
          );
        },
        builder: (context, state) {
          return AnimatedSwitcherWidget(
            widget: dynamicScreen(state),
          );
        },
      ),
    );
  }

  Widget dynamicScreen(ChatState state) {
    if (state is BackToWaitingChatState || state is InitializeChatState) {
      return BodyConversationScreen(
        userProfile: state.userProfile,
      );
    } else {
      return const Scaffold();
    }
  }

  void _listeningState({
    required BuildContext context,
    required ChatState state,
  }) {
    // #region listenState methods
    if (state is JoinedChatState) {
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(
      //     builder: (context) {
      //       return MessageChatScreen(
      //         chatUserAndPresence: state.chatUserAndPresence,
      //         userInformation: state.chatManager.userInformation,
      //         socket: state.chatManager.socket,
      //       );
      //     },
      //     settings: RouteSettings(
      //         name: "chat:${state.chatUserAndPresence.chat?.sId ?? ""}"),
      //   ),
      // ).then((value) {
      //   context.read<ChatBloc>().add(
      //         BackToWaitingChatEvent(),
      //       );
      // });
    } else if (state is WentToSearchChatState) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {
            return SearchChatPage(
              ownerUserProfile: state.userProfile,
            );
          },
        ),
      ).then((value) {
        context.read<ChatBloc>().add(
              BackToWaitingChatEvent(),
            );
      });
    } else if (state is WentToSettingMenuChatState) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {
            return SettingScreen(
              userProfile: state.userProfile,
            );
          },
        ),
      ).then(
        (value) {
          context.read<ChatBloc>().add(
                BackToWaitingChatEvent(),
              );
        },
      );
    }
    // #endregion
  }
}
