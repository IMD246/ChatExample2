import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../../StateManager/bloc/conversationBloc/conversation_bloc.dart';
import '../../StateManager/bloc/conversationBloc/conversation_event.dart';
import '../../StateManager/bloc/conversationBloc/conversation_state.dart';
import '../../StateManager/provider/conversation_provider.dart';
import '../../StateManager/provider/storage_provider.dart';
import '../../StateManager/provider/user_presence_provider.dart';
import '../../StateManager/provider/user_profile_provider.dart';
import '../../models/user_presence.dart';
import '../../models/user_profile.dart';
import '../../widget/animated_switcher_widget.dart';
import 'components/body_conversation_screen.dart';

class ConversationScreen extends StatefulWidget {
  const ConversationScreen({
    Key? key,
    required this.userProfile,
    required this.userPresence,
    required this.urlUserProfile,
  }) : super(key: key);
  final UserProfile userProfile;
  final UserPresence? userPresence;
  final String? urlUserProfile;
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
    final userProfileProvider = Provider.of<UserProfileProvider>(context);
    final userPresenceProvider = Provider.of<UserPresenceProvider>(context);
    final storageProvider = Provider.of<StorageProvider>(context);
    final conversationProvider = Provider.of<ConversationProvider>(context);
    return BlocProvider<ConversationBloc>(
      create: (context) => ConversationBloc(
        urlUserProfile: widget.urlUserProfile,
        userPresence: widget.userPresence,
        userProfile: widget.userProfile,
        remoteConversationRepository:
            conversationProvider.remoteConversationRepository,
        remoteUserPresenceRepository:
            userPresenceProvider.remoteUserPresenceRepository,
        remoteUserProfileRepository:
            userProfileProvider.remoteUserProfileRepository,
        remoteStorageRepository: storageProvider.remoteStorageRepository,
      )..add(
          InitializeConversationEvent(),
        ),
      child: BlocConsumer<ConversationBloc, ConversationState>(
        listener: (context, state) {
          // if (state is InitializeConversationState) {
          //   configAppProvider.handlerNotification(
          //     context: context,
          //     userInformation: state.userProfile,
          //   );
          // }
        },
        builder: (context, state) {
          return AnimatedSwitcherWidget(
            widget: dynamicScreen(state),
          );
        },
      ),
    );
  }

  Widget dynamicScreen(ConversationState state) {
    if (state is InitializeConversationState) {
      return BodyConversationScreen(
        userProfile: state.userProfile,
        urlUserProfile: state.urlUserProfile,
      );
    } else {
      return const Scaffold();
    }
  }
}
