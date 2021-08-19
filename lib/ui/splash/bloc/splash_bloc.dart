import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:marvista/data/repository/help_report_repository.dart';
import 'package:meta/meta.dart';

import '../../../data/model/user_info.dart';
import '../../../data/repository/config_repository.dart';
import '../../../data/repository/home_repository.dart';
import '../../../data/repository/personalize_repository.dart';
import '../../../data/repository/static_content_repository.dart';
import '../../../data/repository/user_repository.dart';

part 'splash_event.dart';
part 'splash_state.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  final UserRepository userRepository;
  final HelpAndReportRepository helpAndReportRepository;
  final ConfigRepository configRepository;
  final PersonalizeRepository personalizeRepository;
  final HomeRepository homeRepository;
  final StaticContentRepository staticContentRepository;

  SplashBloc({
    @required this.userRepository,
    @required this.configRepository,
    @required this.homeRepository,
    @required this.helpAndReportRepository,
    @required this.personalizeRepository,
    @required this.staticContentRepository,
  }) : super(null);

  SplashState _determineSession() {
    final user = userRepository.getCurrentUser();
    if (user != null) {
      return Logged(user);
    } else {
      return SignedOut();
    }
  }

  @override
  Stream<SplashState> mapEventToState(SplashEvent event) async* {
    if (event is FetchConfig) {
      // ignore: unawaited_futures
      helpAndReportRepository.fetchHelpItems();
      // ignore: unawaited_futures
      helpAndReportRepository.fetchReportItems();
      await configRepository.fetchAppConfig();
      await personalizeRepository.fetchListPersonalizeItems();
      await staticContentRepository.fetchStaticContent();
      await homeRepository.fetchListExperiences();
      add(CheckUserLogin());
    } else if (event is FetchOnlyConfig) {
      await configRepository.fetchAppConfig();
    }else if (event is CheckUserLogin) {
      yield _determineSession();
    }
  }
}
