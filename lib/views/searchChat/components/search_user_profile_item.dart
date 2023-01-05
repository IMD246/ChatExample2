import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../StateManager/bloc/SearchChatBloc/search_chat_bloc.dart';
import '../../../StateManager/bloc/SearchChatBloc/search_chat_event.dart';
import '../../../constants/constant.dart';
import '../../../models/user_presence.dart';
import '../../../models/user_profile.dart';

class SearchUserProfileItem extends StatefulWidget {
  const SearchUserProfileItem({
    Key? key,
    required this.userProfile,
    required this.ownerUserProfile,
  }) : super(key: key);
  final UserProfile userProfile;
  final UserProfile ownerUserProfile;
  @override
  State<SearchUserProfileItem> createState() => _SearchUserProfileItemState();
}

class _SearchUserProfileItemState extends State<SearchUserProfileItem> {
  List<String> listUserProfileConversationId = [];
  void _handleListUserProfile() {
    if (widget.userProfile.id == widget.ownerUserProfile.id) {
      listUserProfileConversationId.add(widget.userProfile.id!);
    } else {
      listUserProfileConversationId = [
        widget.userProfile.id!,
        widget.ownerUserProfile.id!
      ];
    }
  }

  @override
  void initState() {
    _handleListUserProfile();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final searchChatBloc = context.read<SearchChatBloc>();
    return FutureBuilder<UserPresence?>(
      future: searchChatBloc.remoteUserPresenceRepository.getUserPresenceById(
        userID: widget.userProfile.id!,
      ),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            final userPresence = snapshot.data;
            return InkWell(
              onTap: () {
                searchChatBloc.add(
                  GoToConversationRoomSearchChatEvent(
                    listUserId: listUserProfileConversationId,
                    userPresence: userPresence,
                    searchText: searchChatBloc.searchText,
                  ),
                );
              },
              child: ListTile(
                leading: Stack(
                  children: [
                    FutureBuilder<String?>(
                      future: searchChatBloc.remoteStorageRepository.getFile(
                        filePath: "userProfile",
                        fileName: widget.userProfile.id!,
                      ),
                      builder: (context, snapshot) {
                        switch (snapshot.connectionState) {
                          case ConnectionState.done:
                            String? urlImage;
                            if (snapshot.hasData) {
                              urlImage = snapshot.data ?? "";
                            }
                            if (urlImage != null) {
                              return CircleAvatar(
                                backgroundColor: Colors.cyan[100],
                                radius: 20,
                                child: ClipOval(
                                  child: SizedBox.fromSize(
                                    size: const Size.fromRadius(60),
                                    child: CachedNetworkImage(
                                      imageUrl: urlImage,
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) =>
                                          const CircularProgressIndicator(),
                                      errorWidget: (context, url, error) =>
                                          const Icon(Icons.error),
                                    ),
                                  ),
                                ),
                              );
                            }
                            return CircleAvatar(
                              backgroundColor: Colors.cyan[100],
                              backgroundImage: const AssetImage(
                                "assets/images/defaultImage.png",
                              ),
                            );
                          default:
                            return const CircularProgressIndicator();
                        }
                      },
                    ),
                    if (userPresence != null && userPresence.presence)
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          height: 16.h,
                          width: 16.w,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: kPrimaryColor,
                            border: Border.all(
                              color: Theme.of(context).scaffoldBackgroundColor,
                              width: 3.w,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                title: Text(
                  widget.userProfile.fullName,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            );
          default:
            return const Text("");
        }
      },
    );
  }
}
