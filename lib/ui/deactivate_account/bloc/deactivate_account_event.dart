part of 'deactivate_account_bloc.dart';

@immutable
abstract class DeactivateAccountEvent {}

class InitData extends DeactivateAccountEvent {
  final List<MoreItem> moreItems;

  InitData(this.moreItems);
}

class OnSelectItem extends DeactivateAccountEvent {
  final MoreItem item;

  OnSelectItem(this.item);

}


class SubmitDeactivateAccount extends DeactivateAccountEvent {
  final String reason;

  SubmitDeactivateAccount({this.reason});
}

class Logout extends DeactivateAccountEvent {}
