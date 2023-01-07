import '../../models/message.dart';

abstract class MessagesRepository {
  Stream<Iterable<Message>?> getMessagesByConversationId({
    required String conversationId,
  });
  Future<void> createMessage({
    required String conversationId,
    required Message message,
  });
}
