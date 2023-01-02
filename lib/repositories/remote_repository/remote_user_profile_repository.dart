// import 'dart:convert';
// import 'dart:developer';
// import 'dart:isolate';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// import '../../models/user_profile.dart';
// import '../constants/user_profile_field_constants.dart';
// import '../interface_repository/user_profile_repository.dart';

// class RemoteUserProfileRepository implements UserProfileRepository {
//   late CollectionReference firebaseUserProfileDoc;
//   RemoteUserProfileRepository() {
//     firebaseUserProfileDoc =
//         FirebaseFirestore.instance.collection('userProfile');
//   }
//   @override
//   Future<void> createUserProfile({required User? user}) async {
//     if (user?.uid != null) {
//       try {
//         Map<String, dynamic> mapUserProfile = {
//           UserProfileFieldConstants.idUserField: user?.uid,
//           UserProfileFieldConstants.emailField: user?.email,
//           UserProfileFieldConstants.fullNameField: user?.displayName,
//           UserProfileFieldConstants.urlImageField: "",
//           UserProfileFieldConstants.isEmailVerifiedField: user?.emailVerified,
//           UserProfileFieldConstants.userMessagingTokenField: ""
//         };
//         await firebaseUserProfileDoc.doc(user?.uid).set(mapUserProfile);
//       } catch (_) {}
//     } else {}
//   }

//   @override
//   Future<List<UserProfile>?> getAllUserProfileBySearchText(
//       {required String? searchText}) async {
//     final String text = searchText! + "\uf8ff";
//     return await firebaseUserProfileDoc
//         .orderBy(UserProfileFieldConstants.fullNameField, descending: true)
//         .where(UserProfileFieldConstants.fullNameField,
//             isGreaterThanOrEqualTo: searchText)
//         .where(UserProfileFieldConstants.fullNameField,
//             isLessThanOrEqualTo: text)
//         .get()
//         .then(
//       (value) async {
//         if (value.size == 0 && value.docs.isNotEmpty) {
//           return null;
//         }
//         final ReceivePort receivePort = ReceivePort();
//         final isolates = await Isolate.spawn(
//           _parsedListUserProfile,
//           [receivePort.sendPort, value.docs],
//         );
//         final data = (await receivePort.first) as List<UserProfile>?;
//         isolates.kill(
//           priority: Isolate.immediate,
//         );
//         return data;
//       },
//     );
//   }

//   @override
//   Future<UserProfile?> getUserProfileById({required String? userID}) async {
//     if (userID != null) {
//       try {
//         return await firebaseUserProfileDoc.doc(userID).get().then(
//           (value) async {
//             if (value.exists && value.id.isNotEmpty) {
//               return _parsedObjectToUserProfile(
//                 value: value.data(),
//                 id: userID,
//               );
//             }
//             return null;
//           },
//         );
//       } catch (_) {
//         return null;
//         // throw FailedQueryData();
//       }
//     } else {
//       // throw UserNotLoggedInAuthException();
//       return null;
//     }
//   }

//   Future<bool> updateUserProfile(
//     Map<String, dynamic> mapUserProfile,
//     String uid,
//   ) async {
//     try {
//       await firebaseUserProfileDoc.doc(uid).update(mapUserProfile);
//       return true;
//     } catch (e) {
//       return false;
//     }
//   }

//   UserProfile _parsedObjectToUserProfile(
//       {required Object? value, required String id}) {
//     final convertToMap = json.decode(
//       json.encode(
//         value,
//       ),
//     ) as Map<String, dynamic>;
//     return UserProfile.fromMap(convertToMap, id);
//   }

//   @override
//   Future<List<UserProfile>?> getAllUserProfile({required int? limit}) async {
//     return await firebaseUserProfileDoc.get().then(
//       (value) async {
//         if (value.size == 0 && value.docs.isNotEmpty) {
//           log("null me r");
//           return null;
//         }
//         final ReceivePort receivePort = ReceivePort();
//         final isolates = await Isolate.spawn(
//           _parsedListUserProfile,
//           [receivePort.sendPort, value.docs],
//         );
//         final data = (await receivePort.first) as List<UserProfile>?;
//         isolates.kill(
//           priority: Isolate.immediate,
//         );
//         return data;
//       },
//     );
//   }

//   void _parsedListUserProfile(List<dynamic> params) {
//     SendPort sendPort = params[0];
//     final listValues = params[1] as List<QueryDocumentSnapshot<Object?>>;
//     sendPort.send(
//       listValues
//           .map(
//             (e) => _parsedObjectToUserProfile(
//               value: e.data(),
//               id: e.id,
//             ),
//           )
//           .toList(),
//     );
//   }
// }
