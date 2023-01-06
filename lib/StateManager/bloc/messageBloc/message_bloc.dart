import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rxdart/rxdart.dart';
import 'package:uuid/uuid.dart';

import '../../../enum/enum.dart';
import '../../../models/conversation.dart';
import '../../../models/message.dart';
import '../../../models/user_profile.dart';
import '../../../repositories/constants/conversation_field_constants.dart';
import '../../../repositories/remote_repository/remote_conversation_repository.dart';
import '../../../repositories/remote_repository/remote_messages_repository.dart';
import '../../../repositories/remote_repository/remote_storage_repository.dart';
import '../../../repositories/remote_repository/remote_user_presence_repository.dart';
import '../../../repositories/remote_repository/remote_user_profile_repository.dart';
import '../../../services/fcm/fcm_handler.dart';
import '../../../utilities/handle_value.dart';
import 'message_event.dart';
import 'message_state.dart';

class MessageBloc extends Bloc<MessageEvent, MessageState> {
  final Conversation conversation;
  final UserProfile ownerUserProfile;
  final RemoteUserProfileRepository remoteUserProfileRepository;
  final RemoteStorageRepository remoteStorageRepository;
  final RemoteUserPresenceRepository remoteUserPresenceRepository;
  final RemoteMessagesRepository remoteMessagesRepository;
  final RemoteConversationRepository remoteConversationRepository;

  final BehaviorSubject<String> _textSubject = BehaviorSubject<String>();

  Stream<String> get streamText => _textSubject.stream;

  StreamSink<String> get _sinkText => _textSubject.sink;

  late String conversationUserId;

  final ReplaySubject<Iterable<Message>?> _conversationsSubject =
      ReplaySubject();

  Stream<Iterable<Message>?> get conversationStream =>
      _conversationsSubject.stream;

  StreamSink<Iterable<Message>?> get _conversationSink =>
      _conversationsSubject.sink;

  final ScrollController scrollController = ScrollController();

  final BehaviorSubject<bool> _subjectRecorder = BehaviorSubject<bool>();

  Stream<bool> get streamRecorder => _subjectRecorder.stream;

  StreamSink<bool> get _sinkRecorder => _subjectRecorder.sink;

  final BehaviorSubject<bool> _pauseRecorderSubject = BehaviorSubject<bool>();

  Stream<bool> get pauseRecorderStream => _pauseRecorderSubject.stream;

  StreamSink<bool> get _sinkPauseRecorder => _pauseRecorderSubject.sink;

  bool _statusInitRecorder = false;

  final FlutterSoundRecorder recorder = FlutterSoundRecorder();

