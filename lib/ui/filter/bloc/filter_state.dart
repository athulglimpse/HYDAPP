import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../data/model/area_item.dart';

@immutable
class FilterState extends Equatable {
  final Map<int, Map> filterOptSelected;
  final AreaItem areaItem;

  FilterState({
    this.filterOptSelected = const <int, Map>{},
    this.areaItem,
  });

  @override
  List<Object> get props => [
        filterOptSelected,
        areaItem,
      ];

  factory FilterState.initial() {
    return FilterState(
      filterOptSelected: const <int, Map>{},
    );
  }

  FilterState copyWith({
    Map filterOptSelected,
    AreaItem areaItem,
  }) {
    return FilterState(
      areaItem: areaItem ?? this.areaItem,
      filterOptSelected: filterOptSelected ?? this.filterOptSelected,
    );
  }

  FilterState clearAll() {
    return FilterState(
      filterOptSelected: const <int, Map>{},
      areaItem: areaItem ?? areaItem,
    );
  }

  FilterState clearOption({int fid}) {
    Map<int, Map> mapFilter;
    if (filterOptSelected.containsKey(fid)) {
      mapFilter = {};
      mapFilter.addAll(filterOptSelected);
      mapFilter.remove(fid);
    }
    return FilterState(
      filterOptSelected: mapFilter ?? filterOptSelected,
      areaItem: areaItem ?? areaItem,
    );
  }

  @override
  String toString() {
    return '''MyFormState {
      filterOptSelected: $filterOptSelected,
      areaItem: $areaItem,
    }''';
  }
}
