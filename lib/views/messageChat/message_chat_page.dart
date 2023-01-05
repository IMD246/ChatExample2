import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../../StateManager/bloc/messageBloc/message_bloc.dart';
import '../../StateManager/bloc/messageBloc/message_state.dart';
import '../../StateManager/provider/conversation_provider.dart';
import '../../StateManager/provider/messages_provider.dart';
import '../../StateManager/provider/storage_provider.dart';
import '../../StateManager/provider/user_presence_provider.dart';
import '../../StateManager/provider/user_profile_provider.dart';
import '../../models/conversation.dart';
import '../../models/user_profile.dart';
import 'message_chat_screen.dart';

class MessageChatPage extends StatefulWidget {
  const MessageChatPage({
    Key? key,
    required this.ownerUserProfile,
    required this.conversation,
  }) : super(key: key);
  final UserProfile ownerUserProfile;
  final Conversation conversation;

  @override
  State<MessageChatPage> createState() => _MessageChatPageState();
}

class _MessageChatPageState extends State<MessageChatPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final configProvider = Provider.of<ConfigAppProvider>(context);
    final userProfileProvider = Provider.of<UserProfileProvider>(context);
    final userPresenceProvider = Provider.of<UserPresenceProvider>(context);
    final storageProvider = Provider.of<StorageProvider>(context);
    final messagesProvider = Provider.of<MessagesProvider>(context);
    final conversationProvider = Provider.of<ConversationProvider>(context);
    return BlocProvider<MessageBloc>(
      create: (context) => MessageBloc(
        conversation: widget.conversation,
        ownerUserProfile: widget.ownerUserProfile,
        remoteStorageRepository: storageProvider.remoteStorageRepository,
        remoteUserPresenceRepository:
            userPresenceProvider.remoteUserPresenceRepository,
        remoteUserProfileRepository:
            userProfileProvider.remoteUserProfileRepository,
        remoteMessagesRepository: messagesProvider.remoteMessagesRepository,
        remoteConversationRepository:
            conversationProvider.remoteConversationRepository,
      ),
      child: BlocConsumer<MessageBloc, MessageState>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state is InitializeMessageState) {
            return const MessageChatScreen();
          }
          return const Scaffold(
            body: Text(
              "This state is not build yet!",
            ),
          );
        },
      ),
    );
  }
}
