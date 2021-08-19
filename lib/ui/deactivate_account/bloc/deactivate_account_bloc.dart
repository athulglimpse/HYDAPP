import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:marvista/data/model/more_item.dart';
import 'package:marvista/utils/ui_util.dart';
import 'package:meta/meta.dart';

import '../../../data/repository/profile_repository.dart';
import '../../../data/repository/user_repository.dart';
import '../../../data/source/failure.dart';
import '../../../data/source/success.dart';

part 'deactivate_account_event.dart';
part 'deactivate_account_state.dart';

class DeactivateAccountBloc
    extends Bloc<DeactivateAccountEvent, DeactivateAccountState> {
  final ProfileRepository profileRepository;
  final UserRepository userRepository;

  DeactivateAccountBloc({this.profileRepository, this.userRepository})
      : super(DeactivateAccountState.initial());

  @override
  Stream<DeactivateAccountState> mapEventToState(
    DeactivateAccountEvent event,
  ) async* {
    switch (event.runtimeType) {
      case OnSelectItem:
        yield state.copyWith(currentValue: (event as OnSelectItem).item);
        break;
      case InitData:
        yield state.copyWith(moreItems: (event as InitData).moreItems);
        break;
      case SubmitDeactivateAccount:
        final result = await profileRepository
            .deActivateAccount((event as SubmitDeactivateAccount).reason);
        yield* _handleSubmitDeactivateAccountResult(result);
        break;
      case Logout:
        await userRepository.logout();
        yield LogoutSuccess();
        break;
      default:
        break;
    }
  }

  Stream<DeactivateAccountState> _handleSubmitDeactivateAccountResult(
      Either<Failure, Success> result) async* {
    yield result.fold(
      (l) {
        UIUtil.showToast((l as RemoteDataFailure).errorMessage);
        return state.copyWith(status: StatusDeActive.FAIL);
      },
      (value) {
        add(Logout());
        return state;
      },
    );
  }
}
