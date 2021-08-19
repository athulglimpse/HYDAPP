part of 'main_bloc.dart';

class MainState extends Equatable {
  final int currentTab;
  MainState({@required this.currentTab});

  factory MainState.initial() {
    return MainState(
      currentTab: TAB_HOME,
    );
  }

  MainState copyWith({int currentTab}) {
    return MainState(currentTab: currentTab ?? this.currentTab);
  }

  @override
  List<Object> get props => [currentTab];

  @override
  String toString() {
    return '''MainState {
      currentTab: $currentTab,
    }''';
  }
}

const int TAB_HOME = 0;
const int TAB_MAP = 1;
const int TAB_EVENT = 2;
const int TAB_SETTING = 3;
