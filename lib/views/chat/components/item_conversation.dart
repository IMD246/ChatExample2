import 'package:flutter/material.dart';
import 'package:flutter_basic_utilities/flutter_basic_utilities.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../StateManager/bloc/chatBloc/chat_bloc.dart';
import '../../../StateManager/bloc/chatBloc/chat_event.dart';
import '../../../extensions/localization.dart';
import '../../../models/conversation.dart';
import '../../../models/user_presence.dart';
import '../../../models/user_profile.dart';
import '../../../utilities/format_date.dart';
import '../../../widget/observer.dart';
import '../../../widget/offline_icon_widget.dart';
import '../../../widget/online_icon_widget.dart';

class ItemConversation extends StatefulWidget {
  const ItemConversation({
    super.key,
    required this.conversation,
  });
  final Conversation conversation;

  @override
  State<ItemConversation> createState() => _ItemConversationState();
}

class _ItemConversationState extends State<ItemConversation> {
  String _getIdUserConversation(ChatBloc chatBloc) {
    if (widget.conversation.listUser[0] == chatBloc.userProfile.id &&
        widget.conversation.listUser[1] == chatBloc.userProfile.id) {
      return widget.conversation.listUser[0];
    }
    return widget.conversation.listUser.firstWhere(
      (element) => element != chatBloc.userProfile.id,
    );
  }

  String _handleMessageChat(
    BuildContext context,
    ChatBloc chatBloc,
    String conversationUserId,
  ) {
    if (conversationUserId != "") {
      if (conversationUserId == chatBloc.userProfile.id) {
        return "${context.loc.you}: ";
      } else {
        return "";
      }
    } else {
      return "";
    }
  }

  @override
  Widget build(BuildContext context) {
    final chatBloc = context.read<ChatBloc>();

    final conversationUserId = _getIdUserConversation(chatBloc);

    final handleMessage = _handleMessageChat(
      context,
      chatBloc,
      conversationUserId,
    );
    return InkWell(
      onTap: () {
        chatBloc.add(
          JoinChatEvent(conversation: widget.conversation),
        );
      },
      child: ListTile(
        leading: Stack(
          clipBehavior: Clip.none,
          alignment: AlignmentDirectional.bottomCenter,
          children: [
            Observer<String?>(
              stream: chatBloc.remoteStorageRepository
                  .getFile(
                    filePath: "userProfile",
                    fileName: conversationUserId,
                  )
                  .asStream(),
              onLoading: (context) {
                return const Text("");
              },
              onSuccess: (context, data) {
                return circleImageWidget(
                  urlImage: data ?? "https://i.stack.imgur.com/l60Hf.png",
                  radius: 20.w,
                );
              },
            ),
            Observer<UserPresence?>(
              stream: chatBloc.remoteUserPresenceRepository
                  .getUserPresenceById(
                    userID: conversationUserId,
                  )
                  .asStream(),
              onLoading: (context) {
                return const Text("");
              },
              onSuccess: (context, data) {
                if (data == null) {
                  return const Text("");
                }
                if (data.presence == false) {
                  return offlineIcon(
                    text: differenceInCalendarPresence(
                      data.stampTime,
                    ),
                  );
                }
                return onlineIcon();
              },
            ),
          ],
        ),
        title: Observer<UserProfile?>(
          stream: chatBloc.remoteUserProfileRepository
              .getUserProfileById(userID: conversationUserId)
              .asStream(),
          onLoading: (context) {
            return const Text("");
          },
          onSuccess: (context, data) {
            return textWidget(
              text: data?.fullName ?? "Unknown",
            );
          },
        ),
        subtitle: Row(
          children: [
            Flexible(
              child: textWidget(
                maxLines: 1,
                text: handleMessage + (widget.conversation.lastText),
                textOverflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(width: 16.w),
            textWidget(
              text: differenceInCalendarDaysLocalization(
                widget.conversation.stampTimeLastText,
                context,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
