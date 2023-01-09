import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';

import '../../../StateManager/bloc/messageBloc/message_bloc.dart';
import '../../../models/message.dart';
import 'mediaMessageItem/image_message_item.dart';
import 'mediaMessageItem/video_message_item.dart';

class MediaMessage extends StatefulWidget {
  const MediaMessage({
    Key? key,
    required this.message,
  }) : super(key: key);
  final Message message;
  @override
  State<MediaMessage> createState() => _MediaMessageState();
}

class _MediaMessageState extends State<MediaMessage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final messageBloc = context.read<MessageBloc>();
    return SizedBox(
      width: 300.w,
      height: 200.h,
      child: widget.message.listNameImage.length <= 1
          ? StaggeredGridView.countBuilder(
              shrinkWrap: true,
              itemCount: widget.message.listNameImage.length,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 1,
              mainAxisSpacing: 24.w,
              crossAxisSpacing: 24.h,
              itemBuilder: (context, index) {
                final mediaName = widget.message.listNameImage.elementAt(index);
                final isImageExtens = messageBloc.isImageExtension(
                  mediaName: mediaName,
                );
                if (isImageExtens) {
                  return ImageMessageCard(
                      nameImage: mediaName, messageId: widget.message.id!,);
                } else {
                  return StreamBuilder<String?>(
                    stream: messageBloc.remoteStorageRepository
                        .getFile(
                          filePath: "messages/${messageBloc.conversation.id}/${widget.message.id}",
                          fileName: mediaName,
                        )
                        .asStream(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return VideoMessageItem(
                          urlVideo: snapshot.data ?? "",
                        );
                      }
                      return const CircularProgressIndicator();
                    },
                  );
                }
              },
              staggeredTileBuilder: (index) => const StaggeredTile.fit(1),
            )
          : GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: widget.message.listNameImage.length,
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 2.w,
              ),
              itemBuilder: (BuildContext context, int index) {
                final mediaName = widget.message.listNameImage.elementAt(index);
                final isImageExtens = messageBloc.isImageExtension(
                  mediaName: mediaName,
                );
                if (isImageExtens) {
                  return ImageMessageCard(
                    nameImage: mediaName,
                    messageId: widget.message.id!,
                  );
                } else {
                  return StreamBuilder<String?>(
                    stream: messageBloc.remoteStorageRepository
                        .getFile(
                          filePath:
                              "messages/${messageBloc.conversation.id}/${widget.message.id}",
                          fileName: mediaName,
                        )
                        .asStream(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return VideoMessageItem(
                          urlVideo: snapshot.data ?? "",
                        );
                      }
                      return const CircularProgressIndicator();
                    },
                  );
                }
              },
            ),
    );
  }
}
