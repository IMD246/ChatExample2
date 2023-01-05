import 'package:flutter/material.dart';

import '../../../models/user_profile.dart';
import 'search_user_profile_item.dart';

class ListSearchUserProfile extends StatelessWidget {
  const ListSearchUserProfile({
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
          return SearchUserProfileItem(
            userProfile: listUserProfile.elementAt(index),
            ownerUserProfile: ownerUserProfile,
          );
        },
      ),
    );
  }
}
