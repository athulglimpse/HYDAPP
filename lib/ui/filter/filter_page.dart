import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marvista/ui/filter/components/icon_multi_selection.dart';
import 'package:marvista/ui/filter/components/icon_single_selection.dart';
import 'package:marvista/utils/date_util.dart';

import '../../common/di/injection/injector.dart';
import '../../common/localization/lang.dart';
import '../../common/theme/theme.dart';
import '../../common/widget/my_button.dart';
import '../../common/widget/my_text_view.dart';
import '../../data/model/area_item.dart';
import '../../utils/navigate_util.dart';
import '../base/base_widget.dart';
import 'bloc/filter_bloc.dart';
import 'bloc/filter_event.dart';
import 'bloc/filter_state.dart';
import 'components/multi_selection.dart';
import 'components/range_date.dart';
import 'components/range_slider_view.dart';
import 'components/selection.dart';
import 'components/slider_view.dart';
import 'util/filter_util.dart';

class FilterPage extends BaseWidget {
  static const routeName = 'FilterPage';
  final AreaItem areaItem;
  final Map<int, Map> filterOptSelected;
  FilterPage({
    this.filterOptSelected,
    this.areaItem,
  });

  @override
  State<StatefulWidget> createState() {
    return FilterPageState();
  }
}

class FilterPageState extends BaseState<FilterPage> {
  final FilterBloc _filterBloc = sl<FilterBloc>();

  @override
  void initState() {
    super.initState();
    initBasicInfo();
  }

