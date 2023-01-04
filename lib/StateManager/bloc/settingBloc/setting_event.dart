// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:file_picker/file_picker.dart';

import '../../../models/user_profile.dart';

abstract class SettingEvent {}

class BackToMenuSettingEvent extends SettingEvent {
  final UserProfile userProfile;
  BackToMenuSettingEvent({
    required this.userProfile,
  });
}

class GoToUpdateInfoSettingEvent extends SettingEvent {}

class GoToUpdateThemeModeSettingEvent extends SettingEvent {}

class UpdateImageSettingEvent extends SettingEvent {
  final FilePickerResult filePickerResult;
  UpdateImageSettingEvent({
    required this.filePickerResult,
  });
}
