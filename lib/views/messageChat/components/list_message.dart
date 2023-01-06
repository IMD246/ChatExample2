import 'package:flutter/material.dart';

import '../../../models/message.dart';
import 'message_item.dart';

class ListMessage extends StatelessWidget {
  const ListMessage({
    super.key,
    required this.messages,
    required this.scrollController,
  });
  final Iterable<Message> messages;
  final ScrollController scrollController;
  @override
  Widget build(BuildContext context) {
    final reverserMessages = messages.toList().reversed;
    return ListView.builder(
      itemCount: reverserMessages.length,
      cacheExtent: 9999,
      controller: scrollController,
      reverse: true,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        final message = reverserMessages.elementAt(index);
        return MessageItem(
          message: message,
          index: index,
          totalCountIndex: reverserMessages.length - 1,
        );
      },
    );
  }
}
