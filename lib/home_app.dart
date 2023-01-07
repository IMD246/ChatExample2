import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import 'StateManager/bloc/authBloc/auth_bloc.dart';
import 'StateManager/bloc/authBloc/auth_event.dart';
import 'StateManager/provider/config_app_provider.dart';
import 'StateManager/provider/language_provider.dart';
import 'StateManager/provider/storage_provider.dart';
import 'StateManager/provider/theme_provider.dart';
import 'StateManager/provider/user_presence_provider.dart';
import 'StateManager/provider/user_profile_provider.dart';
import 'app.dart';
import 'extensions/google_sign_in_extension.dart';
import 'theme/theme_data.dart';

class HomeApp extends StatefulWidget {
  const HomeApp({
    Key? key,
  }) : super(key: key);
  @override
  State<HomeApp> createState() => _HomeAppState();
}

class _HomeAppState extends State<HomeApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final value = Provider.of<ConfigAppProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final languageProvider = Provider.of<LanguageProvider>(context);
    final userProfileProvider = Provider.of<UserProfileProvider>(context);
    final userPresenceProvider = Provider.of<UserPresenceProvider>(context);
    final storageProvider = Provider.of<StorageProvider>(context);
    return BlocProvider<AuthBloc>(
      create: (context) => AuthBloc(
        googleSignInExtension: GoogleSignInExtension(),
        remoteStorageRepository: storageProvider.remoteStorageRepository,
        remoteUserPresenceRepository:
            userPresenceProvider.remoteUserPresenceRepository,
        remoteUserProfileRepository:
            userProfileProvider.remoteUserProfileRepository,
        tokenMessaging: value.deviceToken ?? "",
        localUserProfileRepository:
            userProfileProvider.localUserProfileRepository, sharedPreferences: value.sharedPref,
      )..add(
          AuthEventInitialize(),
        ),
      child: MaterialApp(
        navigatorKey: value.navigatorKey,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: languageProvider.locale,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        themeMode: themeProvider.themeMode,
        theme: lightThemeData(context),
        darkTheme: darkThemeData(context),
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        home: const App(),
      ),
    );
  }
}
