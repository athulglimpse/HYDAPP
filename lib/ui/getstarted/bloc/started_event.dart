part of 'started_bloc.dart';

@immutable
abstract class StartedEvent {}

class DoLoginAsGuest extends StartedEvent {}

class LoadStartedContent extends StartedEvent {}

class InitLang extends StartedEvent {
  final String language;

  InitLang(this.language);
}

class OnChangeLanguage extends StartedEvent {
  final Language language;

  OnChangeLanguage({@required this.language});

  List<Object> get props => [language];
}

class OnIndexContentChange extends StartedEvent {
  final int index;

  OnIndexContentChange(this.index);
}
