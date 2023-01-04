import 'package:flutter/material.dart';
import 'package:flutter_basic_utilities/widgets/text_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../StateManager/bloc/UpdateFullNameBloc/update_fullname_bloc.dart';
import '../../extensions/localization.dart';
import '../../models/user_profile.dart';
import 'body_update_info_setting.dart';

class UpdateInfoSettingScreen extends StatelessWidget {
  const UpdateInfoSettingScreen({
    super.key,
    required this.userProfile,
  });
  final UserProfile userProfile;
  @override
  Widget build(BuildContext context) {
    final updateFullNameBloc = context.read<UpdateFullNameBloc>();
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () {
            Navigator.of(context).pop(
              updateFullNameBloc.userProfile.fullName,
            );
          },
        ),
        title: textWidget(
          text: context.loc.update_information,
        ),
        centerTitle: true,
      ),
      body: BodyUpdateInfoSetting(
        userProfile: userProfile,
      ),
    );
  }
}
