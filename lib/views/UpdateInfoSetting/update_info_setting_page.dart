import 'package:flutter/material.dart';
import 'package:flutter_basic_utilities/helper/loading/show_loading_parallel_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../../StateManager/bloc/UpdateFullNameBloc/update_fullname_bloc.dart';
import '../../StateManager/bloc/UpdateFullNameBloc/update_fullname_state.dart';
import '../../StateManager/provider/theme_provider.dart';
import '../../StateManager/provider/user_profile_provider.dart';
import '../../extensions/localization.dart';
import '../../models/user_profile.dart';
import 'update_info_setting_screen.dart';

class UpdateInfoSettingPage extends StatelessWidget {
  const UpdateInfoSettingPage({
    Key? key,
    required this.userProfile,
  }) : super(key: key);
  final UserProfile userProfile;
  @override
  Widget build(BuildContext context) {
    final userProfileProvider = Provider.of<UserProfileProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    return BlocProvider<UpdateFullNameBloc>(
      create: (context) => UpdateFullNameBloc(
        remoteUserProfileRepository:
            userProfileProvider.remoteUserProfileRepository,
        userProfile: userProfile,
        context: context,
      ),
      child: BlocConsumer<UpdateFullNameBloc, UpdateFullNameState>(
        listener: (context, state) {
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
          if (state is IntializeUpdateFullNameState) {
            return UpdateInfoSettingScreen(
              userProfile: state.userProfile,
            );
          }
          return const Scaffold(
            body: Text("This state is not available!"),
          );
        },
      ),
    );
  }
}
