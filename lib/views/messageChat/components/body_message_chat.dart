import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_basic_utilities/widgets/text_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:provider/provider.dart';

import '../../../StateManager/bloc/messageBloc/message_bloc.dart';
import '../../../StateManager/bloc/messageBloc/message_event.dart';
import '../../../UIData/image_sources.dart';
import '../../../constants/constant.dart';
import '../../../extensions/localization.dart';
import '../../../helpers/dialogs/error_dialog.dart';
import '../../../models/message.dart';
import '../../../utilities/format_date.dart';
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
    final statusConnection = Provider.of<bool>(context);
    return Column(
      children: [
        Expanded(
          child: StreamBuilder<Iterable<Message>?>(
            stream: messageBloc.conversationStream,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final messages = snapshot.data;
                if (messages!.isEmpty || !messageBloc.conversation.isActive) {
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
                              if (statusConnection) {
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
                              } else {
                                showErrorDialog(
                                  context: context,
                                  text:
                                      "Hãy kiểm tra lại đường truyền mạng của bạn",
                                  title: "Lỗi kết nối mạng",
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
                          _textFieldContainer(
                            messageBloc,
                            context,
                          ),
                          _sendTextIconButton(
                            snapshot,
                            messageBloc,
                            statusConnection,
                          ),
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  StreamBuilder<bool>(
                                    initialData: false,
                                    stream: messageBloc.pauseRecorderStream,
                                    builder: (context, pauseRecorder) {
                                      if (pauseRecorder.data == false) {
                                        return IconButton(
                                          onPressed: () {
                                            messageBloc.add(
                                              PauseRecorderEvent(),
                                            );
                                          },
                                          icon: const Icon(
                                            Icons.pause,
                                            color: Colors.white,
                                          ),
                                        );
                                      }
                                      return IconButton(
                                        onPressed: () {
                                          messageBloc.add(
                                            ResumeRecorderEvent(),
                                          );
                                        },
                                        icon: const Icon(
                                          Icons.play_arrow,
                                          color: Colors.white,
                                        ),
                                      );
                                    },
                                  ),
                                  textWidget(
                                    text: "Tiến trình ghi âm",
                                    color: Colors.white,
                                    size: 16.sp,
                                  ),
                                  StreamBuilder<RecordingDisposition>(
                                    stream: messageBloc.recorder.onProgress,
                                    builder: (context, snapshot) {
                                      final duration = snapshot.hasData
                                          ? snapshot.data!.duration
                                          : Duration.zero;
                                      return textWidget(
                                        text: "(${formatTime(duration)})",
                                        size: 14.sp,
                                        color: Colors.white,
                                      );
                                    },
                                  ),
                                  SizedBox(
                                    width: 4.w,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              if (statusConnection) {
                                messageBloc.add(
                                  SendAudioMessageEvent(),
                                );
                              } else {
                                showErrorDialog(
                                  context: context,
                                  text:
                                      "Hãy kiểm tra lại đường truyền mạng của bạn",
                                  title: "Lỗi kết nối mạng",
                                );
                              }
                            },
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

  IconButton _sendTextIconButton(AsyncSnapshot<String> snapshot,
      MessageBloc messageBloc, bool statusConnection) {
    return IconButton(
      onPressed: () {
        textController.clear();
        if (statusConnection) {
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
        } else {
          showErrorDialog(
            context: context,
            text: "Hãy kiểm tra lại đường truyền mạng của bạn",
            title: "Lỗi kết nối mạng",
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
