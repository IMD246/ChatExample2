import 'package:flutter/foundation.dart';

import '../../repositories/local_repository/local_user_profile_repository.dart';
import '../../repositories/remote_repository/remote_user_profile_repository.dart';

class UserProfileProvider extends ChangeNotifier {
  final RemoteUserProfileRepository remoteUserProfileRepository;
  final LocalUserProfileRepository localUserProfileRepository;

  UserProfileProvider({
    required this.remoteUserProfileRepository,
    required this.localUserProfileRepository,
  });
}
