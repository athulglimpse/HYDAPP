import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../data/model/app_config.dart';
import '../../../data/model/country.dart';

@immutable
abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object> get props => [];
}

class ResetToUserInfo extends ProfileEvent {}

class LoadCountryCode extends ProfileEvent {}

class OnSelectMarital extends ProfileEvent {
  final MaritalStatus maritalStatus;

  OnSelectMarital({@required this.maritalStatus});

  @override
  List<Object> get props => [maritalStatus];
}

class OnSelectCountryCode extends ProfileEvent {
  final Country countryStatus;

  OnSelectCountryCode({@required this.countryStatus});

  @override
  List<Object> get props => [countryStatus];
}

class PhoneChanged extends ProfileEvent {
  final String phone;

  PhoneChanged({@required this.phone});

  @override
  List<Object> get props => [phone];
}

class OnSelectDOB extends ProfileEvent {
  final DateTime selectedDate;

  OnSelectDOB(this.selectedDate);
}

class ProfileChanged extends ProfileEvent {
  final String phone;
  final String date;
  final String dialCode;
  final String marital;

  ProfileChanged(
      {@required this.phone, this.dialCode, this.date, this.marital});

  @override
  List<Object> get props => [phone, date, dialCode, marital];
}

class ChangeUserPhoto extends ProfileEvent {
  final String path;

  ChangeUserPhoto(this.path);
}

class RemoveUserPhoto extends ProfileEvent {}

class ClearPhotoState extends ProfileEvent {}
