import 'package:firebase_auth/firebase_auth.dart';

import '../../models/user_profile.dart';

abstract class UserProfileRepository {
  Future<void> createUserProfile({required User? user});

  Stream<UserProfile?>? getUserProfileById({required String? userID});

  Future<UserProfile?>? getUserProfileByIdAsync({required String? userID});

  Future<List<UserProfile>?> getAllUserProfileBySearchText(
      {required String? searchText,});

  Future<List<UserProfile>?> getAllUserProfile({
    required int? limit
  });

  Future<bool> updateUserProfile(
    Map<String, dynamic> mapUserProfile,
    String uid,
  );
}
