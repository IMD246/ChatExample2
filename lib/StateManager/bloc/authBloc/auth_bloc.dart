import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../extensions/google_sign_in_extension.dart';
import '../../../models/user_presence.dart';
import '../../../models/user_profile.dart';
import '../../../repositories/constants/user_profile_field_constants.dart';
import '../../../repositories/local_repository/local_user_profile_repository.dart';
import '../../../repositories/remote_repository/remote_storage_repository.dart';
import '../../../repositories/remote_repository/remote_user_presence_repository.dart';
import '../../../repositories/remote_repository/remote_user_profile_repository.dart';
import '../../../services/firebaseAuth/firebase_auth_provider.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  FirebaseAuthProvider firebaseAuthProvider =
      FirebaseAuthProvider.getInstance();

  final RemoteUserProfileRepository remoteUserProfileRepository;

  final RemoteUserPresenceRepository remoteUserPresenceRepository;

  final LocalUserProfileRepository localUserProfileRepository;

  final String tokenMessaging;

  final RemoteStorageRepository remoteStorageRepository;

  final GoogleSignInExtension googleSignInExtension;

  final SharedPreferences sharedPreferences;

  UserProfile? userProfile;
  UserPresence? userPresence;
  String? urlUserProfile;
  AuthBloc({
    required this.remoteUserProfileRepository,
    required this.remoteUserPresenceRepository,
    required this.remoteStorageRepository,
    required this.tokenMessaging,
    required this.googleSignInExtension,
    required this.localUserProfileRepository,
    required this.sharedPreferences,
  }) : super(
          AuthStateLoggedOut(
            isLoading: false,
          ),
        ) {
    on<AuthEventInitialize>(
      (event, emit) async {
        emit(
          AuthStateLoggedOut(
            isLoading: true,
          ),
        );
        try {
          await localUserProfileRepository.init();
          //Get current user from FirebaseAuth
          // final getCurrentUser = firebaseAuthProvider.currentUser;
          final userId = sharedPreferences.getString("userId");
          if (userId == null) {
            emit(
              AuthStateLoggedOut(
                isLoading: false,
              ),
            );
          }
          userProfile = localUserProfileRepository.getUserProfile(
            key: userId ?? "",
          );
          // check if userProfile null will be create
          if (userProfile == null) {
            emit(
              AuthStateLoggedOut(isLoading: false),
            );
          }
          // final file = await UtilsDownloadFile.getFile(userProfile!.id!);
          // userPresence =
          //     await remoteUserPresenceRepository.getUserPresenceById(
          //   userID: userProfile!.id!,
          // );
          // if (await file.exists()) {
          //   urlUserProfile = await remoteStorageRepository.getFile(
          //     filePath: "userProfile",
          //     fileName: userProfile!.id!,
          //   );
          // } else {
          //   await remoteStorageRepository.uploadFile(
          //     file: File(getCurrentUser.photoURL!),
          //     filePath: "userProfile",
          //     fileName: userProfile!.id!,
          //   );
          //   // urlUserProfile = await UtilsDownloadFile.downloadFile(
          //   //   getCurrentUser.photoURL!,
          //   //   userProfile!.id!,
          //   // );
          //   // urlUserProfile = await remoteStorageRepository.getFile(
          //   //   filePath: "userProfile",
          //   //   fileName: userProfile!.id!,
          //   // );
          // }

          // const userProfilePathName = "userProfile";

          // final getUrlImageFromStorage =
          //     await remoteStorageRepository.getFile(
          //   filePath: userProfilePathName,
          //   fileName: userProfile!.id!,
          // );

          // if (getUrlImageFromStorage == null) {
          //   await remoteStorageRepository.uploadFile(
          //     filePath: userProfilePathName,
          //     fileName: getCurrentUser.uid,
          //     file: File(
          //       getCurrentUser.photoURL ?? "",
          //     ),
          //   );
          // }
          emit(
            AuthStateLoggedIn(
              isLoading: false,
              urlUserProfile: urlUserProfile,
              userProfile: userProfile!,
            ),
          );
        } catch (e) {
          log(e.toString());
          emit(
            AuthStateLoggedOut(
              isLoading: false,
            ),
          );
        }
      },
    );
    on<AuthEventLoginByGoogle>(
      (event, emit) async {
        try {
          emit(
            AuthStateLoggedOut(isLoading: true),
          );
          await localUserProfileRepository.init();
          final getCurrentUser = await firebaseAuthProvider.signInWithGoogle();
          if (getCurrentUser != null) {
            emit(
              AuthStateLoggedOut(isLoading: true),
            );
            userProfile =
                await remoteUserProfileRepository.getUserProfileByIdAsync(
              userID: getCurrentUser.uid,
            );
            //get User from cloud firestore
            if (userProfile == null) {
              await remoteUserProfileRepository
                  .createUserProfile(
                    user: getCurrentUser,
                  )
                  .timeout(
                    const Duration(
                      seconds: 5,
                    ),
                  );
            }
            // await localUserProfileRepository.setUserProfile(
            //   userProfile: userProfile!,
            // );
            // userProfile = localUserProfileRepository.getUserProfile(
            //   key: getCurrentUser.uid,
            // );
            await sharedPreferences.setString(
              "userId",
              userProfile!.id!,
            );
            await localUserProfileRepository.createUserProfile(
              userProfile: userProfile!,
            );
            // check if userProfile null will be create
            // if (userProfile == null) {
            //   await remoteUserProfileRepository.createUserProfile(
            //     user: getCurrentUser,
            //   );
            // }

            //get data userProfile again after created
            // streamUserProfile =
            //     await remoteUserProfileRepository.getUserProfileById(
            //   userID: getCurrentUser.uid,
            // );

            // const userProfilePathName = "userProfile";

            // final getUrlImageFromStorage =
            //     await remoteStorageRepository.getFile(
            //   filePath: userProfilePathName,
            //   fileName: userProfile!.id!,
            // );

            // if (getUrlImageFromStorage == null) {
            //   await remoteStorageRepository.uploadFile(
            //     filePath: userProfilePathName,
            //     fileName: getCurrentUser.uid,
            //     file: File(
            //       getCurrentUser.photoURL ?? "",
            //     ),
            //   );
            // }
            if (userProfile == null) {
              emit(
                AuthStateLoggedOut(
                  isLoading: false,
                ),
              );
            }
            if (userProfile != null) {
              emit(
                AuthStateLoggedIn(
                  isLoading: false,
                  urlUserProfile: urlUserProfile,
                  userProfile: userProfile!,
                ),
              );
            }
          } else {
            emit(
              AuthStateLoggedOut(isLoading: false),
            );
          }
        } catch (e) {
          log(e.toString());
          emit(
            AuthStateLoggedOut(isLoading: false),
          );
        }
      },
    );
    on<AuthEventLogout>(
      (event, emit) async {
        try {
          // emit(
          //   AuthStateLoggedIn(
          //     isLoading: false,
          //     userPresence: userPresence,
          //     urlUserProfile: urlUserProfile,
          //     userProfile: userProfile!,
          //   ),
          // );
          await firebaseAuthProvider.logout();
          await sharedPreferences.setString(
            "userId",
            "",
          );
          emit(
            AuthStateLoggedOut(isLoading: false),
          );
        } catch (e) {
          emit(
            AuthStateLoggedIn(
              isLoading: false,
              urlUserProfile: urlUserProfile,
              userProfile: userProfile!,
            ),
          );
        }
      },
    );
  }
  Future<void> updatePresence() async {
    await remoteUserPresenceRepository
        .updatePresenceFieldById(
          userID: userProfile!.id!,
        )
        .timeout(
          const Duration(
            seconds: 5,
          ),
        );
  }

  Future<void> updateMessagingTokenUser() async {
    await remoteUserProfileRepository.updateUserProfile(
      {
        UserProfileFieldConstants.userMessagingTokenField: tokenMessaging,
      },
      userProfile!.id!,
    ).timeout(
      const Duration(
        seconds: 5,
      ),
    );
    userProfile!.messagingToken = tokenMessaging;
  }
}
