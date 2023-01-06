import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../StateManager/bloc/messageBloc/message_bloc.dart';

class ImageMessageCard extends StatelessWidget {
  const ImageMessageCard({
    Key? key,
    required this.nameImage,
    required this.messageId,
  }) : super(key: key);

  final String nameImage;
  final String messageId;
  @override
  Widget build(BuildContext context) {
    final messageBloc = context.read<MessageBloc>();
    return GestureDetector(
      onTap: () async {
        // Navigator.of(context).push(
        //   MaterialPageRoute(
        //     builder: (context) {
        //       return FullScreenImage(
        //         urlImage: urlImage,
        //         fullName: userProfile!.fullName,
        //       );
        //     },
        //   ),
        // );
      },
      child: StreamBuilder<String?>(
        stream: messageBloc.remoteStorageRepository
            .getFile(
              filePath: "messages/${messageBloc.conversation.id}/$messageId",
              fileName: nameImage,
            )
            .asStream(),
        builder: (context, snapshot) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: CachedNetworkImage(
              imageUrl: snapshot.data ??
                  "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR3UppMPcVTGT6NDYTcEm84-keLZBjnyWtuQ-rdto-q&s",
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.fill,
              placeholder: (context, url) => const CircularProgressIndicator(),
              errorWidget: (context, url, error) => const Icon(Icons.error),
              colorBlendMode: BlendMode.softLight,
            ),
          );
        },
      ),
    );
  }
}
