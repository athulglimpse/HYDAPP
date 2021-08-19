part of 'started_bloc.dart';

@immutable
class StartedState {
  final StaticContent staticContent;
  final int currentIndexContent;
  final bool guestLoginSuccess;
  final String selectedLanguage;
  final List<Language> arrLanguage;

  StartedState({
    @required this.staticContent,
    @required this.guestLoginSuccess,
    @required this.selectedLanguage,
    @required this.arrLanguage,
    this.currentIndexContent,
  });

  factory StartedState.initial(HomeRepository homeRepository,
      StaticContentRepository staticContentRepository) {
    return StartedState(
      staticContent: staticContentRepository.getLocalStaticContent(),
      selectedLanguage: 'En',
      arrLanguage: null,
      guestLoginSuccess: false,
      currentIndexContent: 0,
    );
  }

  StartedState copyWith({
    int indexContent,
    StaticContent staticContent,
    bool guestLoginSuccess,
    String selectedLanguage,
    List<Language> arrLanguage,
  }) {
    return StartedState(
      staticContent: staticContent ?? this.staticContent,
      arrLanguage: arrLanguage ?? this.arrLanguage,
      selectedLanguage: selectedLanguage ?? this.selectedLanguage,
      guestLoginSuccess: guestLoginSuccess ?? false,
      currentIndexContent: indexContent ?? currentIndexContent,
    );
  }

  StartedState updateStaticContent({StaticContent staticContent}) {
    return StartedState(
      staticContent: staticContent,
      currentIndexContent: currentIndexContent,
      guestLoginSuccess: guestLoginSuccess,
      selectedLanguage: selectedLanguage,
      arrLanguage: arrLanguage,
    );
  }

  StartedState updateGuestStatus({bool guestLoginSuccess}) {
    return StartedState(
      staticContent: staticContent,
      currentIndexContent: currentIndexContent,
      guestLoginSuccess: guestLoginSuccess ?? this.guestLoginSuccess,
      selectedLanguage: selectedLanguage,
      arrLanguage: arrLanguage,
    );
  }

  StartedState updateSelectedLanguage({String selectedLanguage}) {
    return StartedState(
      selectedLanguage: selectedLanguage,
      arrLanguage: arrLanguage,
      staticContent: staticContent,
      guestLoginSuccess: guestLoginSuccess,
      currentIndexContent: currentIndexContent,
    );
  }

  StartedState initLanguage(
      {List<Language> arrLanguage, String selectedLanguage}) {
    return StartedState(
      selectedLanguage: selectedLanguage ?? arrLanguage[0].code,
      arrLanguage: arrLanguage,
      staticContent: staticContent,
      guestLoginSuccess: guestLoginSuccess,
      currentIndexContent: currentIndexContent,
    );
  }

  List<Object> get props => [
        staticContent,
        guestLoginSuccess,
        currentIndexContent,
        selectedLanguage,
        arrLanguage
      ];

  @override
  String toString() {
    return '''MyState {
      currentIndexContent: $currentIndexContent,
      selectedLanguage: $selectedLanguage,
      arrLanguage: $arrLanguage,
      staticContent: $staticContent,
      guestLoginSuccess: $guestLoginSuccess,
    }''';
  }
}
