import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../models/user_profile.dart';
import '../../../repositories/remote_repository/remote_storage_repository.dart';
import 'setting_event.dart';
import 'setting_state.dart';

class SettingBloc extends Bloc<SettingEvent, SettingState> {
  final UserProfile userProfile;
  final RemoteStorageRepository remoteStorageRepository;
  SettingBloc({
    required this.userProfile,
    required this.remoteStorageRepository,
  }) : super(
          InsideSettingState(
            userProfile: userProfile,
          ),
        ) {
    on<BackToMenuSettingEvent>(
      (event, emit) {
        emit(
          InsideSettingState(
            userProfile: event.userProfile,
          ),
        );
      },
    );
    on<GoToUpdateInfoSettingEvent>(
      (event, emit) {
        emit(
          InsideUpdateInfoState(
            userProfile: userProfile,
          ),
        );
      },
    );
    on<UpdateImageSettingEvent>(
      (event, emit) async {
        final getFile = event.filePickerResult.files.first;
        await remoteStorageRepository.uploadFile(
          file: File(getFile.path!),
          filePath: "userProfile",
          fileName: userProfile.id!,
        );
        emit(
          InsideSettingState(
            userProfile: userProfile,
          ),
        );
      },
    );
  }
}