  MessageBloc({
    required this.remoteMessagesRepository,
    required this.conversation,
    required this.ownerUserProfile,
    required this.remoteUserProfileRepository,
    required this.remoteStorageRepository,
    required this.remoteUserPresenceRepository,
    required this.remoteConversationRepository,
  }) : super(
          InitializeMessageState(
            userprofile: ownerUserProfile,
            streamText: BehaviorSubject<String>().stream,
          ),
        ) {
    _getConversationUserId();
    on<InitializingMessageEvent>(
      (event, emit) async {
        remoteMessagesRepository
            .getMessagesByChatId(
          chatId: conversation.id!,
        )
            .listen(
          (event) {
            _conversationSink.add(event);
          },
        );
        emit(
          InitializeMessageState(
            userprofile: ownerUserProfile,
            streamText: streamText,
          ),
        );
      },
    );
    on<SendTextMessageEvent>(
      (event, emit) async {
        try {
          if (!conversation.isActive) {
            await remoteConversationRepository.updateConversation(
              conversationId: conversation.id!,
              data: {
                ConversationFieldConstants.isActive: true,
              },
            );
            conversation.isActive = true;
          }
          final uuid = const Uuid().v4();
          await remoteMessagesRepository.createMessage(
            conversationId: conversation.id!,
            message: Message(
              id: uuid,
              senderId: ownerUserProfile.id!,
              chatId: conversation.id!,
              content: event.content,
              listNameImage: [],
              nameRecord: "",
              stampTime: DateTime.now(),
              typeMessage: TypeMessage.text.toString(),
              messageStatus: MessageStatus.sent.toString(),
            ),
          );
          await remoteConversationRepository.updateConversation(
            conversationId: conversation.id!,
            data: {
              ConversationFieldConstants.lastText: event.content,
              ConversationFieldConstants.stampTimeLastText:
                  DateTime.now().millisecondsSinceEpoch,
            },
          );
          _sinkText.add("");
          final userProfile =
              await remoteUserProfileRepository.getUserProfileById(
            userID: conversationUserId,
          );

          if (userProfile != null) {
            await FcmHandler.sendMessage(
              notification: {
                'title': userProfile.fullName,
                'body': event.content,
              },
              tokenUserFriend: userProfile.messagingToken ?? "",
              tokenOwnerUser: ownerUserProfile.messagingToken ?? "",
              data: {
                "conversationId": conversation.id!,
                "ownerUserId": ownerUserProfile.id!,
              },
            );
          }

          emit(
            InitializeMessageState(
              userprofile: ownerUserProfile,
              streamText: streamText,
            ),
          );
        } catch (e) {
          log(e.toString());
          emit(
            InitializeMessageState(
              userprofile: ownerUserProfile,
              streamText: streamText,
            ),
          );
        }
      },
    );
    on<SendLikeMessageEvent>((event, emit) async {
      try {
        if (!conversation.isActive) {
          await remoteConversationRepository.updateConversation(
            conversationId: conversation.id!,
            data: {
              ConversationFieldConstants.isActive: true,
            },
          );
          conversation.isActive = true;
        }
        final uuid = const Uuid().v4();
        await remoteMessagesRepository.createMessage(
          conversationId: conversation.id!,
          message: Message(
            id: uuid,
            senderId: ownerUserProfile.id!,
            chatId: conversation.id!,
            content: "",
            listNameImage: [],
            nameRecord: "",
            stampTime: DateTime.now(),
            typeMessage: TypeMessage.like.toString(),
            messageStatus: MessageStatus.sent.toString(),
          ),
        );
        await remoteConversationRepository.updateConversation(
          conversationId: conversation.id!,
          data: {
            ConversationFieldConstants.lastText: "Gửi một like tin nhắn",
            ConversationFieldConstants.stampTimeLastText:
                DateTime.now().millisecondsSinceEpoch,
          },
        );
        final userProfile =
            await remoteUserProfileRepository.getUserProfileById(
          userID: conversationUserId,
        );

        if (userProfile != null) {
          await FcmHandler.sendMessage(
            notification: {
              'title': userProfile.fullName,
              'body': "Gửi một like tin nhắn",
            },
            tokenUserFriend: userProfile.messagingToken ?? "",
            tokenOwnerUser: ownerUserProfile.messagingToken ?? "",
            data: {
              "conversationId": conversation.id!,
              "ownerUserId": ownerUserProfile.id!,
            },
          );
        }

        emit(
          InitializeMessageState(
            userprofile: ownerUserProfile,
            streamText: streamText,
          ),
        );
      } catch (e) {
        log(e.toString());
        emit(
          InitializeMessageState(
            userprofile: ownerUserProfile,
            streamText: streamText,
          ),
        );
      }
    });
    on<SendImageMessageEvent>(
      (event, emit) async {
        try {
          List<String> listFileName = [];
          for (var element in event.result.files) {
            listFileName.add(element.name);
          }
          if (!conversation.isActive) {
            await remoteConversationRepository.updateConversation(
              conversationId: conversation.id!,
              data: {
                ConversationFieldConstants.isActive: true,
              },
            );
            conversation.isActive = true;
          }
          final uuid = const Uuid().v4();
          await remoteMessagesRepository.createMessage(
            conversationId: conversation.id!,
            message: Message(
              id: uuid,
              senderId: ownerUserProfile.id!,
              chatId: conversation.id!,
              content: "",
              listNameImage: listFileName,
              nameRecord: "",
              stampTime: DateTime.now(),
              typeMessage: TypeMessage.media.toString(),
              messageStatus: MessageStatus.sent.toString(),
            ),
          );
          await remoteConversationRepository.updateConversation(
            conversationId: conversation.id!,
            data: {
              ConversationFieldConstants.lastText:
                  "Đã gửi ${event.result.files.length} ảnh",
              ConversationFieldConstants.stampTimeLastText:
                  DateTime.now().millisecondsSinceEpoch,
            },
          );
          final userProfile =
              await remoteUserProfileRepository.getUserProfileById(
            userID: conversationUserId,
          );
          await remoteStorageRepository.uploadMultipleFile(
            listFile: event.result.files,
            path: "messages/${conversation.id}/$uuid",
          );
          if (userProfile != null) {
            await FcmHandler.sendMessage(
              notification: {
                'title': userProfile.fullName,
                'body': "Gửi ${event.result.files.length} ảnh",
              },
              tokenUserFriend: userProfile.messagingToken ?? "",
              tokenOwnerUser: ownerUserProfile.messagingToken ?? "",
              data: {
                "conversationId": conversation.id!,
                "ownerUserId": ownerUserProfile.id!,
              },
            );
          }

          emit(
            InitializeMessageState(
              userprofile: ownerUserProfile,
              streamText: streamText,
            ),
          );
        } catch (e) {
          log(e.toString());
          emit(
            InitializeMessageState(
              userprofile: ownerUserProfile,
              streamText: streamText,
            ),
          );
        }
      },
    );
    on<SendAudioMessageEvent>(
      (event, emit) async {
        try {
          final path = await recorder.stopRecorder();
          _sinkRecorder.add(false);
          _pauseRecorderSubject.add(false);
          if (path != null) {
            if (!conversation.isActive) {
              await remoteConversationRepository.updateConversation(
                conversationId: conversation.id!,
                data: {
                  ConversationFieldConstants.isActive: true,
                },
              );
              conversation.isActive = true;
            }
            final uuid = const Uuid().v4();
            await remoteMessagesRepository.createMessage(
              conversationId: conversation.id!,
              message: Message(
                id: uuid,
                senderId: ownerUserProfile.id!,
                chatId: conversation.id!,
                content: "",
                listNameImage: [],
                nameRecord: uuid,
                stampTime: DateTime.now(),
                typeMessage: TypeMessage.audio.toString(),
                messageStatus: MessageStatus.sent.toString(),
              ),
            );
            await remoteConversationRepository.updateConversation(
              conversationId: conversation.id!,
              data: {
                ConversationFieldConstants.lastText:
                    "Đã gửi một tin nhắn thoại",
                ConversationFieldConstants.stampTimeLastText:
                    DateTime.now().millisecondsSinceEpoch,
              },
            );
            final userProfile =
                await remoteUserProfileRepository.getUserProfileById(
              userID: conversationUserId,
            );
            await remoteStorageRepository.uploadFile(
              file: File(path),
              filePath: "messages/${conversation.id}/$uuid",
              fileName: uuid,
            );
            if (userProfile != null) {
              await FcmHandler.sendMessage(
                notification: {
                  'title': userProfile.fullName,
                  'body': "Gửi một tin nhắn thoại",
                },
                tokenUserFriend: userProfile.messagingToken ?? "",
                tokenOwnerUser: ownerUserProfile.messagingToken ?? "",
                data: {
                  "conversationId": conversation.id!,
                  "ownerUserId": ownerUserProfile.id!,
                },
              );
            }
          }
          emit(
            InitializeMessageState(
              userprofile: ownerUserProfile,
              streamText: streamText,
            ),
          );
        } catch (e) {
          log(e.toString());
          emit(
            InitializeMessageState(
              userprofile: ownerUserProfile,
              streamText: streamText,
            ),
          );
        }
      },
    );
    on<UpdateContentTextEvent>(
      (event, emit) {
        _sinkText.add(event.value);
        emit(
          InitializeMessageState(
            userprofile: ownerUserProfile,
            streamText: streamText,
          ),
        );
      },
    );
    on<OpenRecorderEvent>(
      (event, emit) async {
        await _initRecorder();
        if (_statusInitRecorder) {
          await _record();
          _sinkRecorder.add(true);
        } else {
          _sinkRecorder.add(false);
        }
        emit(
          InitializeMessageState(
            userprofile: ownerUserProfile,
            streamText: streamText,
          ),
        );
      },
    );
    on<DeleteRecorderEvent>(
      (event, emit) async {
        await recorder.stopRecorder();
        await recorder.deleteRecord(fileName: 'audio');
        _sinkRecorder.add(false);
        emit(
          InitializeMessageState(
            userprofile: ownerUserProfile,
            streamText: streamText,
          ),
        );
      },
    );
    on<PauseRecorderEvent>(
      (event, emit) async {
        await recorder.pauseRecorder();
        _sinkPauseRecorder.add(true);
        emit(
          InitializeMessageState(
            userprofile: ownerUserProfile,
            streamText: streamText,
          ),
        );
      },
    );
    on<ResumeRecorderEvent>(
      (event, emit) async {
        await recorder.resumeRecorder();
        _sinkPauseRecorder.add(false);
        emit(
          InitializeMessageState(
            userprofile: ownerUserProfile,
            streamText: streamText,
          ),
        );
      },
    );
  }
  void _getConversationUserId() async {
    if (conversation.listUser.length == 1) {
      conversationUserId = conversation.listUser.first;
    } else {
      conversationUserId = conversation.listUser.firstWhere(
        (element) => element != ownerUserProfile.id,
      );
    }
  }

  Future<void> scrollToEnd() async {
    if (scrollController.hasClients) {
      if (scrollController.position.pixels !=
          scrollController.position.maxScrollExtent) {
        await scrollController.animateTo(
          0.0,
          duration: const Duration(
            milliseconds: 300,
          ),
          curve: Curves.bounceIn,
        );
      }
    }
  }

  bool isImageExtension({
    required String mediaName,
  }) {
    final extension = UtilHandleValue.getFileExtension(mediaName);
    if (extension == ".jpg" || extension == ".png") {
      return true;
    }
    return false;
  }

  Future<void> _initRecorder() async {
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      _statusInitRecorder = false;
    } else {
      await recorder.openRecorder();
      await recorder.setSubscriptionDuration(
        const Duration(milliseconds: 500),
      );
    }

    _statusInitRecorder = true;
  }

  Future _record() async {
    await recorder.startRecorder(toFile: 'audio');
  }

  @override
  Future<void> close() async {
    await _textSubject.drain();
    await _textSubject.close();
    await _conversationsSubject.drain();
    await _conversationsSubject.close();
    await recorder.closeRecorder();
    return super.close();
  }
}
