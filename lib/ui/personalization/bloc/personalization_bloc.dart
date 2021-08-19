import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:marvista/common/localization/lang.dart';
import 'package:marvista/utils/ui_util.dart';
import 'package:marvista/utils/utils.dart';
import 'package:meta/meta.dart';

import '../../../data/model/personalization_item.dart';
import '../../../data/repository/personalize_repository.dart';
import '../../../data/repository/user_repository.dart';
import '../../../data/source/failure.dart';
import '../../../data/source/success.dart';

import 'package:easy_localization/easy_localization.dart';
part 'personalization_event.dart';
part 'personalization_state.dart';

class PersonalizationBloc
    extends Bloc<PersonalizationEvent, PersonalizationState> {
  final PersonalizeRepository personalizeRepository;
  final UserRepository userRepository;

  PersonalizationBloc({
    @required this.personalizeRepository,
    @required this.userRepository,
  }) : super(PersonalizationState.initial(personalizeRepository));

  @override
  Stream<PersonalizationState> mapEventToState(
    PersonalizationEvent event,
  ) async* {
    if (event is SubmitPersonalization) {
      final result = await userRepository.submitPersonalization(
          state.personalizationItemList.where((e) => e.selected).toList(),
          state.listChild);
      await userRepository.getMe();
      yield* _handlePersonalizationSubmitResult(result);
    } else if (event is OnClickBack) {
      yield state.copyWith(isChildScreen: false, groupChildSelectedId: '');
    } else if (event is NextPhase) {
      var listChild = <Items>[];
      state.personalizationItemList
          .where((e) => e.selected)
          .toList()
          .forEach((child) {
        child.items.forEach((e) {
          e.selected = false;
        });
        listChild.addAll(child.items);
      });
      listChild = Utils.reduceListItemPersonalizeRecent(listChild);
      yield state.copyWith(
          isChildScreen: true, listChild: listChild..shuffle());
    } else if (event is OnSelectChildItem) {
      event.child.selected = !event.child.selected;
      var groupItemId = state.groupChildSelectedId;

      if (event.child.selected) {
        groupItemId += '${event.child.id},';
      } else {
        groupItemId = groupItemId.replaceAll('${event.child.id},', '');
      }
      yield state.copyWith(groupChildSelectedId: groupItemId);
    } else if (event is OnSelectItem) {
      event.personalizationItemItem.selected =
          !event.personalizationItemItem.selected;
      var groupItemId = state.groupSelectedId;

      ///Limit selected item
        final sameItem = state.personalizationItemList.firstWhere(
            (element) => element.id == event.personalizationItemItem.id);
        if (sameItem == null) {
          yield state.copyWith(
              personalizationItemList: state.personalizationItemList,
              groupSelectedId: groupItemId);
          return;
        }
      if (event.personalizationItemItem.selected) {
        groupItemId += '${event.personalizationItemItem.id.toString()},';
      } else {
        groupItemId = groupItemId.replaceAll(
            '${event.personalizationItemItem.id.toString()},', '');
      }

      yield state.copyWith(
          personalizationItemList: state.personalizationItemList,
          groupSelectedId: groupItemId);
    }
  }

  Stream<PersonalizationState> _handlePersonalizationSubmitResult(
    Either<Failure, Success> result,
  ) async* {
    yield result.fold(
      (failure) => state.copyWith(submitSuccess: false),
      (userInfo) => state.copyWith(submitSuccess: true),
    );
  }
}
