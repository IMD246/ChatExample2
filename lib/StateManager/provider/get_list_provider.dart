import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../../main.dart';
import '../../repositories/remote_repository/remote_conversation_repository.dart';
import '../../repositories/remote_repository/remote_messages_repository.dart';
import '../../repositories/remote_repository/remote_storage_repository.dart';
import '../../repositories/remote_repository/remote_user_presence_repository.dart';
import '../../repositories/remote_repository/remote_user_profile_repository.dart';
import '../../services/notification/connectivity_service.dart';
import 'config_app_provider.dart';
import 'conversation_provider.dart';
import 'language_provider.dart';
import 'messages_provider.dart';
import 'storage_provider.dart';
import 'theme_provider.dart';
import 'user_presence_provider.dart';
import 'user_profile_provider.dart';

List<SingleChildWidget> getListRepositoryProvider() {
  return [
    StreamProvider<bool>(
          create: (context) => ConnectivityService().subjectStatusConnection,
          initialData: false,
        ),
        ChangeNotifierProvider<ConfigAppProvider>(
          create: (context) => ConfigAppProvider(
            sharedPref: sharedPref,
            noti: noti,
            navigatorKey: GlobalKey<NavigatorState>(),
            deviceToken: deviceToken,
          ),
        ),
        ChangeNotifierProvider<ThemeProvider>(
          create: (context) => ThemeProvider(
            sharedPref: sharedPref,
          ),
        ),
        ChangeNotifierProvider<LanguageProvider>(
          create: (context) => LanguageProvider(
            sharedPref,
          ),
        ),
    ChangeNotifierProvider<UserProfileProvider>(
      create: (context) => UserProfileProvider(
        remoteUserProfileRepository: RemoteUserProfileRepository(),
      ),
    ),
    ChangeNotifierProvider<UserPresenceProvider>(
      create: (context) => UserPresenceProvider(
        remoteUserPresenceRepository: RemoteUserPresenceRepository(),
      ),
    ),
    ChangeNotifierProvider<StorageProvider>(
      create: (context) => StorageProvider(
        remoteStorageRepository: RemoteStorageRepository(),
      ),
    ),
    ChangeNotifierProvider<ConversationProvider>(
      create: (context) => ConversationProvider(
        remoteConversationRepository: RemoteConversationRepository(),
      ),
    ),
    ChangeNotifierProvider<MessagesProvider>(
      create: (context) => MessagesProvider(
        remoteMessagesRepository: RemoteMessagesRepository(),
      ),
    ),
  ];
}