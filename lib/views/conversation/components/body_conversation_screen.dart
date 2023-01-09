import 'package:flutter/material.dart';
import 'package:flutter_basic_utilities/flutter_basic_utilities.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../StateManager/bloc/conversationBloc/conversation_bloc.dart';
import '../../../StateManager/bloc/conversationBloc/conversation_event.dart';
import '../../../extensions/localization.dart';
import '../../../helpers/navigation/helper_navigation.dart';
import '../../../models/conversation.dart';
import '../../../models/url_image.dart';
import '../../../models/user_profile.dart';
import '../../../widget/image_file_widget.dart';
import '../../../widget/observer.dart';
import '../../searchChat/search_chat_page.dart';
import '../../setting/components/setting_screen.dart';
import 'list_conversation.dart';

class BodyConversationScreen extends StatelessWidget {
  const BodyConversationScreen({
    super.key,
    required this.userProfile,
    required this.urlUserProfile,
  });
  final UserProfile userProfile;
  final UrlImage urlUserProfile;
  @override
  Widget build(BuildContext context) {
    final statusConnection = Provider.of<bool>(context);
    final conversationBloc = context.read<ConversationBloc>();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        automaticallyImplyLeading: false,
        leading: GestureDetector(
          onTap: () async {
            await HelperNavigation.push(
              context: context,
              widget: SettingScreen(
                userProfile: userProfile,
                urlImage: urlUserProfile,
              ),
            ).then(
              (value) {
                if (value != null) {
                  conversationBloc.userProfile.fullName = value[0];
                  conversationBloc.urlUserProfile = value[1];
                  conversationBloc.add(
                    InitializeConversationEvent(),
                  );
                }
              },
            );
          },
          child: urlUserProfile.typeImage == TypeImage.remote
              ? circleImageWidget(
                  urlImage: urlUserProfile.urlImage ??
                      "https://i.stack.imgur.com/l60Hf.png",
                  radius: 20.h,
                )
              : ImageFileWidget(
                  urlImage: urlUserProfile.urlImage ?? "",
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
            Observer<Iterable<Conversation>?>(
              stream: conversationBloc.streamConversations,
              onSuccess: (context, data) {
                final listConversation = data;
                if (listConversation == null || listConversation.isEmpty) {
                  return Padding(
                    padding: EdgeInsets.only(top: 280.0.h),
                    child: TextButton(
                      onPressed: () async {
                        await HelperNavigation.push(
                          context: context,
                          widget: SearchChatPage(
                            ownerUserProfile: userProfile,
                          ),
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

  Widget searchWidget(BuildContext context) {
    return Center(
      child: InkWell(
        onTap: () async {
          await HelperNavigation.push(
            context: context,
            widget: SearchChatPage(
              ownerUserProfile: userProfile,
            ),
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
