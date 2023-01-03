import 'package:flutter/foundation.dart';

import '../../repositories/remote_repository/remote_user_profile_repository.dart';

class UserProfileProvider extends ChangeNotifier {
  final RemoteUserProfileRepository remoteUserProfileRepository;

  UserProfileProvider({
    required this.remoteUserProfileRepository,
  });
}
