// import 'package:firebase_database/firebase_database.dart';

// import '../../models/user_presence.dart';
// import '../constants/user_presence_field_constants.dart';
// import '../interface_repository/user_presence_repository.dart';

// class RemoteUserPresenceRepository extends UserPresenceRepository {
//   late DatabaseReference databaseUserPresenceRef;
//   RemoteUserPresenceRepository() {
//     databaseUserPresenceRef = FirebaseDatabase.instance.ref(
//       UserPresenceFieldConstants.collectionName,
//     );
//   }
//   @override
//   Future<UserPresence?> getUserPresenceById({required String userID}) async {
//     return await databaseUserPresenceRef.child(userID).once().then(
//       (event) {
//         if (event.snapshot.value != null) {
//           final data = Map<String, dynamic>.from(event.snapshot.value as Map);
//           return UserPresence.fromMap(data);
//         }
//         return null;
//       },
//     );
//   }

//   @override
//   Future<void> updatePresenceFieldById({
//     required String userID,
//   }) async {
//     Map<String, dynamic> presenceStatusTrue = {
//       UserPresenceFieldConstants.presenceField: true,
//       UserPresenceFieldConstants.stampTimeField: DateTime.now(),
//     };
//     await databaseUserPresenceRef.child(userID).update(
//           presenceStatusTrue,
//         );
//     Map<String, dynamic> presenceStatusFalse = {
//       UserPresenceFieldConstants.presenceField: false,
//       UserPresenceFieldConstants.stampTimeField: DateTime.now().toString(),
//     };
//     await databaseUserPresenceRef.child(userID).onDisconnect().update(
//           presenceStatusFalse,
//         );
//   }
// }
