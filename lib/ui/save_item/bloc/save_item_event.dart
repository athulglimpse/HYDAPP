import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class SaveItemEvent extends Equatable {
  const SaveItemEvent();

  @override
  List<Object> get props => [];
}

class FetchSaveItem extends SaveItemEvent {
  final String experienceId;

  FetchSaveItem({@required this.experienceId});

  @override
  List<Object> get props => [experienceId];
}

class FetchLocalSaveItem extends SaveItemEvent {
  final String experienceId;

  FetchLocalSaveItem({@required this.experienceId});

  @override
  List<Object> get props => [experienceId];
}

class SelectArea extends SaveItemEvent {
  final String experienceId;

  SelectArea({@required this.experienceId});

  @override
  List<Object> get props => [experienceId];
}