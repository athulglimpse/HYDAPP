part of 'personalization_bloc.dart';

@immutable
abstract class PersonalizationEvent extends Equatable {
  const PersonalizationEvent();

  @override
  List<Object> get props => [];
}

class OnSelectItem extends PersonalizationEvent {
  final PersonalizationItem personalizationItemItem;

  OnSelectItem(this.personalizationItemItem);
}

class OnSelectChildItem extends PersonalizationEvent {
  final Items child;

  OnSelectChildItem(this.child);
}

class NextPhase extends PersonalizationEvent {}

class OnClickBack extends PersonalizationEvent {}

class SubmitPersonalization extends PersonalizationEvent {}
