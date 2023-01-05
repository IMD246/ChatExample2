import '../../models/message.dart';

abstract class MessagesRepository {
  Stream<Iterable<Message>?> getMessagesByChatId({
    required String chatId,
  });
  Future<void> createMessage({
    required String conversationId,
    required Message message,
  });
}
