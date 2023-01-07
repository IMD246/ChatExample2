import 'package:flutter/material.dart';
import 'package:flutter_basic_utilities/flutter_basic_utilities.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import 'StateManager/bloc/authBloc/auth_bloc.dart';
import 'StateManager/bloc/authBloc/auth_state.dart';
import 'StateManager/provider/theme_provider.dart';
import 'extensions/localization.dart';
import 'views/conversation/conversation_screen.dart';
import 'views/welcome/login_screen.dart';

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = getDeviceSize(context: context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final connectedInternet = Provider.of<bool>(context);
    final authBloc = context.read<AuthBloc>();
    return ScreenUtilInit(
      designSize: size,
      splitScreenMode: true,
      minTextAdapt: true,
      builder: (context, child) {
        return BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) async {
            if (state is AuthStateLoggedIn) {
              if (connectedInternet) {
                await authBloc.updateMessagingTokenUser();
                await authBloc.updatePresence();
              }
            }
            if (state.isLoading) {
              ShowLoadingParallelScreen().showLoadingWithoutParralel(
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
                urlUserProfile: state.urlUserProfile,
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
      },
    );
  }
}
