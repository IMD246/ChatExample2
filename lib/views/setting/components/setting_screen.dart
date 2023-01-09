import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../../../StateManager/bloc/settingBloc/setting_bloc.dart';
import '../../../StateManager/bloc/settingBloc/setting_event.dart';
import '../../../StateManager/bloc/settingBloc/setting_state.dart';
import '../../../StateManager/provider/storage_provider.dart';
import '../../../models/url_image.dart';
import '../../../models/user_profile.dart';
import '../../UpdateInfoSetting/update_info_setting_page.dart';
import 'components/body_setting_screen.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({
    super.key,
    required this.userProfile,
    required this.urlImage,
  });
  final UserProfile userProfile;
  final UrlImage urlImage;
  @override
  Widget build(BuildContext context) {
    final storageProvider = Provider.of<StorageProvider>(context);
    return BlocProvider<SettingBloc>(
      create: (context) => SettingBloc(
        userProfile: userProfile,
        remoteStorageRepository: storageProvider.remoteStorageRepository,
        urlImage: urlImage,
        localStorageRepository: storageProvider.localStorageRepository,
      ),
      child: BlocConsumer<SettingBloc, SettingState>(
        listener: (context, state) {
          if (state is InsideUpdateInfoState) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) {
                  return UpdateInfoSettingPage(
                    userProfile: state.userProfile,
                  );
                },
              ),
            ).then(
              (value) {
                var userInfo = state.userProfile;
                if (value != null) {
                  userInfo.fullName = value;
                }
                context.read<SettingBloc>().add(
                      BackToMenuSettingEvent(userProfile: userInfo),
                    );
              },
            );
          }
        },
        builder: (context, state) {
          return dynamicThemeScreen(
            state,
          );
        },
      ),
    );
  }

  Widget dynamicThemeScreen(SettingState state) {
    if (state is InsideSettingState) {
      return BodySettingScreen(
        userProfile: state.userProfile,
      );
    } else {
      return Scaffold(
        body: Container(),
      );
    }
  }
}
