import 'package:flutter/material.dart';
import 'package:flutter_basic_utilities/flutter_basic_utilities.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../StateManager/bloc/messageBloc/message_bloc.dart';
import '../../../models/user_presence.dart';
import '../../../models/user_profile.dart';
import '../../../widget/observer.dart';
import '../../../widget/online_icon_widget.dart';

class WelcomeChatMessage extends StatelessWidget {
  const WelcomeChatMessage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final messageBloc = context.read<MessageBloc>();
    final size = getDeviceSize(context: context);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
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
                    radius: 60.w,
                  );
                },
              ),
              Observer<UserPresence?>(
                stream: messageBloc.remoteUserPresenceRepository
                    .getUserPresenceById(userID: messageBloc.conversationUserId)
                    .asStream(),
                onSuccess: (context, data) {
                  return Visibility(
                    visible: data != null || data!.presence,
                    child: onlineIcon(width: 40.w, height: 20.h, padding: 4.h),
                  );
                },
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Observer<UserProfile?>(
            stream: messageBloc.remoteUserProfileRepository
                .getUserProfileById(userID: messageBloc.conversationUserId)
                .asStream(),
            onSuccess: (context, data) {
              final user = data;
              return textWidget(
                text: user?.fullName ?? "Unknown",
              );
            },
          ),
          Container(
            constraints: BoxConstraints(maxWidth: size.width * 0.5),
            child: textWidget(
              text: "Các bạn hiện đã là bạn bè của nhau",
              textAlign: TextAlign.center,
              maxLines: 1000,
            ),
          ),
        ],
      ),
    );
  }
}
