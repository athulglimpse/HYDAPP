import 'package:equatable/equatable.dart';
import 'package:marvista/data/model/help_report_model.dart';
import 'package:marvista/data/repository/help_report_repository.dart';
import 'package:meta/meta.dart';

import '../../../data/model/country.dart';
import '../../../data/repository/config_repository.dart';
import '../../../data/repository/user_repository.dart';

@immutable
class HelpState extends Equatable {
  final List<HelpReportModel> helpItems;
  final HelpReportModel currentHelpItem;
  final bool isEmailValid;
  final bool isPhoneValid;
  final bool isDesValid;
  final bool isSuccess;
  final bool isError;
  final String email;
  final String phone;
  final String description;
  final Country countrySelected;
  final List<Country> listCountry;

  HelpState({
    this.isEmailValid,
    this.isDesValid,
    this.currentHelpItem,
    this.isPhoneValid,
    this.helpItems,
    this.email,
    this.isSuccess,
    this.isError,
    this.phone,
    this.description,
    this.countrySelected,
    this.listCountry,
  });

  factory HelpState.initial(
    UserRepository userRepository,
    ConfigRepository configRepository,
    HelpAndReportRepository helpAndReportRepository,
  ) {
    final helpItems = helpAndReportRepository.getHelpItems();
    return HelpState(
      isEmailValid: true,
      isPhoneValid: true,
      isDesValid: true,
      isSuccess: false,
      isError: false,
      helpItems: helpItems,
      email: userRepository.getCurrentUser().email ?? '',
      phone: userRepository.getCurrentUser().phoneNumber ?? '',
      currentHelpItem:
          (helpItems != null && helpItems.isNotEmpty) ? helpItems[0] : null,
      description: '',
    );
  }

  HelpState copyWith({
    bool isEmailValid,
    bool isPhoneValid,
    bool isDesValid,
    bool isSuccess,
    bool isError,
    String email,
    String phone,
    String description,
    HelpReportModel currentHelpItem,
    List<HelpReportModel> helpItems,
    Country selectedCountry,
    List<Country> listCountry,
  }) {
    return HelpState(
      isEmailValid: isEmailValid ?? this.isEmailValid,
      isPhoneValid: isPhoneValid ?? this.isPhoneValid,
      isDesValid: isDesValid ?? this.isDesValid,
      isSuccess: isSuccess ?? false,
      isError: isError ?? false,
      email: email ?? this.email,
      currentHelpItem: currentHelpItem ?? this.currentHelpItem,
      helpItems: helpItems ?? this.helpItems,
      phone: phone ?? this.phone,
      description: description ?? this.description,
      countrySelected: selectedCountry ?? countrySelected,
      listCountry: listCountry ?? this.listCountry,
    );
  }

  @override
  List<Object> get props => [
        isEmailValid,
        isPhoneValid,
        isDesValid,
        isError,
        isSuccess,
        currentHelpItem,
        email,
        phone,
        description,
        helpItems,
        countrySelected,
        listCountry,
      ];

  @override
  String toString() {
    return '''MyFormState {
      isEmailValid: $isEmailValid,
      isPhoneValid: $isPhoneValid,
      isSuccess: $isSuccess,
      email: $email,
      phone: $phone,
      description: $description,
      countrySelected: $countrySelected,
      listCountry: $listCountry,
    }''';
  }
}
