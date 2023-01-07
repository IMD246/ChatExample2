import 'dart:convert';
import 'dart:developer';
import 'dart:isolate';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/message.dart';
import '../constants/messages_field_constants.dart';
import '../interface_repository/messages_repository.dart';

class LocalMessagesRepository implements MessagesRepository {
  late CollectionReference collectionRefMessages;

  LocalMessagesRepository() {
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
  Stream<Iterable<Message>?> getMessagesByConversationId({
    required String conversationId,
  }) {
    return collectionRefMessages
        .doc(conversationId)
        .collection(MessagesFieldConstants.collectionChildName)
        .orderBy(
          MessagesFieldConstants.stampTimeField,
          descending: false,
        )
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

  Future<Iterable<Message>?> getMessagesByChatIdAsync({
    required String chatId,
  }) async {
    return await collectionRefMessages
        .doc(chatId)
        .collection(MessagesFieldConstants.collectionChildName)
        .orderBy(MessagesFieldConstants.stampTimeField, descending: false)
        .get()
        .then(
      (event) async {
        if (event.docs.isEmpty || event.size <= 0) {
          return [];
        }
        final ReceivePort receivePort = ReceivePort();
        final isolate = await Isolate.spawn(
          _parsedListMessage,
          [
            receivePort.sendPort,
            event.docs,
          ],
        );
        final data = await receivePort.first as Iterable<Message>?;
        isolate.kill(
          priority: Isolate.immediate,
        );
        return data;
      },
    );
  }
}

_parsedListMessage(List<dynamic> params) {
  SendPort sendPort = params[0];
  final listObject = params[1] as List<QueryDocumentSnapshot<Object?>>;
  sendPort.send(
    listObject.map(
      (e) => _parsedMessage(
        e.data(),
        e.id,
      ),
    ),
  );
}

Message _parsedMessage(Object? object, String id) {
  final convertToMap = json.decode(
    json.encode(
      object,
    ),
  ) as Map<String, dynamic>;
  return Message.fromMap(convertToMap, id);
}
