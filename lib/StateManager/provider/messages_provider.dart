import 'package:flutter/foundation.dart';

import '../../repositories/local_repository/local_messages_repository.dart';
import '../../repositories/remote_repository/remote_messages_repository.dart';

class MessagesProvider extends ChangeNotifier {
  final RemoteMessagesRepository remoteMessagesRepository;
  final LocalMessagesRepository localMessagesRepository;
  MessagesProvider({
    required this.remoteMessagesRepository,
    required this.localMessagesRepository
  });
}
