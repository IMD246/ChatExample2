import '../../../models/user_profile.dart';

abstract class MessageState {
  final UserProfile userprofile;
  MessageState({
    required this.userprofile,
  });
}

class InitializeMessageState extends MessageState {
  final Stream<String> streamText;
  InitializeMessageState({
    required super.userprofile,
    required this.streamText,
  });
}
