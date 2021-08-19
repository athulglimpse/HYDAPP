import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marvista/data/model/user_info.dart';
import 'package:marvista/utils/ui_util.dart';

import '../../../common/di/injection/injector.dart';
import '../../../data/model/country.dart';
import '../../../data/model/update_model.dart';
import '../../../data/repository/config_repository.dart';
import '../../../data/repository/user_repository.dart';
import '../../../data/source/failure.dart';
import '../../../data/source/upload_photo.dart';
import '../../../utils/string_util.dart';
import 'bloc.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final UserRepository userRepository;
  final ConfigRepository configRepository;

  ProfileBloc({@required this.userRepository, @required this.configRepository})
      : super(ProfileState.initial(userRepository, configRepository));

  @override
  Stream<ProfileState> mapEventToState(ProfileEvent event) async* {
    if (event is PhoneChanged) {
      yield state.copyWith(isPhoneValid: validateMobile(event.phone) == null);
    } else if (event is ResetToUserInfo) {
      final userInfo = state.userInfo;
      Country country;
      for (var i = 0; i < state.listCountry.length; i++) {
        final data = state.listCountry[i];
        if (data.dialCode == userInfo.dialCode) {
          country = data;
          break;
        }
      }
      if (country == null && state.listCountry.isNotEmpty) {
        country = state.listCountry[0];
      }

      final currentMarital = userInfo.marital(state.listMarital);
      final dateOfBirth = userInfo.dobDateTime();

      yield state.copyWith(
          selectedCountry: country,
          maritalStatusSelected: currentMarital,
          selectedDate: dateOfBirth);
    } else if (event is RemoveUserPhoto) {
      yield state.copyWith(pathImage: '');
    } else if (event is OnSelectMarital) {
      yield state.copyWith(maritalStatusSelected: event.maritalStatus);
    } else if (event is OnSelectDOB) {
      yield state.copyWith(selectedDate: event.selectedDate);
    } else if (event is LoadCountryCode) {
      final result = await configRepository.getCountryCode();
      yield* _handleGetCountryCodeResult(result);
    } else if (event is OnSelectCountryCode) {
      yield state.copyWith(selectedCountry: event.countryStatus);
    } else if (event is ChangeUserPhoto) {
      yield state.copyWith(pathImage: event.path);
    } else if (event is ClearPhotoState) {
      yield state.copyWith(pathImage: '');
    } else if (event is ProfileChanged) {
      yield* _handleUpdateProfile(event);
    }
  }

  Stream<ProfileState> _handleUpdateProfile(ProfileChanged event) async* {
    if (state.pathImage.isNotEmpty) {
      await userRepository.uploadPhoto(state.pathImage);
      // final uploader = sl<UploadPhotos>();
      // await uploader.uploadFile(UploadModel.init(file: [
      //   File(state.pathImage)
      // ], dataPost: {
      //   'phone': event.phone,
      //   'date': event.date,
      //   'marital': event.marital,
      // }, typePost: TypePost.ADD_CHANGE_PROFILE_PHOTO));
    }
    final result = await userRepository.updateProfile(
        event.phone, event.date, event.marital, event.dialCode);

    final userResult = await userRepository.getMe();

    yield result.fold((l) {
      UIUtil.showToast((l as RemoteDataFailure).errorMessage);
      return state.copyWith(status: ProfileStatus.FAIL);
    }, (r) {
      return state.copyWith(
        status: ProfileStatus.SUCCESS,
        userInfo: userResult.getOrElse(null),
      );
    });
  }

  Stream<ProfileState> _handleGetCountryCodeResult(
      Either<Failure, List<Country>> result) async* {
    yield result.fold(
      (failure) => state,
      (country) {
        return state.copyWith(
            listCountry: country, selectedCountry: country[0]);
      },
    );
  }
}
