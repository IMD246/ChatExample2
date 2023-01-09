import 'package:flutter/material.dart';
import 'package:flutter_basic_utilities/flutter_basic_utilities.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../StateManager/bloc/messageBloc/message_bloc.dart';
import '../../../enum/enum.dart';
import '../../../models/message.dart';
import '../../../models/user_presence.dart';
import '../../../utilities/format_date.dart';
import '../../../utilities/handle_value.dart';
import '../../../widget/online_icon_widget.dart';
import 'audio_message.dart';
import 'like_message.dart';
import 'media_message.dart';
import 'text_message.dart';

class MessageItem extends StatefulWidget {
  const MessageItem({
    super.key,
    required this.message,
    required this.index,
    required this.totalCountIndex,
  });
  final Message message;
  final int index;
  final int totalCountIndex;
  @override
  State<MessageItem> createState() => _MessageItemState();
}

class _MessageItemState extends State<MessageItem> {
  bool isNeedShowMessageTime = false;
  bool showStatusMessage = false;
  bool showMessageTime = false;
  bool isLastestMessageOfThisSeries = false;
  bool checkLastestMessageIsNotMine = false;
  // _checkTimeShowTimeMessage() {
  //   setState(() {
  //     if (widget.index == widget.totalCountIndex) {
  //       isNeedShowMessageTime = true;
  //     } else {
  //       if (widget.index >= 0) {
  //         isNeedShowMessageTime =
  //             checkDifferenceBeforeAndCurrentTimeGreaterThan10Minutes(
  //           DateTime.parse(widget.nextMessage!.stampTimeMessage!),
  //           DateTime.parse(widget.message.stampTimeMessage!),
  //         );
  //       } else {
  //         isNeedShowMessageTime = false;
  //       }
  //     }
  //   });
  // }

  @override
  void initState() {
    // _checkTimeShowTimeMessage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final messageBloc = context.read<MessageBloc>();
    final isUserMessage =
        messageBloc.conversationUserId == widget.message.senderId;
    bool isShowLeftAvartar = false;
    // if (!isUserMessage) {
    //   if (widget.previousMessage == null) {
    //     isShowLeftAvartar = true;
    //   } else {
    //     if (widget.previousMessage!.userID! == widget.message.userID) {
    //       isShowLeftAvartar = false;
    //     } else {
    //       isShowLeftAvartar = true;
    //     }
    //   }
    // }
    return Column(
      children: [
        Visibility(
          visible: isNeedShowMessageTime || showMessageTime,
          child: textWidget(
            text: differenceInCalendarStampTime(
              widget.message.stampTime,
            ),
            size: 12.h,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 16.w,
            vertical: 8.h,
          ),
          child: Row(
            mainAxisAlignment:
                isUserMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      // if (isShowLeftAvartar) leftAvatar(messageBloc: messageBloc),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            showMessageTime = !showMessageTime;
                            showStatusMessage = !showStatusMessage;
                          });
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 18.0.w),
                          child: dynamicTypeMessageWidget(
                              message: widget.message, context: context),
                        ),
                      ),
                      Visibility(
                        visible: isUserMessage,
                        child: statusMessage(
                            statusMessage: widget.message.messageStatus,
                            messageBloc: messageBloc),
                      ),
                    ],
                  ),
                  Visibility(
                    visible: showStatusMessage && showMessageTime,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24.0.w),
                      child: textWidget(
                        text: UtilHandleValue.setStatusMessageText(
                          widget.message.messageStatus,
                          context,
                        ),
                        size: 12.h,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget statusMessage({
    required String statusMessage,
    required MessageBloc messageBloc,
  }) {
    if (statusMessage.toLowerCase() == MessageStatus.sent.name.toLowerCase()) {
      return sentIconStatus();
    } else if (statusMessage.toLowerCase() ==
        MessageStatus.viewed.name.toLowerCase()) {
      return rightAvatar(messageBloc);
    } else {
      return Visibility(
        visible: false,
        child: Positioned(
          child: Container(),
        ),
      );
    }
  }

  Positioned sentIconStatus() {
    return Positioned(
      bottom: 0,
      right: -4.w,
      child: Container(
        width: 16.w,
        height: 16.h,
        decoration: const BoxDecoration(
          color: Colors.green,
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: Icon(
          Icons.done,
          color: Colors.white,
          size: 8.h,
        ),
      ),
    );
  }

  Visibility rightAvatar(MessageBloc messageBloc) {
    return Visibility(
      visible: true,
      child: Positioned(
        bottom: 0,
        right: -8.w,
        child: Stack(
          clipBehavior: Clip.none,
          alignment: AlignmentDirectional.bottomCenter,
          children: [
            StreamBuilder<String?>(
              initialData: "",
              stream: messageBloc.remoteStorageRepository
                  .getFile(
                    filePath: "userProfile",
                    fileName: messageBloc.ownerUserProfile.id!,
                  )
                  .asStream(),
              builder: (context, snapshot) {
                return circleImageWidget(
                  urlImage:
                      snapshot.data ?? "https://i.stack.imgur.com/l60Hf.png",
                  radius: 12.w,
                );
              },
            ),
            StreamBuilder<UserPresence?>(
              stream: messageBloc.remoteUserPresenceRepository
                  .getUserPresenceById(userID: messageBloc.ownerUserProfile.id!)
                  .asStream(),
              builder: (context, snapshot) {
                return Visibility(
                  visible: snapshot.data != null && snapshot.data!.presence,
                  child: onlineIcon(
                    width: 8.w,
                    height: 8.h,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Positioned leftAvatar({required MessageBloc messageBloc}) {
    return Positioned(
      bottom: 0,
      left: -8.w,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: AlignmentDirectional.bottomCenter,
        children: [
          StreamBuilder<String?>(
            initialData: "",
            stream: messageBloc.remoteStorageRepository
                .getFile(
                  filePath: "userProfile",
                  fileName: messageBloc.conversationUserId,
                )
                .asStream(),
            builder: (context, snapshot) {
              return circleImageWidget(
                urlImage:
                    snapshot.data ?? "https://i.stack.imgur.com/l60Hf.png",
                radius: 12.w,
              );
            },
          ),
          StreamBuilder<UserPresence?>(
            stream: messageBloc.remoteUserPresenceRepository
                .getUserPresenceById(userID: messageBloc.conversationUserId)
                .asStream(),
            builder: (context, snapshot) {
              return Visibility(
                visible: snapshot.data != null && snapshot.data!.presence,
                child: onlineIcon(
                  width: 8.w,
                  height: 8.h,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget dynamicTypeMessageWidget(
      {required Message message, required BuildContext context}) {
    if (TypeMessage.text.toString() == message.typeMessage) {
      return TextMessage(message: message);
    } else if (TypeMessage.like.toString() == message.typeMessage) {
      return const LikeMessage();
    } else if (TypeMessage.media.toString() == message.typeMessage) {
      return MediaMessage(
        message: message,
      );
    } else if (TypeMessage.audio.toString() == message.typeMessage) {
      final messageBloc = context.read<MessageBloc>();
      return StreamBuilder<String?>(
        stream: messageBloc.remoteStorageRepository
            .getFile(
              filePath: "messages/${messageBloc.conversation.id}/${message.id}",
              fileName: message.nameRecord ?? "",
            )
            .asStream(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return AudioMessasge(
              urlAudio: snapshot.data ?? "",
            );
          }
          return const CircularProgressIndicator();
        },
      );
    } else {
      return textWidget(text: "Dont build this widget yet!");
    }
  }
}
