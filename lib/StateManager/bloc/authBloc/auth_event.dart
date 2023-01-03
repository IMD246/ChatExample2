import '../../../models/user_profile.dart';

abstract class AuthEvent {}

class AuthEventLoginByGoogle extends AuthEvent {}

class AuthEventLogout extends AuthEvent {
  final UserProfile userProfile;
  AuthEventLogout({
    required this.userProfile,
  });
}

class AuthEventInitialize extends AuthEvent {}
