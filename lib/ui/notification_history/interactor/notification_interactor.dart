import 'package:dartz/dartz.dart';

import '../../../data/model/notification_history_model.dart';
import '../../../data/source/failure.dart';
import '../../../data/source/success.dart';
import '../bloc/notification_history_bloc.dart';

abstract class NotificationHistoryInteract {
  Stream<NotificationHistoryState> handleNotificationHistoryResult(
      Either<Failure, List<NotificationHistoryModel>> result,
      NotificationHistoryState state);

  Stream<NotificationHistoryState> handleTurnOffNotificationFromOwnerResult(
      Either<Failure, Success> result, NotificationHistoryState state);

  Stream<NotificationHistoryState> handleRemoveNotificationResult(
      Either<Failure, Success> result, NotificationHistoryState state);
}
