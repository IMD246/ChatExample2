import 'package:flutter/foundation.dart';

import '../../repositories/remote_repository/remote_user_presence_repository.dart';

class UserPresenceProvider extends ChangeNotifier {
  final RemoteUserPresenceRepository remoteUserPresenceRepository;

  UserPresenceProvider({
    required this.remoteUserPresenceRepository,
  });
}
