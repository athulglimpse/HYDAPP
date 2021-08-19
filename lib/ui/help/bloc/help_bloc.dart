import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';

import '../../../data/model/country.dart';
import '../../../data/repository/config_repository.dart';
import '../../../data/repository/help_report_repository.dart';
import '../../../data/repository/user_repository.dart';
import '../../../data/source/failure.dart';
import '../../../utils/string_util.dart';
import '../../../utils/utils.dart';
import 'help_event.dart';
import 'help_state.dart';

class HelpBloc extends Bloc<HelpEvent, HelpState> {
  final HelpAndReportRepository helpAndReportRepository;
  final UserRepository userRepository;
  final ConfigRepository configRepository;

  HelpBloc(
      {@required this.userRepository,
      @required this.helpAndReportRepository,
      @required this.configRepository})
      : super(HelpState.initial(
            userRepository, configRepository, helpAndReportRepository));

  @override
  Stream<HelpState> mapEventToState(HelpEvent event) async* {
    if (event is EmailChanged) {
      yield state.copyWith(
          isEmailValid: event.email.isEmpty || Utils.isValidEmail(event.email),
          email: event.email);
    } else if (event is DesChanged) {
    } else if (event is OnSelectHelpItem) {
      yield state.copyWith(
        currentHelpItem: event.helpItem,
      );
    } else if (event is PhoneChanged) {
      yield state.copyWith(
          isPhoneValid: validateMobile(event.phone) == null,
          phone: event.phone);
    } else if (event is DescriptionChanged) {
      yield state.copyWith(
          isDesValid:
              event.description.isEmpty || event.description.length >= 10,
          description: event.description);
    } else if (event is LoadCountryCode) {
      yield* _handleGetCountryCodeResult(event);
    } else if (event is OnSelectCountryCode) {
      yield state.copyWith(selectedCountry: event.countryStatus);
    } else if (event is FetchHelpItems) {
      yield* _handleFetchHelpItemsResult();
    } else if (event is SendHelp) {
      final result = await helpAndReportRepository.sendHelpItems(event.content,
          event.helpTopic, event.email, event.mobile, event.dialCode);
      yield result.fold((l) => state.copyWith(isError: true),
          (r) => state.copyWith(isSuccess: true));
    }
  }

  Stream<HelpState> _handleGetCountryCodeResult(LoadCountryCode event) async* {
    final result = await configRepository.getCountryCode();
    yield result.fold(
      (failure) => state,
      (country) {
        return state.copyWith(
            listCountry: country, selectedCountry: country[0]);
      },
    );
  }

  Stream<HelpState> _handleFetchHelpItemsResult() async* {
    final helpInfo = await helpAndReportRepository.fetchHelpItems();
    yield helpInfo.fold(
          (l) => state,
          (r) => state.copyWith(
          helpItems: r,
          currentHelpItem: (r != null && r.isNotEmpty) ? r[0] : state.currentHelpItem),
    );
  }
}
