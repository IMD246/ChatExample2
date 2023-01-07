import 'package:hive/hive.dart';

import '../../models/conversation.dart';

class LocalConversationRepository {
  late Box<Conversation> _conversationBox;
  Future<void> init() async {
    if (!Hive.isAdapterRegistered(ConversationAdapter().typeId)) {
      Hive.registerAdapter(ConversationAdapter());
    }
    _conversationBox = await Hive.openBox('conversations');
  }

  Future<void> createConversation({
    required Conversation conversation,
  }) async {
    if (_conversationBox.isOpen) {
      if (!_conversationBox.containsKey(conversation.id)) {
        await _conversationBox.put(
          conversation.id,
          conversation,
        );
      }
    }
  }
  Iterable<Conversation>? getConversations() {
    if (_conversationBox.isOpen) {
      return _conversationBox.values;
    }
    return null;
  }

  Conversation? getConversation({required String key}) {
    if (!_conversationBox.isOpen) {
      return null;
    }
    return _conversationBox.get(key);
  }
}
