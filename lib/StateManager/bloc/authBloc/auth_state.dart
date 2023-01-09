import '../../../models/url_image.dart';
import '../../../models/user_profile.dart';

abstract class AuthState {
  final bool isLoading;
  final String textLoading;
  AuthState({
    required this.isLoading,
    this.textLoading = "Please wait a second!",
  });
}

class AuthStateLoading extends AuthState {
  AuthStateLoading({
    required super.isLoading,
  });
}

class AuthStateLoggedOut extends AuthState {
  AuthStateLoggedOut({
    required super.isLoading,
  });
}

class AuthStateLoggedIn extends AuthState {
  final UserProfile userProfile;
  final UrlImage urlImage;
  AuthStateLoggedIn({
    required this.userProfile,
    required this.urlImage,
    required super.isLoading,
  });
}
