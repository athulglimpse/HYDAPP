import 'package:equatable/equatable.dart';
import '../../../data/model/app_config.dart';
import '../../../data/model/country.dart';
import '../../../data/model/user_info.dart';
import '../../../data/repository/config_repository.dart';
import '../../../data/repository/user_repository.dart';

class ProfileState {
  final UserInfo userInfo;
  final List<MaritalStatus> listMarital;
  final MaritalStatus maritalStatusSelected;
  final Country countrySelected;
  final List<Country> listCountry;
  final DateTime selectedDate;
  final bool isPhoneValid;
  final String pathImage;
  final ProfileStatus status;
  final String message;

  ProfileState({
    this.userInfo,
    this.listMarital,
    this.maritalStatusSelected,
    this.countrySelected,
    this.pathImage,
    this.status,
    this.message,
    this.listCountry,
    this.isPhoneValid,
    this.selectedDate,
  });

  factory ProfileState.initial(
      UserRepository userRepository, ConfigRepository configRepository) {
    final userInfo = userRepository.getCurrentUser();
    final listMarital = configRepository?.getAppConfig()?.maritalStatus;
    final currentMarital = userInfo.marital(listMarital);
    return ProfileState(
      userInfo: userInfo,
      selectedDate: userInfo.dobDateTime(),
      listMarital: listMarital,
      maritalStatusSelected: currentMarital,
      status: ProfileStatus.NONE,
      isPhoneValid: true,
      pathImage: '',
      message: '',
    );
  }

  ProfileState copyWith({
    bool isPhoneValid,
    UserInfo userInfo,
    MaritalStatus maritalStatusSelected,
    String maritalId,
    String message,
    DateTime selectedDate,
    ProfileStatus status,
    Country selectedCountry,
    String pathImage,
    List<Country> listCountry,
  }) {
    return ProfileState(
      userInfo: userInfo ?? this.userInfo,
      status: status ?? ProfileStatus.NONE,
      message: message ?? this.message,
      isPhoneValid: isPhoneValid ?? this.isPhoneValid,
      maritalStatusSelected:
          maritalStatusSelected ?? this.maritalStatusSelected,
      listMarital: listMarital,
      countrySelected: selectedCountry ?? countrySelected,
      listCountry: listCountry ?? this.listCountry,
      selectedDate: selectedDate ?? this.selectedDate,
      pathImage: pathImage ?? this.pathImage,
    );
  }

  // @override
  // List<Object> get props => [
  //       userInfo,
  //       maritalStatusSelected,
  //       listMarital,
  //       status,
  //       countrySelected,
  //       listCountry,
  //       selectedDate,
  //       isPhoneValid,
  //       pathImage
  //     ];

  @override
  String toString() {
    return '''MyFormState {
    userInfo:$userInfo,
    listMarital:$listMarital,
    countrySelected:$countrySelected,
    listCountry:$listCountry,
    selectedDate:$selectedDate,
    isPhoneValid:$isPhoneValid,
    pathImage:$pathImage,
    }''';
  }
}

class LogoutSuccess extends ProfileState {}

enum ProfileStatus { NONE, FAIL, SUCCESS }
