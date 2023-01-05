import 'package:flutter/foundation.dart';

import '../../repositories/remote_repository/remote_messages_repository.dart';

class MessagesProvider extends ChangeNotifier {
  final RemoteMessagesRepository remoteMessagesRepository;
  MessagesProvider({
    required this.remoteMessagesRepository,
  });
}
