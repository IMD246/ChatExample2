import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../StateManager/bloc/messageBloc/message_bloc.dart';
import '../../../StateManager/bloc/messageBloc/message_event.dart';
import '../../../UIData/image_sources.dart';
import '../../../extensions/localization.dart';
import '../../../models/message.dart';
import 'listview_message.dart';
import 'welcome_chat_message.dart';

class BodyMessageChat extends StatefulWidget {
  const BodyMessageChat({
    Key? key,
  }) : super(key: key);
  @override
  State<BodyMessageChat> createState() => _BodyMessageChatState();
}

class _BodyMessageChatState extends State<BodyMessageChat> {
  late final FocusNode focusNode;
  late final TextEditingController textController;
  @override
  void initState() {
    focusNode = FocusNode();
    textController = TextEditingController();

    super.initState();
  }

  @override
  void dispose() async {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final messageBloc = context.read<MessageBloc>();
    return Column(
      children: [
        Expanded(
          child: StreamBuilder<Iterable<Message>?>(
            stream: messageBloc.remoteMessagesRepository.getMessagesByChatId(
              chatId: messageBloc.conversation.id!,
            ),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final messages = snapshot.data;
                if (messages == null || !messageBloc.conversation.isActive) {
                  return const WelcomeChatMessage();
                }
                return ListViewMessage(
                  messages: messages,
                );
              } else {
                return const CircularProgressIndicator();
              }
            },
          ),
        ),
        StreamBuilder<String>(
          stream: messageBloc.streamText,
          initialData: "",
          builder: (context, snapshot) {
            return Container(
              padding: EdgeInsets.symmetric(
                horizontal: 4.w,
                vertical: 8.h,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFF00BF6D).withOpacity(0.1),
                boxShadow: [
                  BoxShadow(
                    offset: const Offset(0, 4),
                    blurRadius: 32,
                    color: const Color(0xFF087949).withOpacity(0.08),
                  ),
                ],
              ),
              child: SafeArea(
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 12.w),
                        decoration: BoxDecoration(
                          color: const Color(0xFF00BF6D).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(40.w),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                maxLines: null,
                                controller: textController,
                                onChanged: (value) {
                                  messageBloc.add(
                                    UpdateContentTextEvent(
                                      value: textController.text,
                                    ),
                                  );
                                },
                                decoration: InputDecoration(
                                  labelStyle: const TextStyle(
                                    decoration: TextDecoration.none,
                                    color: Colors.red,
                                  ),
                                  hintText: context.loc.type_message,
                                  hintStyle: const TextStyle(
                                    color: Colors.green,
                                  ),
                                  border: InputBorder.none,
                                ),
                                keyboardType: TextInputType.multiline,
                                textInputAction: TextInputAction.done,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        textController.clear();
                        final getData = snapshot.data!;
                        if (getData.isEmpty) {
                          messageBloc.add(
                            SendLikeMessageEvent(),
                          );
                        } else {
                          messageBloc.add(
                            SendTextMessageEvent(
                              content: getData,
                            ),
                          );
                        }
                      },
                      icon: snapshot.data!.isNotEmpty
                          ? const Icon(
                              Icons.send,
                              color: Color(0xFF00BF6D),
                            )
                          : Image.asset(ImageSources.icLike),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
