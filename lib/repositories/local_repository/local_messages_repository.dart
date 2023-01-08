import 'package:hive/hive.dart';

import '../../models/message.dart';

class LocalMessagesRepository {
  late Box<Message> _messageBox;
  Future<void> init({required String conversationId}) async {
    if (!Hive.isAdapterRegistered(MessageAdapter().typeId)) {
      Hive.registerAdapter(MessageAdapter());
    }
    _messageBox = await Hive.openBox('messages:$conversationId');
  }

  Future<void> createMessage({
    required Message message,
  }) async {
    if (_messageBox.isOpen) {
      if (!_messageBox.containsKey(message.id)) {
        await _messageBox.put(
          message.id,
          message,
        );
      }
    }
  }

  Iterable<Message>? getMessages() {
    if (_messageBox.isOpen) {
      return _messageBox.values;
    }
    return null;
  }
}
