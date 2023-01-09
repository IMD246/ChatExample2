import 'package:flutter/material.dart';
import 'package:flutter_basic_utilities/helper/loading/show_loading_parallel_screen.dart';
import 'package:flutter_basic_utilities/widgets/text_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import 'StateManager/bloc/authBloc/auth_bloc.dart';
import 'StateManager/bloc/authBloc/auth_state.dart';
import 'StateManager/provider/theme_provider.dart';
import 'extensions/localization.dart';
import 'views/conversation/conversation_screen.dart';
import 'views/welcome/login_screen.dart';

class HandleApp extends StatefulWidget {
  const HandleApp({super.key});

  @override
  State<HandleApp> createState() => _HandleAppState();
}

class _HandleAppState extends State<HandleApp> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final connectedInternet = Provider.of<bool>(context);
    final authBloc = context.read<AuthBloc>();
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateLoggedIn) {
          if (connectedInternet) {
            await authBloc.updateMessagingTokenUser();
            await authBloc.updatePresence();
          }
        }
        if (state.isLoading) {
          ShowLoadingParallelScreen().showLoading(
            context: context,
            isDarkMode:
                themeProvider.themeMode == ThemeMode.dark ? true : false,
            text: context.loc.please_wait_a_moment,
          );
        } else {
          ShowLoadingParallelScreen().hideLoading();
        }
      },
      builder: (context, state) {
        if (state is AuthStateLoggedOut || state is AuthStateLoading) {
          return const Scaffold(
            body: LoginScreen(),
          );
        } else if (state is AuthStateLoggedIn) {
          return ConversationScreen(
            userProfile: state.userProfile,
            urlUserProfile: state.urlImage,
          );
        } else {
          return Scaffold(
            body: textWidget(
              text: "Something went wrong",
            ),
          );
        }
      },
    );
  }
}
