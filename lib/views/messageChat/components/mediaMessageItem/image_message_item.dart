import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../StateManager/bloc/messageBloc/message_bloc.dart';
import '../../../../models/message.dart';
import '../full_screen_image.dart';

class ImageMessageCard extends StatelessWidget {
  const ImageMessageCard({
    Key? key,
    required this.nameImage,
    required this.message,
  }) : super(key: key);

  final String nameImage;
  final Message message;
  @override
  Widget build(BuildContext context) {
    final messageBloc = context.read<MessageBloc>();
    return StreamBuilder<String>(
      stream: messageBloc.remoteStorageRepository
          .getFile(
            filePath: "messages/${messageBloc.conversation.id}/${message.id}",
            fileName: nameImage,
          )
          .asStream(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return GestureDetector(
            onTap: () async {
              final navigator = Navigator.of(context);
              final userProfile = await messageBloc.remoteUserProfileRepository
                  .getUserProfileByIdAsync(
                userID: message.senderId,
              );
              navigator.push(
                MaterialPageRoute(
                  builder: (context) {
                    return FullScreenImage(
                      urlImage: snapshot.data ?? "",
                      userProfile: userProfile,
                    );
                  },
                ),
              );
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: CachedNetworkImage(
                imageUrl: snapshot.data!.isNotEmpty || snapshot.data != null
                    ? snapshot.data!
                    : "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR3UppMPcVTGT6NDYTcEm84-keLZBjnyWtuQ-rdto-q&s",
                fit: BoxFit.fill,
                placeholder: (context, url) =>
                    const CircularProgressIndicator(),
                errorWidget: (context, url, error) => const Icon(Icons.error),
                colorBlendMode: BlendMode.softLight,
              ),
            ),
          );
        }
        return const CircularProgressIndicator();
      },
    );
  }
}
