import 'dart:async';
import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:uuid/uuid.dart';

import '../../../enum/enum.dart';
import '../../../models/conversation.dart';
import '../../../models/message.dart';
import '../../../models/user_profile.dart';
import '../../../repositories/remote_repository/remote_conversation_repository.dart';
import '../../../repositories/remote_repository/remote_messages_repository.dart';
import '../../../repositories/remote_repository/remote_storage_repository.dart';
import '../../../repositories/remote_repository/remote_user_presence_repository.dart';
import '../../../repositories/remote_repository/remote_user_profile_repository.dart';
import '../../../services/fcm/fcm_handler.dart';
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
            await remoteConversationRepository.updateConversationActive(
              conversationId: conversation.id!,
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
          await remoteConversationRepository.updateConversationActive(
            conversationId: conversation.id!,
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

  @override
  Future<void> close() async {
    await _textSubject.drain();
    await _textSubject.close();
    return super.close();
  }
}
