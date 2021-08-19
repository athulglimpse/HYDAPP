part of 'deactivate_account_bloc.dart';

@immutable
class DeactivateAccountState extends Equatable {
  final List<MoreItem> moreItems;
  final MoreItem currentValue;
  final StatusDeActive status;

  DeactivateAccountState({
    this.moreItems,
    this.status = StatusDeActive.NONE,
    this.currentValue,
  });

  factory DeactivateAccountState.initial() {
    return DeactivateAccountState();
  }

  DeactivateAccountState copyWith(
      {List<MoreItem> moreItems,
      MoreItem currentValue,
      StatusDeActive status}) {
    return DeactivateAccountState(
      moreItems: moreItems ?? this.moreItems,
      status: status ?? StatusDeActive.NONE,
      currentValue: currentValue ?? this.currentValue,
    );
  }

  @override
  List<Object> get props => [moreItems, status, currentValue];

  @override
  String toString() {
    return '''MyFormState {
   
    }''';
  }
}

class LogoutSuccess extends DeactivateAccountState {}

enum StatusDeActive {
  NONE,
  FAIL,
  SUCCESS,
}
