import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class MyCommunityEvent extends Equatable {
  const MyCommunityEvent();

  @override
  List<Object> get props => [];
}

class FetchMyCommunity extends MyCommunityEvent {

  FetchMyCommunity();

  @override
  List<Object> get props => [];
}

