import 'package:file_picker/file_picker.dart';

abstract class MessageEvent {}

class InitializingMessageEvent extends MessageEvent {
  InitializingMessageEvent();
}

class LeaveChatMessageEvent extends MessageEvent {
  final String chatID;
  final String userID;
  LeaveChatMessageEvent({
    required this.chatID,
    required this.userID,
  });
}

class SendTextMessageEvent extends MessageEvent {
  final String content;
  SendTextMessageEvent({
    required this.content,
  });
}

class SendLikeMessageEvent extends MessageEvent {
  SendLikeMessageEvent();
}

class SendImageMessageEvent extends MessageEvent {
  final FilePickerResult result;
  SendImageMessageEvent({
    required this.result,
  });
}

class UpdateContentTextEvent extends MessageEvent {
  final String value;
  UpdateContentTextEvent({
    required this.value,
  });
}
