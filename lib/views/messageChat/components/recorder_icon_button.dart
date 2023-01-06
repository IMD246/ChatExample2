import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../StateManager/bloc/messageBloc/message_bloc.dart';
import '../../../StateManager/bloc/messageBloc/message_event.dart';
import '../../../constants/constant.dart';

class RecorderIconButton extends StatelessWidget {
  const RecorderIconButton({super.key});
  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        context.read<MessageBloc>().add(
              OpenRecorderEvent(),
            );
      },
      icon: const Icon(
        Icons.mic,
        color: kPrimaryColor,
      ),
    );
  }

  Future stop() async {
    // final path = await recorder.stopRecorder();

    // await firebaseChatMessage.createAudioMessage(
    //   chat: widget.chat,
    //   context: context,
    //   ownerUserProfile: widget.ownerUserProfile,
    // );
    // await storage.uploadFileAudio(
    //   filePath: path!,
    //   firebaseChatMessage: firebaseChatMessage,
    //   firebaseUserProfile: firebaseUserProfile,
    //   idChat: widget.chat.idChat,
    //   userOwnerID: widget.ownerUserProfile.idUser!,
    //   context: context,
    // );
    // String userIDFriend = widget.chat.listUser.first;
    // final ownerUserID = widget.ownerUserProfile.idUser!;
    // if (userIDFriend.compareTo(ownerUserID) != 0) {
    //   final chat = await firebaseChat.getChatByID(
    //     idChat: widget.chat.idChat,
    //   );
    //   final userProfileFriend = await firebaseUserProfile.getUserProfile(
    //     userID: userIDFriend,
    //   );
    //   final Map<String, dynamic> notification = {
    //     'title': widget.ownerUserProfile.fullName,
    //     'body': getStringMessageByTypeMessage(
    //       typeMessage: chat.typeMessage,
    //       value: chat.lastText,
    //       context: context,
    //     ),
    //   };
    //   final urlImage = widget.ownerUserProfile.urlImage.isNotEmpty
    //       ? widget.ownerUserProfile.urlImage
    //       : "https://i.stack.imgur.com/l60Hf.png";
    //   final Map<String, dynamic> data = {
    //     'click_action': 'FLUTTER_NOTIFICATION_CLICK',
    //     'id': 1,
    //     'messageType': TypeNotification.chat.toString(),
    //     "sendById": ownerUserID,
    //     "sendBy": widget.ownerUserProfile.fullName,
    //     "chat": <String, dynamic>{
    //       "idChat": widget.chat.idChat,
    //       "nameChat": widget.chat.nameChat,
    //       "urlImage": widget.chat.urlImage,
    //       "presence": widget.chat.presenceUserChat,
    //     },
    //     "userProfile": <String, dynamic>{
    //       "idUser": widget.ownerUserProfile.idUser,
    //     },
    //     'image': urlImage,
    //     'status': 'done',
    //   };
    //   sendMessage(
    //     notification: notification,
    //     tokenUserFriend: userProfileFriend!.tokenUser!,
    //     data: data,
    //     tokenOwnerUser: widget.ownerUserProfile.tokenUser!,
    //   );
    // }
  }
}
