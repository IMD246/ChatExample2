import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../models/url_image.dart';
import '../../../models/user_profile.dart';
import '../../../repositories/local_repository/local_storage_repository.dart';
import '../../../repositories/remote_repository/remote_storage_repository.dart';
import 'setting_event.dart';
import 'setting_state.dart';

class SettingBloc extends Bloc<SettingEvent, SettingState> {
  final UserProfile userProfile;
  final UrlImage urlImage;
  final RemoteStorageRepository remoteStorageRepository;
  final LocalStorageRepository localStorageRepository;
  SettingBloc({
    required this.userProfile,
    required this.remoteStorageRepository,
    required this.urlImage,
    required this.localStorageRepository,
  }) : super(
          InsideSettingState(userProfile: userProfile, urlImage: urlImage),
        ) {
    on<BackToMenuSettingEvent>(
      (event, emit) {
        emit(
          InsideSettingState(
              userProfile: event.userProfile, urlImage: urlImage),
        );
      },
    );
    on<GoToUpdateInfoSettingEvent>(
      (event, emit) {
        emit(
          InsideUpdateInfoState(userProfile: userProfile, urlImage: urlImage),
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
        final url = await remoteStorageRepository.getFile(
          filePath: "userProfile",
          fileName: userProfile.id!,
        );
        urlImage.typeImage = TypeImage.remote;
        urlImage.urlImage = url;

        await localStorageRepository.uploadFile(
          fileName: userProfile.id!,
          remotePath: url,
        );

        emit(
          InsideSettingState(
            userProfile: userProfile,
            urlImage: urlImage,
          ),
        );
      },
    );
  }
}