  void initBasicInfo() {
    print(widget.filterOptSelected);
    _filterBloc.add(ReStoreFilter(
      filterOptSelected: widget.filterOptSelected,
    ));
    _filterBloc.add(SelectedAreaItem(areaItem: widget.areaItem));
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      color: const Color(0xffffffff),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: const Color(0xffffffff),
          appBar: AppBar(
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
              onPressed: () {
                NavigateUtil.pop(context);
              },
            ),
            elevation: 0,
            backgroundColor: const Color(0xffffffff),
            title: MyTextView(
              textStyle: textSmallxxx.copyWith(
                  color: Colors.black, fontWeight: FontWeight.bold),
              text: Lang.home_filters.tr(),
            ),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  _filterBloc.add(ClearAllFilter());
                },
                shape: const CircleBorder(
                    side: BorderSide(color: Colors.transparent)),
                child: MyTextView(
                  textStyle: textSmallxx.copyWith(
                      color: const Color(0xff419c9b),
                      fontWeight: FontWeight.bold),
                  text: Lang.home_clear_all.tr(),
                ),
              ),
            ],
          ),
          body: LayoutBuilder(
            builder: (context, constraints) {
              return BlocProvider(
                create: (_) => _filterBloc,
                child: BlocBuilder<FilterBloc, FilterState>(
                    builder: (context, state) {
                  if (state == null) {
                    return const SizedBox();
                  }
                  return Stack(
                    fit: StackFit.expand,
                    children: [
                      Positioned.fill(
                        child: ListView.builder(
                            itemCount: widget?.areaItem?.filter?.length ?? 0,
                            padding: const EdgeInsets.only(bottom: sizeExLarge),
                            itemBuilder: (BuildContext context, int index) {
                              final filterArea = widget.areaItem.filter[index];
                              return Padding(
                                padding:
                                    const EdgeInsets.only(bottom: sizeLarge),
                                child: getLayoutByState(state, filterArea),
                              );
                            }),
                      ),
                      Positioned.fill(
                        bottom: sizeLargexxx,
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: MyButton(
                            text: Lang.home_apply_filter.tr(),
                            onTap: () {
                              print(state.filterOptSelected);
                              NavigateUtil.pop(context,
                                  argument:
                                      _filterBloc.state.filterOptSelected);
                            },
                            paddingHorizontal: sizeLargexxx,
                            textStyle: textSmallxxx.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                            buttonColor: const Color(0xff242655),
                          ),
                        ),
                      ),
                      const SizedBox(height: sizeLarge)
                    ],
                  );
                }),
              );
            },
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _filterBloc.close();
    super.dispose();
  }

  Widget getLayoutByState(FilterState state, FilterArea filterArea) {
    print(filterArea.type);
    switch (getTypeByEnum(filterArea.type)) {
      case FilterComponentEnum.SLIDER:
        return createSliderView(state, filterArea);
      case FilterComponentEnum.RANGE_SLIDER:
        return createRangeSliderView(state, filterArea);
      case FilterComponentEnum.ICON_SINGLE_SELECTION:
        return createIconSingleSelectionView(state, filterArea);
      case FilterComponentEnum.ICON_MULTI_SELECTION:
        return createIconMultiSelectionView(state, filterArea);
      case FilterComponentEnum.DATE:
        return createDateRangeView(state, filterArea);
      case FilterComponentEnum.SELECTION:
        return createSelectionView(state, filterArea);
      case FilterComponentEnum.MULTI_SELECTION:
        return createMultiSelectionView(state, filterArea);
      default:
        return const SizedBox();
    }
  }

  Widget createDateRangeView(FilterState state, FilterArea filterArea) {
    final String startDate = state.filterOptSelected.containsKey(filterArea.fid)
        ? state.filterOptSelected[filterArea.fid][FILTER_KEY_START_DATE]
        : null;
    final String endDate = state.filterOptSelected.containsKey(filterArea.fid)
        ? state.filterOptSelected[filterArea.fid][FILTER_KEY_END_DATE]
        : null;
    return RangeDateView(
      itemFilter: filterArea,
      onClearSelection: onClearSlider,
      onSelectEndDate: (f, date) {
        _filterBloc.add(DateChange(
            f.fid,
            f.type,
            f.key,
            startDate,
            DateUtil.dateFormatYYYYMMdd(date,
                format: DateUtil.DATE_FORMAT_DDMMYYYY)));
      },
      onSelectStartDate: (f, date) {
        _filterBloc.add(DateChange(
          f.fid,
          f.type,
          f.key,
          DateUtil.dateFormatYYYYMMdd(date,
              format: DateUtil.DATE_FORMAT_DDMMYYYY),
          endDate,
        ));
      },
      startDate: (startDate != null && startDate.isNotEmpty)
          ? DateUtil.convertStringToDate(startDate,
              formatData: DateUtil.DATE_FORMAT_DDMMYYYY)
          : null,
      endDate: (endDate != null && endDate.isNotEmpty)
          ? DateUtil.convertStringToDate(endDate,
              formatData: DateUtil.DATE_FORMAT_DDMMYYYY)
          : null,
    );
  }

  Widget createSliderView(FilterState state, FilterArea filterArea) {
    final defaultValue = state.filterOptSelected.containsKey(filterArea.fid)
        ? state.filterOptSelected[filterArea.fid][FILTER_KEY_VALUE]
        : 50.0;
    final maxValue = double.parse(filterArea.filterItem[1].number);
    final minValue = double.parse(filterArea.filterItem[0].number);

    return SliderView(
      min: minValue,
      max: maxValue,
      itemFilter: filterArea,
      onClearSlider: onClearSlider,
      value: defaultValue,
      onChange: onChangeSlider,
    );
  }

  Widget createRangeSliderView(FilterState state, FilterArea filterArea) {
    final maxValue = double.parse(filterArea.filterItem[1].number);
    final minValue = double.parse(filterArea.filterItem[0].number);
    final Map<String, double> defaultValue =
        state.filterOptSelected.containsKey(filterArea.fid)
            ? state.filterOptSelected[filterArea.fid][FILTER_KEY_VALUE]
            : {
                FILTER_KEY_VALUE_LEFT: (maxValue / 2) - (maxValue / 4),
                FILTER_KEY_VALUE_RIGHT: (maxValue / 2) + (maxValue / 4)
              };
    return RangeSliderView(
      itemFilter: filterArea,
      min: minValue,
      max: maxValue,
      valueLeft: defaultValue[FILTER_KEY_VALUE_LEFT],
      valueRight: defaultValue[FILTER_KEY_VALUE_RIGHT],
      onClearRangeSlider: onClearSlider,
      onDragCompleted: onChangeRangeSlider,
    );
  }

  Widget createSelectionView(FilterState state, FilterArea filterArea) {
    final defaultValue = state.filterOptSelected.containsKey(filterArea.fid)
        ? state.filterOptSelected[filterArea.fid][FILTER_KEY_VALUE]
        : null;
    return SelectionView(
      itemFilter: filterArea,
      itemSelected: defaultValue,
      onClearSelection: onClearSlider,
      onSelectItem: onSelectItem,
    );
  }

  Widget createIconSingleSelectionView(
      FilterState state, FilterArea filterArea) {
    final defaultValue = state.filterOptSelected.containsKey(filterArea.fid)
        ? state.filterOptSelected[filterArea.fid][FILTER_KEY_VALUE]
        : null;
    return IconSingleSelectionView(
      itemFilter: filterArea,
      itemSelected: defaultValue,
      onClearSelection: onClearSlider,
      onSelectItem: onSelectItem,
    );
  }

  Widget createIconMultiSelectionView(
      FilterState state, FilterArea filterArea) {
    final Map<int, FilterItem> defaultValue =
        state.filterOptSelected.containsKey(filterArea.fid)
            ? state.filterOptSelected[filterArea.fid][FILTER_KEY_VALUE]
            : null;
    return IconMultiSelectionView(
      itemFilter: filterArea,
      itemSelected: defaultValue,
      onClearSelection: onClearSlider,
      onSelectItem: onMultiSelectItem,
    );
  }

  Widget createMultiSelectionView(FilterState state, FilterArea filterArea) {
    final Map<int, FilterItem> defaultValue =
        state.filterOptSelected.containsKey(filterArea.fid)
            ? state.filterOptSelected[filterArea.fid][FILTER_KEY_VALUE]
            : null;
    return MultiSelectionView(
      itemFilter: filterArea,
      itemSelected: defaultValue,
      onClearMultiSelection: onClearSlider,
      onSelectItem: onMultiSelectItem,
    );
  }

  void onChangeSlider(
      FilterArea filterArea, int index, double lowerValue, double upperValue) {
    _filterBloc.add(SliderChanged(
        fid: filterArea.fid,
        type: filterArea.type,
        key: filterArea.key,
        sliderValue: lowerValue));
  }

  void onChangeRangeSlider(FilterArea filterArea, int index, dynamic lowerValue,
      dynamic upperValue) {
    final valueRange = <String, double>{
      FILTER_KEY_VALUE_LEFT: lowerValue,
      FILTER_KEY_VALUE_RIGHT: upperValue
    };
    _filterBloc.add(RangeSliderChanged(
        fid: filterArea.fid,
        type: filterArea.type,
        key: filterArea.key,
        rangeSliderValue: valueRange));
  }

  void onSelectItem(FilterArea filterArea, FilterItem item) {
    _filterBloc.add(SelectedChanged(
        key: filterArea.key,
        fid: filterArea.fid,
        type: filterArea.type,
        itemSelected: item));
  }

  void onMultiSelectItem(FilterArea filterArea, FilterItem item) {
    _filterBloc.add(MultiSelectedChanged(
        key: filterArea.key,
        fid: filterArea.fid,
        type: filterArea.type,
        itemMultiSelected: item));
  }

  void onClearSlider(FilterArea filterArea) {
    _filterBloc.add(ClearOptionFilter(fid: filterArea.fid));
  }
}
