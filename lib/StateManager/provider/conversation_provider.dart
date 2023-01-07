import 'package:flutter/foundation.dart';

import '../../repositories/local_repository/local_conversation_repository.dart';
import '../../repositories/remote_repository/remote_conversation_repository.dart';


class ConversationProvider extends ChangeNotifier {
  final RemoteConversationRepository remoteConversationRepository;
  final LocalConversationRepository localConversationRepository;

  ConversationProvider({
    required this.remoteConversationRepository,
    required this.localConversationRepository, 
  });
}
