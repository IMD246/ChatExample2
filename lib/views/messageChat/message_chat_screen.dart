import 'package:flutter/material.dart';
import 'package:flutter_basic_utilities/widgets/circle_image_widget.dart';
import 'package:flutter_basic_utilities/widgets/text_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../StateManager/bloc/messageBloc/message_bloc.dart';
import '../../extensions/localization.dart';
import '../../models/user_presence.dart';
import '../../models/user_profile.dart';
import '../../utilities/format_date.dart';
import '../../widget/observer.dart';
import '../../widget/online_icon_widget.dart';
import 'components/body_message_chat.dart';

class MessageChatScreen extends StatelessWidget {
  const MessageChatScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final messageBloc = context.read<MessageBloc>();
    final statusConnectionInternet = Provider.of<bool>(context);
    return Scaffold(
      appBar: buildAppbar(
          context: context,
          messageBloc: messageBloc,
          statusConnectionInternet: statusConnectionInternet),
      body: const BodyMessageChat(),
    );
  }

  AppBar buildAppbar(
      {required BuildContext context,
      required MessageBloc messageBloc,
      required bool statusConnectionInternet}) {
    return AppBar(
      backgroundColor: Colors.greenAccent,
      leading: BackButton(
        color: Colors.black,
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
      bottom: !statusConnectionInternet
          ? PreferredSize(
              preferredSize: Size(
                20.w,
                20.h,
              ),
              child: Padding(
                padding: EdgeInsets.only(bottom: 4.0.h),
                child: textWidget(
                  text: context.loc.waiting_internet,
                  size: 15.h,
                ),
              ),
            )
          : null,
      title: StreamBuilder<UserPresence?>(
        stream: messageBloc.remoteUserPresenceRepository
            .getUserPresenceById(userID: messageBloc.conversationUserId)
            .asStream(),
        builder: (context, snapshot) {
          UserPresence? userPresence;
          if (snapshot.hasData) {
            userPresence = snapshot.data;
          }
          if (userPresence == null) {
            return Container();
          }
          return Row(
            children: [
              Stack(
                clipBehavior: Clip.none,
                alignment: AlignmentDirectional.bottomCenter,
                children: [
                  Observer<String?>(
                    stream: messageBloc.remoteStorageRepository
                        .getFile(
                          filePath: "userProfile",
                          fileName: messageBloc.conversationUserId,
                        )
                        .asStream(),
                    onSuccess: (context, data) {
                      return circleImageWidget(
                        urlImage: data ?? "https://i.stack.imgur.com/l60Hf.png",
                        radius: 20.w,
                      );
                    },
                  ),
                  Visibility(
                    visible: userPresence.presence,
                    child: onlineIcon(),
                  ),
                ],
              ),
              SizedBox(width: 8.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Observer<UserProfile?>(
                    stream: messageBloc.remoteUserProfileRepository
                        .getUserProfileById(
                            userID: messageBloc.conversationUserId)
                        .asStream(),
                    onSuccess: (context, data) {
                      final user = data;
                      return textWidget(
                        text: user?.fullName ?? "Unknown",
                        size: 16.sp,
                      );
                    },
                  ),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "${context.loc.online} ",
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: Colors.black54,
                          ),
                        ),
                        if (userPresence.presence == false)
                          TextSpan(
                            text: differenceInCalendarDaysLocalization(
                              userPresence.stampTime,
                              context,
                            ),
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: Colors.black54,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              )
            ],
          );
        },
      ),
    );
  }
}
