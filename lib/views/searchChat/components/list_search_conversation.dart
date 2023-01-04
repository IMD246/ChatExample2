import 'package:flutter/material.dart';

import '../../../models/user_profile.dart';
import 'conversation_item.dart';

class ListSearchConversation extends StatelessWidget {
  const ListSearchConversation({
    Key? key,
    required this.listUserProfile,
    required this.ownerUserProfile,
  }) : super(key: key);

  final Iterable<UserProfile> listUserProfile;
  final UserProfile ownerUserProfile;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: listUserProfile.length,
        itemBuilder: (context, index) {
          return ConversationItem(
            userProfile: listUserProfile.elementAt(index),
            ownerUserProfile: ownerUserProfile,
          );
        },
      ),
    );
  }
}
