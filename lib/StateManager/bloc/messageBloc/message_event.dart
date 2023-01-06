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

class SendAudioMessageEvent extends MessageEvent {
  SendAudioMessageEvent();
}

class UpdateContentTextEvent extends MessageEvent {
  final String value;
  UpdateContentTextEvent({
    required this.value,
  });
}

class OpenRecorderEvent extends MessageEvent {
  OpenRecorderEvent();
}

class DeleteRecorderEvent extends MessageEvent {
  DeleteRecorderEvent();
}

class PauseRecorderEvent extends MessageEvent {
  PauseRecorderEvent();
}

class ResumeRecorderEvent extends MessageEvent {
  ResumeRecorderEvent();
}
