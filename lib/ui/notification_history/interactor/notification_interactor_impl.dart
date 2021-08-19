import 'package:dartz/dartz.dart';

import '../../../data/model/notification_history_model.dart';
import '../../../data/source/failure.dart';
import '../../../data/source/success.dart';
import '../bloc/notification_history_bloc.dart';
import 'notification_interactor.dart';

class NotificationHistoryInteractImpl extends NotificationHistoryInteract {
  NotificationHistoryInteractImpl();

  @override
  Stream<NotificationHistoryState> handleNotificationHistoryResult(
      Either<Failure, List<NotificationHistoryModel>> result,
      NotificationHistoryState state) async* {
    yield result.fold(
      (failure) => state,
      (value) => state.copyWith(notificationItemHistoryList: value),
    );
  }

  @override
  Stream<NotificationHistoryState> handleRemoveNotificationResult(
      Either<Failure, Success> result, NotificationHistoryState state) async* {
    yield result.fold(
      (failure) => state,
      (value) => state,
    );
  }

  @override
  Stream<NotificationHistoryState> handleTurnOffNotificationFromOwnerResult(
      Either<Failure, Success> result, NotificationHistoryState state) async* {
    yield result.fold(
      (failure) => state,
      (value) => state,
    );
  }
}
