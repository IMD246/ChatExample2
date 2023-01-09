// ignore_for_file: public_member_api_docs, sort_constructors_first
import '../../../models/url_image.dart';
import '../../../models/user_profile.dart';

abstract class SettingState {
  final UserProfile userProfile;
  final UrlImage urlImage;
  SettingState({
    required this.userProfile,
    required this.urlImage, 
  });
}

class InsideSettingState extends SettingState {
  InsideSettingState({required super.userProfile,required super.urlImage});

}

class InsideUpdateInfoState extends SettingState {
  InsideUpdateInfoState({required super.userProfile,required super.urlImage});
 
}

class InsideSearchState extends SettingState {
  InsideSearchState({required super.userProfile,required super.urlImage});
}
