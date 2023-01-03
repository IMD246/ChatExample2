import 'package:flutter/material.dart';
import 'package:flutter_basic_utilities/flutter_basic_utilities.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../StateManager/bloc/chatBloc/chat_bloc.dart';
import '../../../StateManager/bloc/chatBloc/chat_event.dart';
import '../../../extensions/localization.dart';
import '../../../models/conversation.dart';
import '../../../models/user_profile.dart';
import '../../../widget/observer.dart';
import 'list_conversation.dart';

class BodyChatScreen extends StatelessWidget {
  const BodyChatScreen({
    super.key,
    required this.userProfile,
  });
  final UserProfile userProfile;
  @override
  Widget build(BuildContext context) {
    final statusConnection = Provider.of<bool>(context);
    final chatBLoc = context.read<ChatBloc>();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        automaticallyImplyLeading: false,
        leading: GestureDetector(
          onTap: () {
            chatBLoc.add(
              GoToMenuSettingEvent(),
            );
          },
          child: circleImageWidget(
            urlImage:
                userProfile.urlImage ?? "https://i.stack.imgur.com/l60Hf.png",
            radius: 20.h,
          ),
        ),
        title: textWidget(
          text: context.loc.chat,
          size: 20.h,
        ),
        bottom: !statusConnection
            ? PreferredSize(
                preferredSize: Size(
                  20.w,
                  20.h,
                ),
                child: Visibility(
                  visible: !statusConnection,
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 4.0.h),
                    child: textWidget(
                      text: context.loc.waiting_internet,
                      size: 15.h,
                    ),
                  ),
                ),
              )
            : null,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 8.h,
            ),
            searchWidget(context),
            Observer<List<Conversation>?>(
              stream: chatBLoc.remoteConversationRepository
                  .getConversationsByUserId(
                    userId: userProfile.id!,
                  )
                  .asStream(),
              onSuccess: (context, data) {
                final listConversation = data;
                if (listConversation == null || listConversation.isEmpty) {
                  return Padding(
                    padding: EdgeInsets.only(top: 280.0.h),
                    child: TextButton(
                      onPressed: () {
                        context.read<ChatBloc>().add(
                              GoToSearchFriendChatEvent(),
                            );
                      },
                      child: textWidget(
                        text: "Let find some chat",
                      ),
                    ),
                  );
                } else {
                  return ListConversation(
                    conversations: listConversation,
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget searchWidget(
    BuildContext context,
  ) {
    return Center(
      child: InkWell(
        onTap: () {
          BlocProvider.of<ChatBloc>(context).add(
            GoToSearchFriendChatEvent(),
          );
        },
        borderRadius: BorderRadius.circular(20.w),
        child: Container(
          width: 360.w,
          height: 60.h,
          padding: EdgeInsets.symmetric(horizontal: 8.0.w),
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.4),
            borderRadius: BorderRadius.circular(20.w),
          ),
          alignment: Alignment.center,
          child: Row(
            children: [
              const Icon(
                Icons.search,
              ),
              textWidget(
                text: context.loc.search,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
