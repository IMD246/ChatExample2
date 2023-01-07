import 'package:hive/hive.dart';

import '../../models/user_profile.dart';

class LocalUserProfileRepository {
  late Box<UserProfile> _userProfileBox;
  LocalUserProfileRepository() {
    init();
  }
  Future<void> init() async {
    if (!Hive.isAdapterRegistered(UserProfileAdapter().typeId)) {
      Hive.registerAdapter(UserProfileAdapter());
    }
    _userProfileBox = await Hive.openBox('userProfile');
  }

  Future<void> createUserProfile({
    required UserProfile userProfile,
  }) async {
    if (_userProfileBox.isOpen) {
      if (!_userProfileBox.containsKey(userProfile.id)) {
        await _userProfileBox.put(
          userProfile.id,
          userProfile,
        );
      }
    }
  }

  Future<void> setUserProfile({
    required UserProfile userProfile,
  }) async {
    if (_userProfileBox.isOpen) {
      await _userProfileBox.put(
        userProfile.id,
        userProfile,
      );
    }
  }

  Iterable<UserProfile>? getUserProfiles() {
    if (_userProfileBox.isOpen) {
      return _userProfileBox.values;
    }
    return null;
  }

  UserProfile? getUserProfile({required String key}) {
    if (!_userProfileBox.isOpen) {
      return null;
    }
    return _userProfileBox.get(key);
  }
}
