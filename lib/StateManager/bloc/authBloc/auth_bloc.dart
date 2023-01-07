import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../extensions/google_sign_in_extension.dart';
import '../../../models/user_presence.dart';
import '../../../models/user_profile.dart';
import '../../../repositories/constants/user_profile_field_constants.dart';
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
  final String tokenMessaging;
  final RemoteStorageRepository remoteStorageRepository;
  final GoogleSignInExtension googleSignInExtension;
  UserProfile? userProfile;
  UserPresence? userPresence;
  String? urlUserProfile;
  AuthBloc({
    required this.remoteUserProfileRepository,
    required this.remoteUserPresenceRepository,
    required this.remoteStorageRepository,
    required this.tokenMessaging,
    required this.googleSignInExtension,
  }) : super(
          AuthStateLoggedOut(
            isLoading: false,
          ),
        ) {
    on<AuthEventInitialize>(
      (event, emit) async {
        try {
          //Get current user from FirebaseAuth
          final getCurrentUser = firebaseAuthProvider.currentUser;
          if (getCurrentUser != null) {
            emit(
              AuthStateLoggedOut(isLoading: true),
            );
            //get User from cloud firestore
            remoteUserProfileRepository
                .getUserProfileById(
              userID: getCurrentUser.uid,
            )
                .listen(
              (event) {
                if (event == null) {
                  emit(
                    AuthStateLoggedOut(
                      isLoading: false,
                    ),
                  );
                }
                userProfile = event;
              },
            );
            // check if userProfile null will be create
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
            if (userProfile != null) {
              if (userProfile!.messagingToken != tokenMessaging) {
                //update token messaging for userProfile
                await remoteUserProfileRepository.updateUserProfile(
                  {
                    UserProfileFieldConstants.userMessagingTokenField:
                        tokenMessaging,
                  },
                  getCurrentUser.uid,
                ).timeout(
                  const Duration(
                    seconds: 5,
                  ),
                );
                userProfile!.messagingToken = tokenMessaging;
              }
              await remoteUserPresenceRepository
                  .updatePresenceFieldById(
                    userID: userProfile!.id!,
                  )
                  .timeout(
                    const Duration(
                      seconds: 5,
                    ),
                  );
              emit(
                AuthStateLoggedIn(
                  isLoading: false,
                  userPresence: userPresence,
                  urlUserProfile: urlUserProfile,
                  userProfile: userProfile!,
                ),
              );
            } else {
              emit(
                AuthStateLoggedOut(isLoading: false),
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
          final getCurrentUser = await firebaseAuthProvider.signInWithGoogle();
          if (getCurrentUser != null) {
            emit(
              AuthStateLoggedOut(isLoading: true),
            );
            userProfile = await remoteUserProfileRepository
                .getUserProfileById(
                  userID: getCurrentUser.uid,
                )
                .first;
            //get User from cloud firestore
            if (userProfile == null) {
              await remoteUserProfileRepository
                  .createUserProfile(
                    user: getCurrentUser,
                  )
                  .timeout(const Duration(
                    seconds: 5,
                  ));
            }
            userProfile = await remoteUserProfileRepository
                .getUserProfileById(
                  userID: getCurrentUser.uid,
                )
                .first;
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
            if (userProfile != null) {
              if (userProfile!.messagingToken != tokenMessaging) {
                //update token messaging for userProfile
                await remoteUserProfileRepository.updateUserProfile(
                  {
                    UserProfileFieldConstants.userMessagingTokenField:
                        tokenMessaging,
                  },
                  getCurrentUser.uid,
                ).timeout(const Duration(
                  seconds: 5,
                ));
                userProfile!.messagingToken = tokenMessaging;
              }
              await remoteUserPresenceRepository
                  .updatePresenceFieldById(
                    userID: userProfile!.id!,
                  )
                  .timeout(const Duration(
                    seconds: 5,
                  ));
              emit(
                AuthStateLoggedIn(
                  isLoading: false,
                  userPresence: userPresence,
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
          emit(
            AuthStateLoggedIn(
              isLoading: true,
              userPresence: userPresence,
              urlUserProfile: urlUserProfile,
              userProfile: userProfile!,
            ),
          );
          await firebaseAuthProvider.logout();
          emit(
            AuthStateLoggedOut(isLoading: false),
          );
        } catch (e) {
          emit(
            AuthStateLoggedIn(
              isLoading: false,
              userPresence: userPresence,
              urlUserProfile: urlUserProfile,
              userProfile: userProfile!,
            ),
          );
        }
      },
    );
  }
}
