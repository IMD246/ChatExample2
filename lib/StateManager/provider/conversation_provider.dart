import 'package:flutter/foundation.dart';

import '../../repositories/remote_repository/remote_conversation_repository.dart';


class ConversationProvider extends ChangeNotifier {
  final RemoteConversationRepository remoteConversationRepository;

  ConversationProvider({
    required this.remoteConversationRepository,
  });
}
