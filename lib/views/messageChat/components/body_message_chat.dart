import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../StateManager/bloc/messageBloc/message_bloc.dart';
import '../../../StateManager/bloc/messageBloc/message_event.dart';
import '../../../UIData/image_sources.dart';
import '../../../constants/constant.dart';
import '../../../extensions/localization.dart';
import '../../../models/message.dart';
import 'list_message.dart';
import 'recorder_icon_button.dart';
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
    textController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final messageBloc = context.read<MessageBloc>();
    return Column(
      children: [
        Expanded(
          child: StreamBuilder<Iterable<Message>?>(
            stream: messageBloc.conversationStream,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final messages = snapshot.data;
                if (messages == null || !messageBloc.conversation.isActive) {
                  return const WelcomeChatMessage();
                }
                return ListMessage(
                  scrollController: messageBloc.scrollController,
                  messages: messages,
                );
              } else {
                return Column(
                  children: const [
                    Spacer(),
                    Center(
                      child: CircularProgressIndicator(),
                    ),
                    Spacer(),
                  ],
                );
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
                child: StreamBuilder<bool>(
                  stream: messageBloc.streamRecorder,
                  initialData: false,
                  builder: (context, snapshotRecorder) {
                    if (snapshotRecorder.data == false) {
                      return Row(
                        children: [
                          IconButton(
                            onPressed: () async {
                              final result = await _openFilePicker(
                                context,
                              );
                              if (result != null) {
                                messageBloc.add(
                                  SendImageMessageEvent(
                                    result: result,
                                  ),
                                );
                              }
                            },
                            icon: Icon(
                              Icons.photo,
                              color: kPrimaryColor,
                              size: 32.sp,
                            ),
                          ),
                          const RecorderIconButton(),
                          _textFieldContainer(messageBloc, context),
                          _sendTextIconButton(snapshot, messageBloc),
                        ],
                      );
                    } else {
                      return Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              messageBloc.add(
                                DeleteRecorderEvent(),
                              );
                            },
                            icon: const Icon(
                              Icons.delete,
                              color: kPrimaryColor,
                            ),
                          ),
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: (kDefaultPadding * 0.1).w,
                              ),
                              margin: EdgeInsets.symmetric(
                                vertical: (kDefaultPadding * 0.4).h,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(
                                  32.w,
                                ),
                              ),
                              child: Row(
                                children: [
                                  StreamBuilder<bool>(
                                    initialData: false,
                                    stream: messageBloc.pauseRecorderStream,
                                    builder: (context, pauseRecorder) {
                                      return IconButton(
                                        onPressed: () {
                                          if (!pauseRecorder.data!) {
                                            messageBloc.add(
                                              ResumeRecorderEvent(),
                                            );
                                          } else {
                                            messageBloc.add(
                                              PauseRecorderEvent(),
                                            );
                                          }
                                        },
                                        icon: Icon(
                                          pauseRecorder.data!
                                              ? Icons.play_arrow
                                              : Icons.pause,
                                          color: Colors.white,
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.send,
                              color: kPrimaryColor,
                            ),
                          ),
                        ],
                      );
                    }
                  },
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Future<FilePickerResult?> _openFilePicker(BuildContext context) async {
    final results = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: [
        'jpg',
        'png',
        'PNG',
        'mp3',
        'm4a',
        'mp4',
      ],
    );
    return results;
  }

  Expanded _textFieldContainer(
    MessageBloc messageBloc,
    BuildContext context,
  ) {
    return Expanded(
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
                onTap: () async {
                  setState(() {
                    messageBloc.scrollToEnd();
                  });
                },
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
    );
  }

  IconButton _sendTextIconButton(
    AsyncSnapshot<String> snapshot,
    MessageBloc messageBloc,
  ) {
    return IconButton(
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
          : Image.asset(
              ImageSources.icLike,
            ),
    );
  }
}
