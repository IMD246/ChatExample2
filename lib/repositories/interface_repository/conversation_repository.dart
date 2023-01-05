import '../../models/conversation.dart';

abstract class ConversationRepository {
  Stream<Iterable<Conversation>?> getConversationsByUserId({
    required String userId,
  });
  Future<void> createConversation({
    required List<String> listUserIdConversation,
    required Conversation conversation,
  });
  Future<Conversation?> getConversationByListUserId({
    required List<String> listUserId
  });
}
