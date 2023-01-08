import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/conversation.dart';
import '../../models/user_profile.dart';
import '../../router/routers.dart';
import '../../services/notification/notification.dart';
import '../../views/messageChat/message_chat_page.dart';

class ConfigAppProvider extends ChangeNotifier {
  NotificationService noti;
  final GlobalKey<NavigatorState> navigatorKey;
  final SharedPreferences sharedPref;
  final String? deviceToken;
  int count = 0;
  ConfigAppProvider({
    required this.noti,
    required this.navigatorKey,
    required this.sharedPref,
    required this.deviceToken,
  });
  void handlerNotification({
    required BuildContext context,
    required Stream<Iterable<Conversation>?> streamConversations,
    required UserProfile ownerUserProfile,
    required String conversationUserId,
  }) async {
    final navigator = Navigator.of(context);
    log("start onnoti");
    noti.onNotificationClick.listen(
      (value) async {
        log("start onNotificationClick");
        if (value != null) {
          log(value.toString());
          final namePath = RoutesHandler.getNamePath(globalKey: navigatorKey);
          final list = await streamConversations.first ?? [];
          final Conversation checkConversation = list.firstWhere(
            (element) => element.id == value["conversationId"],
          );
          if (namePath != null) {
            if (checkConversation.id != null) {
              if (namePath == "/") {
                log("check get inside");
                await navigator.push(
                  MaterialPageRoute(
                    builder: (context) {
                      return MessageChatPage(
                        conversation: checkConversation,
                        ownerUserProfile: ownerUserProfile,
                      );
                    },
                    settings: RouteSettings(
                      name: "conversation:${checkConversation.id}",
                    ),
                  ),
                );
              } else {
                await _checkChatPageOrReplace(
                  namePath: namePath,
                  navigator: navigator,
                  conversation: checkConversation,
                  ownerUserProfile: ownerUserProfile,
                );
              }
            }
          }
        }
      },
    );
  }
}

Future<void> _checkChatPageOrReplace({
  required String namePath,
  required NavigatorState navigator,
  required Conversation conversation,
  required UserProfile ownerUserProfile,
}) async {
  log("check full namePath");
  log(namePath);
  log(namePath.split(":").first);
  if (namePath.split(":").first == "conversation") {
    log("this is conversation page");
    final checkRoute = RoutesHandler.checkChatPage(
      pathValue: namePath,
      idConversation: conversation.id ?? "",
    );
    if (!checkRoute) {
      log("push replace");
      await navigator.pushReplacement(
        MaterialPageRoute(
          builder: (context) {
            return MessageChatPage(
              conversation: conversation,
              ownerUserProfile: ownerUserProfile,
            );
          },
          settings: RouteSettings(
            name: "conversation:${conversation.id}",
          ),
        ),
      );
    }
  }
}
