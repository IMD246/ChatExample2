import 'dart:convert';
import 'dart:developer';
import 'dart:isolate';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/conversation.dart';
import '../constants/conversation_field_constants.dart';
import '../interface_repository/conversation_repository.dart';

class RemoteConversationRepository implements ConversationRepository {
  late CollectionReference collectionConversationRef;
  RemoteConversationRepository() {
    collectionConversationRef = FirebaseFirestore.instance.collection(
      ConversationFieldConstants.collectioName,
    );
  }
  @override
  Stream<Iterable<Conversation>?> getConversationsByUserId({
    required String userId,
  }) {
    return collectionConversationRef
        .where(
          ConversationFieldConstants.listUser,
          arrayContains: userId,
        )
        .orderBy(
          ConversationFieldConstants.stampTimeLastText,
          descending: true,
        )
        .snapshots()
        .map((value) {
      if (value.size == 0 || value.docs.isEmpty) {
        return null;
      }
      return value.docs.map((e) {
        return _parsedConversation(
          e.data(),
          e.id,
        );
      });
    });
  }

  @override
  Future<void> createConversation({
    required String ownerUserId,
    required String userId,
    required Conversation conversation,
  }) async {
    try {
      final check1 =
          await collectionConversationRef.doc(ownerUserId + userId).get().then(
        (value) {
          if (value.exists) {
            return true;
          } else {
            return false;
          }
        },
      );
      final check2 = await collectionConversationRef
          .doc(userId + ownerUserId)
          .get()
          .then((value) {
        if (value.exists) {
          return true;
        } else {
          return false;
        }
      });
      if (check1 == false && check2 == false) {
        conversation.id = ownerUserId + userId;
        await collectionConversationRef
            .doc(
              ownerUserId + userId,
            )
            .set(
              conversation.toMap(),
            );
      }
    } catch (e) {
      log(e.toString());
      throw e;
    }
  }

  @override
  Future<Conversation?> getConversationByListUserId(
      {required List<String> listUserId}) async {
    final getValue = await collectionConversationRef
        .doc(listUserId[0] + listUserId[1])
        .get()
        .then(
      (value) async {
        if (value.exists) {
          return await collectionConversationRef.doc(value.id).get().then(
            (value) {
              return value;
            },
          );
        } else {
          return await collectionConversationRef
              .doc(listUserId[1] + listUserId[0])
              .get()
              .then(
            (value) async {
              if (value.exists) {
                return await collectionConversationRef.doc(value.id).get().then(
                  (value) {
                    return value;
                  },
                );
              } else {
                return null;
              }
            },
          );
        }
      },
    );
    if (getValue == null) {
      return null;
    }
    return _parsedConversation(
      getValue.data(),
      getValue.id,
    );
  }
}

_parsedListConversation(List<dynamic> params) {
  SendPort sendPort = params[0];
  final listObject = params[1] as List<QueryDocumentSnapshot<Object?>>;
  sendPort.send(
    listObject.map(
      (e) => _parsedConversation(
        e.data(),
        e.id,
      ),
    ),
  );
}

Conversation _parsedConversation(Object? object, String id) {
  final convertToMap = json.decode(
    json.encode(
      object,
    ),
  ) as Map<String, dynamic>;
  return Conversation.fromMap(convertToMap, id);
}
