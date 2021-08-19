import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/model/save_item_model.dart';
import '../../../data/repository/home_repository.dart';
import '../../../data/repository/profile_repository.dart';
import '../../../data/source/failure.dart';
import 'save_item_event.dart';
import 'save_item_state.dart';

class SaveItemBloc extends Bloc<SaveItemEvent, SaveItemState> {
  final ProfileRepository profileRepository;
  final HomeRepository homeRepository;

  SaveItemBloc(
      {@required this.profileRepository, @required this.homeRepository})
      : super(SaveItemState.initial(profileRepository, homeRepository));

  @override
  Stream<SaveItemState> mapEventToState(SaveItemEvent event) async* {
    if (event is FetchSaveItem) {
      final defaultExperience =
          (state.listAreas?.length ?? 0) > 0 ? state.listAreas[0].id : 0;
      final result =
          await profileRepository.fetchSaveItem(defaultExperience.toString());
      yield* _handleGetSaveItemResult(result, defaultExperience);
    } else if (event is FetchLocalSaveItem) {
      final result = profileRepository.getListSaveItem(event.experienceId);

      final defaultExperience =
          (state.listAreas?.length ?? 0) > 0 ? state.listAreas[0].id : 0;

      final groupSaveItems = <int, List<SaveItemModel>>{};
      if (result != null && result.isNotEmpty) {
        state.listAreas.forEach((element) {
          groupSaveItems[element?.id ?? 0] = result
              .where((e) => (e?.experience?.id ?? 0) == element?.id)
              .toList();
        });
        groupSaveItems[defaultExperience] = result;
      }

      yield state.copyWith(
          listSaveItem: result, groupSaveItems: groupSaveItems);
    } else if (event is SelectArea) {
      yield state.copyWith(currentAreaId: int.parse(event.experienceId));
    }
  }

  Stream<SaveItemState> _handleGetSaveItemResult(
      Either<Failure, List<SaveItemModel>> result,
      int defaultExperience) async* {
    yield result.fold(
      (failure) => state,
      (value) {
        final groupSaveItems = <int, List<SaveItemModel>>{};
        if (value != null && value.isNotEmpty) {
          state.listAreas.forEach((element) {
            groupSaveItems[element?.id ?? 0] = value
                .where((e) => (e?.experience?.id ?? 0) == element?.id)
                .toList();
          });
          groupSaveItems[defaultExperience] = value;
        }
        return state.copyWith(
            groupSaveItems: groupSaveItems,
            listSaveItem: value,
            currentAreaId: defaultExperience);
      },
    );
  }
}
