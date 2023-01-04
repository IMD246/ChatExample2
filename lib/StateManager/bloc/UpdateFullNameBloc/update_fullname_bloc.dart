import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../../../models/user_profile.dart';
import '../../../repositories/constants/user_profile_field_constants.dart';
import '../../../repositories/remote_repository/remote_user_profile_repository.dart';
import '../../../validation/form_validate.dart';
import 'update_fullname_event.dart';
import 'update_fullname_state.dart';

class UpdateFullNameBloc
    extends Bloc<UpdateFullNameEvent, UpdateFullNameState> {
  final UserProfile userProfile;
  final RemoteUserProfileRepository remoteUserProfileRepository;
  final BuildContext context;

  final _fisrtNameController = BehaviorSubject<String>();
  final _lastNameController = BehaviorSubject<String>();
  final _btnController = BehaviorSubject<bool>();

  Stream<String> get firstNameStream => _fisrtNameController.stream.transform(
        nameValidation,
      );

  StreamSink<String> get _firstNameSink => _fisrtNameController.sink;

  Stream<String> get lastNameStream => _lastNameController.stream.transform(
        nameValidation,
      );

  StreamSink<String> get _lastNameSink => _lastNameController.sink;

  Stream<bool> get btnStream => _btnController.stream;

  StreamSink<bool> get _btnSink => _btnController.sink;

  var nameValidation = StreamTransformer<String, String>.fromHandlers(
    handleData: (data, sink) {
      final getDataError = UtilValidation.handleEmptyText(data);
      if (getDataError.isNotEmpty) {
        sink.add(getDataError);
      } else {
        final getDataLengthError =
            UtilValidation.handleLengthTextWithoutContext(
          value: data,
          length: 3,
        );
        if (getDataLengthError.isNotEmpty) {
          sink.add(
            getDataLengthError,
          );
        } else {
          sink.add(
            "",
          );
        }
      }
    },
  );

  UpdateFullNameBloc({
    required this.context,
    required this.userProfile,
    required this.remoteUserProfileRepository,
  }) : super(
          IntializeUpdateFullNameState(
            isLoading: false,
            userProfile: userProfile,
            firstNameStream: BehaviorSubject<String>().stream,
            lastNameStream: BehaviorSubject<String>().stream,
            btnStream: BehaviorSubject<bool>().stream,
          ),
        ) {
    _combine();

    on<UpdateFirstNameEvent>(
      (event, emit) {
        _firstNameSink.add(event.value);
        emit(
          IntializeUpdateFullNameState(
            isLoading: false,
            userProfile: userProfile,
            firstNameStream: firstNameStream,
            lastNameStream: lastNameStream,
            btnStream: btnStream,
          ),
        );
      },
    );
    on<UpdateLastNameEvent>(
      (event, emit) {
        _lastNameSink.add(event.value);
        emit(
          IntializeUpdateFullNameState(
            isLoading: false,
            userProfile: userProfile,
            firstNameStream: firstNameStream,
            lastNameStream: lastNameStream,
            btnStream: btnStream,
          ),
        );
      },
    );
    on<SubmitNewFullNameEvent>(
      (event, emit) async {
        emit(
          IntializeUpdateFullNameState(
            isLoading: true,
            userProfile: userProfile,
            firstNameStream: firstNameStream,
            lastNameStream: lastNameStream,
            btnStream: btnStream,
          ),
        );
        try {
          final fullName = "${event.firstName} ${event.lastName}";
          log(
            fullName.toString(),
          );
          final response = await remoteUserProfileRepository.updateUserProfile(
            {
              UserProfileFieldConstants.fullNameField: fullName,
            },
            userProfile.id!,
          );
          if (response) {
            userProfile.fullName = fullName;
            _firstNameSink.add("");
            _lastNameController.add("");
          }
          emit(
            IntializeUpdateFullNameState(
              isLoading: false,
              userProfile: userProfile,
              firstNameStream: firstNameStream,
              lastNameStream: lastNameStream,
              btnStream: btnStream,
            ),
          );
        } catch (e) {
          log(
            e.toString(),
          );
          emit(
            IntializeUpdateFullNameState(
              isLoading: false,
              userProfile: userProfile,
              firstNameStream: firstNameStream,
              lastNameStream: lastNameStream,
              btnStream: btnStream,
            ),
          );
        }
      },
    );
  }

  @override
  Future<void> close() async {
    await _fisrtNameController.drain();
    await _fisrtNameController.close();
    await _lastNameController.drain();
    await _lastNameController.close();
    await _btnController.drain();
    await _btnController.close();
    return super.close();
  }

  _combine() {
    Rx.combineLatest2(
      _fisrtNameController,
      _lastNameController,
      (a, b) {
        final getErrorTextFirstName = UtilValidation.handleEmptyText(a);
        final getErrorLengthTextFirstName = UtilValidation.handleLengthText(
          value: a,
          length: 3,
          context: context,
        );
        final getErrorTextLastName = UtilValidation.handleEmptyText(b);
        final getErrorLengthTextLastName = UtilValidation.handleLengthText(
          value: b,
          length: 3,
          context: context,
        );
        if (getErrorLengthTextLastName.isEmpty &&
            getErrorLengthTextFirstName.isEmpty &&
            getErrorTextFirstName.isEmpty &&
            getErrorTextLastName.isEmpty) {
          return true;
        }
        return false;
      },
    ).listen((event) {
      _btnSink.add(event);
    });
  }
}
