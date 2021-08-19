import 'package:equatable/equatable.dart';

import '../../../data/model/area_item.dart';
import '../../../data/model/save_item_model.dart';
import '../../../data/repository/home_repository.dart';
import '../../../data/repository/profile_repository.dart';

class SaveItemState extends Equatable {
  final List<SaveItemModel> listSaveItem;
  final List<AreaItem> listAreas;
  final Map<int, List<SaveItemModel>> groupSaveItems;
  final int currentAreaId;

  SaveItemState({
    this.listSaveItem,
    this.listAreas,
    this.groupSaveItems,
    this.currentAreaId,
  });

  factory SaveItemState.initial(
      ProfileRepository profileRepository, HomeRepository homeRepository) {
    final areas = homeRepository.getExperiences();
    return SaveItemState(
      listSaveItem: const [],
      listAreas: areas,
      groupSaveItems: const {},
      currentAreaId: 0,
    );
  }

  SaveItemState copyWith({
    List<SaveItemModel> listSaveItem,
    List<AreaItem> listAreas,
    Map<int, List<SaveItemModel>> groupSaveItems,
    int currentAreaId,
  }) {
    return SaveItemState(
      listSaveItem: listSaveItem ?? this.listSaveItem,
      listAreas: listAreas ?? this.listAreas,
      groupSaveItems: groupSaveItems ?? this.groupSaveItems,
      currentAreaId: currentAreaId ?? this.currentAreaId,
    );
  }

  @override
  List<Object> get props => [
        listSaveItem,
        listAreas,
        groupSaveItems,
        currentAreaId,
      ];

  @override
  String toString() {
    return '''MyFormState {
    listSaveItem:$listSaveItem,
    listAreas:$listAreas,
    currentAreaId:$currentAreaId,
    }''';
  }
}
