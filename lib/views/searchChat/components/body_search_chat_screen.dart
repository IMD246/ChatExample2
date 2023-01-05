import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../../../StateManager/bloc/SearchChatBloc/search_chat_bloc.dart';
import '../../../StateManager/bloc/SearchChatBloc/search_chat_event.dart';
import '../../../constants/constant.dart';
import '../../../models/user_profile.dart';
import 'list_search_user_profile.dart';

class BodySearchChatScreen extends StatefulWidget {
  const BodySearchChatScreen({
    Key? key,
    required this.userProfile,
    required this.valueStream,
  }) : super(key: key);
  final UserProfile userProfile;
  final ReplayStream<List<UserProfile>?> valueStream;
  @override
  State<BodySearchChatScreen> createState() => _BodySearchChatScreenState();
}

class _BodySearchChatScreenState extends State<BodySearchChatScreen> {
  late final TextEditingController textController;
  late final FocusNode focusNode;
  @override
  void initState() {
    textController = TextEditingController();
    focusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    textController.dispose();
    focusNode.unfocus();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: kDefaultPadding,
        ),
        buildSearchText(),
        const SizedBox(
          height: kDefaultPadding,
        ),
        Visibility(
          visible: textController.text.isEmpty,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
            child: Align(
              alignment: Alignment.topLeft,
              child: Text(
                "Recommended",
                style: Theme.of(context)
                    .textTheme
                    .headline6!
                    .copyWith(fontSize: 18, fontWeight: FontWeight.normal),
              ),
            ),
          ),
        ),
        StreamBuilder<List<UserProfile>?>(
          stream: widget.valueStream,
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.active:
                if (snapshot.hasData) {
                  final listUserProfile = snapshot.data!;
                  return ListSearchUserProfile(
                    listUserProfile: listUserProfile,
                    ownerUserProfile: widget.userProfile,
                  );
                } else {
                  return const Text(
                    "Dont have any data match with keyword",
                  );
                }
              case ConnectionState.waiting:
              default:
                return const CircularProgressIndicator();
            }
          },
        ),
      ],
    );
  }

  TextField buildSearchText() {
    return TextField(
      controller: textController,
      onChanged: (val) {
        setState(() {});
        context.read<SearchChatBloc>().add(
              SearchingSearchChatEvent(
                searchText: textController.text,
              ),
            );
      },
      focusNode: focusNode,
      decoration: InputDecoration(
        hintText: "Search",
        hintStyle: TextStyle(
          color: Theme.of(context).textTheme.headline5!.color,
          fontSize: 20,
        ),
        // focusedBorder: UnderlineInputBorder(
        //   borderSide: BorderSide(
        //     color: !isDarkTheme
        //         ? Colors.black.withOpacity(0.1)
        //         : Colors.white.withOpacity(0.5),
        //   ),
        // ),
        // enabledBorder: UnderlineInputBorder(
        //   borderSide: BorderSide(
        //     color: !isDarkTheme
        //         ? Colors.black.withOpacity(0.1)
        //         : Colors.white.withOpacity(0.5),
        //   ),
        // ),
        prefixIcon: Padding(
          padding: const EdgeInsets.only(right: kDefaultPadding),
          child: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(
              Icons.arrow_back,
              // color:
              //     !isDarkTheme ? Colors.black.withOpacity(0.5) : Colors.white,
            ),
          ),
        ),
        suffixIcon: Visibility(
          visible: textController.text.isNotEmpty,
          child: IconButton(
            onPressed: () {
              setState(
                () {
                  textController.clear();
                  context.read<SearchChatBloc>().add(
                        SearchingSearchChatEvent(
                          searchText: textController.text,
                        ),
                      );
                },
              );
            },
            icon: const Icon(
              Icons.close_rounded,
              // color:
              //     !isDarkTheme ? Colors.black.withOpacity(0.5) : Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
