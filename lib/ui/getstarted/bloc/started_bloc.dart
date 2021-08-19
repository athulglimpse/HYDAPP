import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:marvista/data/repository/help_report_repository.dart';
import 'package:marvista/data/repository/home_repository.dart';
import 'package:marvista/data/repository/personalize_repository.dart';
import 'package:meta/meta.dart';

import '../../../common/di/injection/injector.dart';
import '../../../data/model/language.dart';
import '../../../data/model/static_content.dart';
import '../../../data/model/user_info.dart';
import '../../../data/repository/static_content_repository.dart';
import '../../../data/repository/user_repository.dart';
import '../../../data/source/failure.dart';
import '../../../utils/utils.dart';
import '../../base/bloc/base_bloc.dart';

part 'started_event.dart';

part 'started_state.dart';

class StartedBloc extends Bloc<StartedEvent, StartedState> {
  final StaticContentRepository staticContentRepository;
  final HomeRepository homeRepository;
  final UserRepository userRepository;
  final PersonalizeRepository personalizeRepository;
  final HelpAndReportRepository helpAndReportRepository;
  StartedBloc({
    @required this.staticContentRepository,
    @required this.homeRepository,
    @required this.userRepository,
    @required this.personalizeRepository,
    @required this.helpAndReportRepository,
  }) : super(StartedState.initial(homeRepository,staticContentRepository));

  @override
  Stream<StartedState> mapEventToState(
    StartedEvent event,
  ) async* {
    if (event is InitLang) {
      final result = await staticContentRepository.getLanguage();
      yield* _handleGetLanguageResult(result, selectedLanguage: event.language);
    } else if (event is LoadStartedContent) {
      final result = await staticContentRepository.fetchStaticContent();
      yield result.fold(
        (failure) => state,
        (r) => state.copyWith(staticContent: r),
      );
    } else if (event is DoLoginAsGuest) {
      final deviceId = await Utils.getDeviceDetails();
      final deviceToken = await Utils.getDeviceToken();
      final result = await userRepository.loginAsGuest(deviceId, deviceToken);
      yield* _handleGuestLoginResult(result);
    } else if (event is OnIndexContentChange) {
      yield state.copyWith(indexContent: event.index);
    } else if (event is OnChangeLanguage) {
      await staticContentRepository.fetchStaticContent();
      await homeRepository.fetchListExperiences();
      await personalizeRepository.fetchListPersonalizeItems();
      await helpAndReportRepository.fetchHelpItems();
      await helpAndReportRepository.fetchReportItems();
      yield state.copyWith(selectedLanguage: event.language.code);
      add(LoadStartedContent());
    }
  }

  Stream<StartedState> _handleGuestLoginResult(
    Either<Failure, UserInfo> result,
  ) async* {
    yield result.fold(
      (failure) => state.copyWith(guestLoginSuccess: false),
      (userInfo) {
        sl<BaseBloc>().add(OnProfileChange());
        return state.copyWith(guestLoginSuccess: true);
      },
    );
  }

  Stream<StartedState> _handleGetLanguageResult(
      Either<Failure, List<Language>> result,
      {String selectedLanguage}) async* {
    yield result.fold(
      (failure) => state,
      (language) => state.initLanguage(
        arrLanguage: language,
        selectedLanguage: selectedLanguage,
      ),
    );
  }
}
