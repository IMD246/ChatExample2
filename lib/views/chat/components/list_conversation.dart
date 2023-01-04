import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../models/conversation.dart';
import 'item_conversation.dart';

class ListConversation extends StatelessWidget {
  const ListConversation({
    super.key,
    required this.conversations,
  });
  final Iterable<Conversation>? conversations;
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: conversations?.length,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final conversation = conversations!.elementAt(index);
        return Visibility(
          visible: !conversation.isActive,
          child: Padding(
            padding: EdgeInsets.only(
              top: index == 0 ? 8.0.h : 0,
            ),
            child: ItemConversation(
              conversation: conversation,
            ),
          ),
        );
      },
    );
  }
}
