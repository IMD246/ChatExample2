import 'package:flutter/material.dart';
import 'package:flutter_basic_utilities/flutter_basic_utilities.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../StateManager/bloc/conversationBloc/conversation_bloc.dart';
import '../../../extensions/localization.dart';
import '../../../helpers/navigation/helper_navigation.dart';
import '../../../models/conversation.dart';
import '../../../models/user_presence.dart';
import '../../../models/user_profile.dart';
import '../../../utilities/format_date.dart';
import '../../../widget/observer.dart';
import '../../../widget/offline_icon_widget.dart';
import '../../../widget/online_icon_widget.dart';
import '../../messageChat/message_chat_page.dart';

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
  String _getIdUserConversation(ConversationBloc conversationBloc) {
    if (widget.conversation.listUser.length == 1) {
      return widget.conversation.listUser.first;
    }
    return widget.conversation.listUser.firstWhere(
      (element) => element != conversationBloc.userProfile.id,
    );
  }

  String _handleMessageChat(
    BuildContext context,
    ConversationBloc conversationBloc,
    String conversationUserId,
  ) {
    if (conversationUserId != "") {
      if (conversationUserId == conversationBloc.userProfile.id) {
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
    final conversationBloc = context.read<ConversationBloc>();

    final conversationUserId = _getIdUserConversation(conversationBloc);

    final handleMessage = _handleMessageChat(
      context,
      conversationBloc,
      conversationUserId,
    );
    return InkWell(
      onTap: () async {
        await HelperNavigation.push(
          context: context,
          widget: MessageChatPage(
            conversation: widget.conversation,
            ownerUserProfile: conversationBloc.userProfile,
          ),
          routeSettings: RouteSettings(
            name: "conversation:${widget.conversation.id ?? ""}",
          ),
        );
        // conversationBloc.add(
        //   JoinConversationEvent(conversation: widget.conversation),
        // );
      },
      child: ListTile(
        leading: Stack(
          clipBehavior: Clip.none,
          alignment: AlignmentDirectional.bottomCenter,
          children: [
            Observer<String?>(
              stream: conversationBloc.remoteStorageRepository
                  .getFile(
                    filePath: "userProfile",
                    fileName: conversationUserId,
                  )
                  .asStream(),
              onSuccess: (context, data) {
                return circleImageWidget(
                  urlImage: data ?? "https://i.stack.imgur.com/l60Hf.png",
                  radius: 20.w,
                );
              },
            ),
            Observer<UserPresence?>(
              stream: conversationBloc.remoteUserPresenceRepository
                  .getUserPresenceById(
                    userID: conversationUserId,
                  )
                  .asStream(),
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
          stream: conversationBloc.remoteUserProfileRepository
              .getUserProfileById(userID: conversationUserId),
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
