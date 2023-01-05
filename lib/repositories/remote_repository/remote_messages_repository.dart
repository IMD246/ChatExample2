import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/message.dart';
import '../constants/messages_field_constants.dart';
import '../interface_repository/messages_repository.dart';

class RemoteMessagesRepository implements MessagesRepository {
  late CollectionReference collectionRefMessages;

  RemoteMessagesRepository() {
    collectionRefMessages = FirebaseFirestore.instance.collection(
      MessagesFieldConstants.collectionParentName,
    );
  }
  @override
  Future<void> createMessage({
    required String conversationId,
    required Message message,
  }) async {
    try {
      return await collectionRefMessages
          .doc(conversationId)
          .collection(MessagesFieldConstants.collectionChildName)
          .doc(message.id!)
          .set(
            message.toMap(),
          );
    } catch (e) {
      log(
        e.toString(),
      );
      rethrow;
    }
  }

  @override
  Stream<Iterable<Message>?> getMessagesByChatId({
    required String chatId,
  }) {
    return collectionRefMessages
        .doc(chatId)
        .collection(MessagesFieldConstants.collectionChildName)
        .orderBy(MessagesFieldConstants.stampTimeField, descending: false)
        .snapshots()
        .map(
      (event) {
        if (event.docs.isEmpty || event.size <= 0) {
          return [];
        }
        return event.docs.map(
          (e) {
            return _parsedMessage(
              e.data(),
              e.id,
            );
          },
        );
      },
    );
  }
}

// _parsedListMessage(List<dynamic> params) {
//   SendPort sendPort = params[0];
//   final listObject = params[1] as List<QueryDocumentSnapshot<Object?>>;
//   sendPort.send(
//     listObject.map(
//       (e) => _parsedMessage(
//         e.data(),
//         e.id,
//       ),
//     ),
//   );
// }

Message _parsedMessage(Object? object, String id) {
  final convertToMap = json.decode(
    json.encode(
      object,
    ),
  ) as Map<String, dynamic>;
  return Message.fromMap(convertToMap, id);
}
