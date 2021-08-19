import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:marvista/common/localization/lang.dart';
import 'package:meta/meta.dart';

import '../../../common/di/injection/injector.dart';
import '../../../data/model/notification_setting_model.dart';
import '../../../data/repository/notification_repository.dart';
import '../../../data/source/failure.dart';
import '../../../data/source/success.dart';
import '../../../utils/app_const.dart';
import '../../../utils/firebase_wrapper.dart';

part 'notification_setting_event.dart';
part 'notification_setting_state.dart';

class NotificationSettingBloc
    extends Bloc<NotificationSettingEvent, NotificationSettingState> {
  final NotificationRepository notificationRepository;
  final FirebaseWrapper _firebaseWrapper = sl<FirebaseWrapper>();

  NotificationSettingBloc({this.notificationRepository})
      : super(NotificationSettingState.initial(notificationRepository));

  @override
  Stream<NotificationSettingState> mapEventToState(
    NotificationSettingEvent event,
  ) async* {
    if (event is FetchNotificationData) {
      final result = await notificationRepository.fetchNotificationSetting();
      yield* _handleFetchNotificationResult(result);
    } else if (event is OnNotificationItemChange) {
      final status = event.item.status;
      final model = state.notificationItemList
          .firstWhere((element) => element.id == event.item.id);
      model?.status = event.item.status == 1 ? 0 : 1;
      model?.hasChange = model?.status != status;
      yield state.copyWith(
        itemChanged: NotificationSettingModel.fromJson(model.toJson()),
      );
    } else if (event is OnSubmitNotificationSetting) {
      final result = await notificationRepository
          .submitNotificationSetting(state.notificationItemList);
      yield* _handleSubmitNotificationResult(result);
    }
  }

  Stream<NotificationSettingState> _handleSubmitNotificationResult(
      Either<Failure, Success> result) async* {
    yield result.fold(
      (failure) => state.copyWith(
        success: false,
        errorMessage: (failure as RemoteDataFailure).errorMessage,
      ),
      (value) {
        changeNotification(state.notificationItemList);
        return state.copyWith(success: true);
      },
    );
  }

  Stream<NotificationSettingState> _handleFetchNotificationResult(
      Either<Failure, List<NotificationSettingModel>> result) async* {
    yield result.fold(
      (failure) => state,
      (value) => state.copyWith(notificationItemList: value),
    );
  }

  void changeNotification(List<NotificationSettingModel> notificationItemList) {
    var index = 0;
    notificationItemList.forEach((element) {
      if (element.hasChange) {
        if (element.isOn) {
          _firebaseWrapper.subscribeToTopic(getTopicName(index.toString()));
        } else {
          _firebaseWrapper.unsubscribeFromTopic(getTopicName(index.toString()));
        }
      }
      index++;
    });
  }

  String getTopicName(String id) {
    switch (id) {
      case '0':
        return DEFAULT_TOPICS_MARVISTA_ANNOUNCEMENTS;
      case '1':
        return DEFAULT_TOPICS_EVENT;
      case '2':
        return DEFAULT_TOPICS_COMMUNITY_POSTS;
      case '3':
        return DEFAULT_TOPICS_APPROVED_POSTS;
      default:
        return DEFAULT_TOPICS_MARVISTA_ANNOUNCEMENTS;
    }
  }


  @override
  void onTransition(
      Transition<NotificationSettingEvent, NotificationSettingState>
          transition) {
    print(transition);
    super.onTransition(transition);
  }
}
