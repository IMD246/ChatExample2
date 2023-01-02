import '../../models/user_presence.dart';
import '../interface_repository/user_presence_repository.dart';

class LocalUserPresenceRepository implements UserPresenceRepository {
  @override
  Future<UserPresence> getUserPresenceById({required String userID}) {
    // TODO: implement getUserPresenceById
    throw UnimplementedError();
  }

  @override
  Future<void> updatePresenceFieldById({required String userID}) {
    // TODO: implement updatePresenceFieldById
    throw UnimplementedError();
  }
  
}