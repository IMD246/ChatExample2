import '../../models/conversation.dart';

abstract class ConversationRepository {
  Future<List<Conversation>?> getConversationsByUserId({
    required String userId,
  });
  Future<void> createConversation({
    required String ownerUserId,
    required String userId,
    required Conversation conversation,
  });
  Future<Conversation?> getConversationByListUserId({
    required List<String> listUserId
  });
}
