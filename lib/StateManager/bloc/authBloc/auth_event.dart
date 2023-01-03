import '../../../models/user_presence.dart';
import '../../../models/user_profile.dart';

abstract class AuthEvent {}

class AuthEventLoginByGoogle extends AuthEvent {}

class AuthEventLogout extends AuthEvent {
  final UserProfile userProfile;
  final UserPresence userPresence;
  AuthEventLogout({
    required this.userProfile,
    required this.userPresence,
  });
}

class AuthEventInitialize extends AuthEvent {}
