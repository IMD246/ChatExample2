import 'package:flutter/material.dart';

import '../../../models/message.dart';
import 'message_item.dart';

class ListViewMessage extends StatefulWidget {
  const ListViewMessage({
    super.key,
    required this.messages,
    required this.scrollController,
  });
  final Iterable<Message> messages;
  final ScrollController scrollController;
  @override
  State<ListViewMessage> createState() => _ListViewMessageState();
}

class _ListViewMessageState extends State<ListViewMessage> {
  late final FocusNode focusNode;
  @override
  void initState() {
    focusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final reverserMessages = widget.messages.toList().reversed;
    return ListView.builder(
      itemCount: reverserMessages.length,
      controller: widget.scrollController,
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
