import '../../models/user_presence.dart';

abstract class UserPresenceRepository {
  Future<UserPresence?> getUserPresenceById({required String userID});

  Future<void> updatePresenceFieldById({required String userID});
}
