part of 'main_bloc.dart';

@immutable
abstract class MainEvent {}

class OnTabHome extends MainEvent {}
class OnTabEvent extends MainEvent {}
class OnTabMap extends MainEvent {}
class OnTabSetting extends MainEvent {}
