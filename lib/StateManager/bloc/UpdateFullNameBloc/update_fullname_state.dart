// ignore_for_file: public_member_api_docs, sort_constructors_first
import '../../../models/user_profile.dart';

abstract class UpdateFullNameState {
  final bool isLoading;
  final String textLoading;
  UpdateFullNameState({
    required this.isLoading,
    this.textLoading = "Please wait a second!",
  });
}

class IntializeUpdateFullNameState extends UpdateFullNameState {
  final UserProfile userProfile;
  final Stream<String> firstNameStream;
  final Stream<String> lastNameStream;
  final Stream<bool> btnStream;
  IntializeUpdateFullNameState({
    required this.userProfile,
    required this.firstNameStream,
    required this.lastNameStream,
    required this.btnStream,
    required super.isLoading,
  });
}
