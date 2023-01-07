import 'package:flutter/material.dart';
import 'package:flutter_basic_utilities/widgets/text_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../StateManager/bloc/authBloc/auth_bloc.dart';
import '../../../../StateManager/bloc/authBloc/auth_event.dart';
import '../../../../StateManager/bloc/settingBloc/setting_bloc.dart';
import '../../../../StateManager/bloc/settingBloc/setting_event.dart';
import '../../../../extensions/localization.dart';
import '../../../../models/user_profile.dart';
import 'dark_mode_switch.dart';
import 'image_and_name.dart';
import 'languages_setting.dart';
import 'setting_item_menu_button.dart';

class BodySettingScreen extends StatelessWidget {
  const BodySettingScreen({
    Key? key,
    required this.userProfile,
  }) : super(key: key);

  final UserProfile userProfile;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor.withOpacity(0.8),
        leading: BackButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: textWidget(
          text: context.loc.me,
          size: 20.h,
        ),
      ),
      body: Column(
        children: [
          ImageAndName(
            userProfile: userProfile,
          ),
          const DarkModeSwitch(),
          SizedBox(height: 8.h),
          const LanguageSetting(),
          SizedBox(height: 16.h),
          SettingItemMenuButton(
            text: context.loc.logout,
            press: () {
              context.read<AuthBloc>().add(
                    AuthEventLogout(
                      userProfile: userProfile,
                    ),
                  );

              if (context.read<AuthBloc>().firebaseAuthProvider.currentUser ==
                  null) {
                Navigator.of(context).pop();
              }
            },
          ),
          SizedBox(height: 16.h),
          SettingItemMenuButton(
            text: context.loc.update_information,
            press: () {
              context.read<SettingBloc>().add(
                    GoToUpdateInfoSettingEvent(),
                  );
            },
          ),
        ],
      ),
    );
  }
}
