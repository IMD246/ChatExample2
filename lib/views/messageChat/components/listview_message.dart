import 'package:flutter/material.dart';

import '../../../models/message.dart';
import 'message_item.dart';

class ListViewMessage extends StatefulWidget {
  const ListViewMessage({
    super.key,
    required this.messages,
  });
  final Iterable<Message> messages;

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
    return ListView.builder(
      itemCount: widget.messages.length,
      // controller: messageBloc.messageManager.scrollController,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        final message = widget.messages.elementAt(index);
        return MessageItem(
          message: message,
          index: index,
          totalCountIndex: widget.messages.length - 1,
        );
      },
    );
  }
}
