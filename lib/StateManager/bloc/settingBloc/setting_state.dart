// ignore_for_file: public_member_api_docs, sort_constructors_first
import '../../../models/user_profile.dart';

abstract class SettingState {
  final UserProfile userProfile;
  SettingState({
    required this.userProfile,
  });
}

class InsideSettingState extends SettingState {
  InsideSettingState({required super.userProfile});

}

class InsideUpdateInfoState extends SettingState {
  InsideUpdateInfoState({required super.userProfile});
 
}

class InsideSearchState extends SettingState {
  InsideSearchState({required super.userProfile});
}
