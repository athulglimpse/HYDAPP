import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:marvista/data/source/api_end_point.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../common/constants.dart';
import '../../../common/di/injection/injector.dart';
import '../../../common/dialog/event_date_picker_dialog.dart';
import '../../../common/dialog/sort_tool_dialog.dart';
import '../../../common/localization/lang.dart';
import '../../../common/theme/theme.dart';
import '../../../common/widget/input_field_rect.dart';
import '../../../common/widget/my_listview.dart';
import '../../../common/widget/my_text_view.dart';
import '../../../common/widget/search_empty_widget.dart';
import '../../../data/model/events.dart';
import '../../../utils/app_const.dart';
import '../../../utils/navigate_util.dart';
import '../../../utils/ui_util.dart';
import '../../base/base_widget.dart';
import '../../home/components/events_list.dart';
import '../detail/event_detail_page.dart';
import 'bloc/event_bloc.dart';

class EventScreen extends BaseWidget {
  static const routeName = 'EventScreen';

  EventScreen();

  @override
  State<StatefulWidget> createState() {
    return EventScreenState();
  }
}

class EventScreenState extends BaseState<EventScreen> {
  final EventBloc _eventBloc = sl<EventBloc>();
  final FocusNode _searchFocusNode = FocusNode();
  final RefreshController refreshController = RefreshController();
  final ScrollController scrollController = ScrollController();
  final TextEditingController _controllerSearch = TextEditingController();
  final GlobalKey key = GlobalKey();

  @override
  void initState() {
    super.initState();
    _eventBloc.add(FetchEventCategory());
    _eventBloc.add(SelectEventCategory(id: '0'));
    _eventBloc.listen((state) async {
      // await Future.delayed(const Duration(milliseconds: 3000));
      if (refreshController.isRefresh) {
        refreshController.refreshCompleted();
      }
    });
  }

  void showDateFilter(EventState state) {
    UIUtil.showDialogAnimation(
            hasDragDismiss: true,
            child: EventDatePickerDialog(
              filterDates: state.listFilterDates,
              currentFilterDate: state.currentFilterDate,
              startDate: state.startDate,
              endDate: state.endDate,
            ),
            context: context)
        .then((value) {
      if (value != null) {
        _eventBloc.add(FetchEvents(
            startDate: value[EventDatePickerDialogState.filterStartDateKey],
            endDate: value[EventDatePickerDialogState.filterEndDateKey],
            filterDateModel:
                value[EventDatePickerDialogState.filterDateTypeKey]));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).viewPadding.bottom;
    super.build(context);
    return Scaffold(
      body: LayoutBuilder(builder: (context, constraints) {
        return BlocProvider(
          create: (_) => _eventBloc,
          child: BlocBuilder<EventBloc, EventState>(builder: (context, state) {
            return SafeArea(
              child: Container(
                color: const Color(0xffFDFBF5),
                padding: const EdgeInsets.only(top: sizeSmall),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        left: sizeSmallxxx,
                        right: sizeSmallxxx,
                      ),
                      child: Column(
                        children: [
                          !isMVP
                              ? GestureDetector(
                                  onTap: () => showDateFilter(state),
                                  child: Row(
                                    children: [
                                      const ClipOval(
                                        child: Material(
                                          color: Color(0xffFBBC43),
                                          // button color
                                          child: SizedBox(
                                              width: sizeNormal,
                                              height: sizeNormal,
                                              child: Icon(
                                                Icons.calendar_today_sharp,
                                                size: sizeSmallx,
                                              )),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: sizeVerySmall,
                                      ),
                                      MyTextView(
                                        text: state.currentFilterDate.name,
                                        textStyle: textNormalxxx.copyWith(
                                            color: Colors.black,
                                            fontFamily:
                                                MyFontFamily.publicoBanner,
                                            fontWeight: MyFontWeight.bold),
                                      ),
                                      const SizedBox(
                                        width: sizeVerySmall,
                                      ),
                                      const Icon(
                                        Icons.keyboard_arrow_down,
                                        size: sizeNormalx,
                                      ),
                                    ],
                                  ))
                              : MyTextView(
                                  text: Lang.event_events.tr(),
                                  textStyle: textNormalxx.copyWith(
                                      fontFamily: MyFontFamily.graphik,
                                      fontWeight: MyFontWeight.medium),
                                ),
                          const SizedBox(
                            height: sizeNormalxx,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  height: sizeLargex,
                                  child: InputFieldRect(
                                    controller: _controllerSearch,
                                    focusNode: _searchFocusNode,
                                    onSubmit: _onSearchChanged,
                                    cusPreIcon: _getSearchButton(state),
                                    cusSubIcon: _getClearButton(state),
                                    textAlign: TextAlign.start,
                                    hintStyle: textSmallx.copyWith(
                                        color: const Color(0xffb9b9b9),
                                        fontWeight: MyFontWeight.regular),
                                    borderColor: Colors.transparent,
                                    borderRadius: sizeSmall,
                                    textStyle: textSmallx.copyWith(
                                        color: Colors.black),
                                    hintText:
                                        Lang.home_looking_for_something.tr(),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: sizeSmallxxx,
                              ),
                              GestureDetector(
                                  onTap: () {
                                    UIUtil.showDialogAnimation(
                                            hasDragDismiss: true,
                                            child: SortToolDialog(
                                              currentValue: state.sortType,
                                              hasSoonest: true,
                                            ),
                                            context: context)
                                        .then((value) {
                                      if (value != null &&
                                          (value as Map)
                                              .containsKey('sort_type')) {
                                        _eventBloc.add(
                                            OnSortEvent(value['sort_type']));
                                      }
                                    });
                                  },
                                  child: Material(
                                    color: Colors.white,
                                    elevation: sizeVerySmall,
                                    borderRadius:
                                        BorderRadius.circular(sizeSmall),
                                    child: Container(
                                        padding:
                                            const EdgeInsets.all(sizeSmall+2),
                                        child: UIUtil.makeImageWidget(
                                            (context.locale.languageCode
                                                        .toUpperCase() ==
                                                    PARAM_EN)
                                                ? Res.sort_en
                                                : Res.sort_ar,
                                            width: sizeNormal,
                                            height: sizeNormal,
                                            color: const Color(0xff419c9b),
                                            boxFit: BoxFit.contain)),
                                  ))
                            ],
                          ),
                          const SizedBox(
                            height: sizeNormal,
                          ),
                        ],
                      ),
                    ),
                    categoriesRender(state),
                    const SizedBox(
                      height: sizeSmall,
                    ),
                    Expanded(
                      child: MyRefreshList(
                        refreshController: refreshController,
                        enablePullDown: true,
                        onRefresh: () {
                          _eventBloc.add(FetchEvents(
                              // category:
                              //     state.currentEventCateId.toString() ?? '0',
                              category: '0',
                              filterDateModel: state.currentFilterDate));
                          // _eventBloc.add(SelectEventCategory(
                          //     id: state.currentEventCateId.toString() ?? '0'));
                        },
                        listView: SingleChildScrollView(
                          physics: const ScrollPhysics(),
                          controller: scrollController,
                          child: Container(
                            constraints: BoxConstraints(
                                minHeight: constraints.maxHeight),
                            child: Column(
                              children: <Widget>[
                                _renderEvents(state),
                                SizedBox(
                                  height: bottomPadding + sizeLargexxx,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        );
      }),
    );
  }

  Widget categoriesRender(EventState state) {
    return Container(
      height: sizeNormalxxx,
      child: ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: sizeSmall),
          scrollDirection: Axis.horizontal,
          itemCount: state.eventCategories?.length ?? 0,
          itemBuilder: (e, index) {
            final category = state.eventCategories[index];
            return GestureDetector(
              onTap: () async {
                onClearSearch();
                _eventBloc.add(SelectEventCategory(id: category.id.toString()));
                // await Future.delayed(const Duration(milliseconds: 300));
                // await refreshController.requestRefresh(
                //     duration: const Duration(milliseconds: 300));
              },
              child: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(
                    vertical: sizeVerySmallx, horizontal: sizeSmallxxx),
                margin: const EdgeInsets.only(right: sizeSmall),
                decoration: BoxDecoration(
                    border: category.id != state.currentEventCateId
                        ? Border.all(color: Colors.grey)
                        : null,
                    color: category.id == state.currentEventCateId
                        ? const Color(0xff419C9B)
                        : Colors.transparent,
                    borderRadius:
                        const BorderRadius.all(Radius.circular(sizeVerySmall))),
                child: MyTextView(
                  textAlign: TextAlign.center,
                  text: category.name,
                  textStyle: textSmallxx.copyWith(
                      color: category.id == state.currentEventCateId
                          ? Colors.white
                          : Colors.grey),
                ),
              ),
            );
          }),
    );
  }

  Widget _getSearchButton(EventState state) {
    return GestureDetector(
      onTap: () {
        _onSearchChanged(_controllerSearch.text);
      },
      child: const Icon(
        Icons.search,
        color: Colors.black,
        size: sizeNormal,
      ),
    );
  }

  void onClearSearch() {
    _controllerSearch.clear();
    FocusScope.of(context).unfocus();
    _eventBloc.add(OnClearSearch());
  }

  void onItemClickEvent(EventInfo value) {
    NavigateUtil.openPage(context, EventDetailScreen.routeName,
        argument: {'data': value}).then((value) {
      if (value != null && (value as Map).containsKey('initRefresh')) {
        refreshController.requestRefresh(
            needMove: true, duration: const Duration(milliseconds: 300));
      }
    });
  }

  Widget _getClearButton(state) {
    if (_searchFocusNode.hasFocus) {
      return GestureDetector(
        onTap: onClearSearch,
        child: const Padding(
          padding: EdgeInsets.all(sizeVerySmall),
          child: Icon(
            Icons.clear,
            color: Colors.black,
            size: sizeNormal,
          ),
        ),
      );
    }
    return null;
  }

  Widget _renderEvents(EventState state) {
    if (state is SearchResultState) {
      var hasItems = false;
      state?.events?.entries?.forEach((value) {
        if (value.value.isNotEmpty) {
          hasItems = true;
        }
      });
      if (!hasItems) {
        return SearchEmptyWidget(keyWord: state.keyWord);
      }
      return Column(
        children: state?.events?.entries?.map(_renderEventItem)?.toList() ?? [],
      );
    }
    final len = state?.groupEvents[state.currentEventCateId.toString()]?.entries
            ?.length ??
        0;
    return (len > 0)
        ? TweenAnimationBuilder(
            tween: Tween<Offset>(
                begin: const Offset(0, 1), end: const Offset(0, 0)),
            duration: const Duration(milliseconds: 300),
            curve: Curves.linear,
            builder: (_, offset, __) {
              return FractionalTranslation(
                  translation: offset,
                  child: Column(
                    children: state
                            ?.groupEvents[state.currentEventCateId.toString()]
                            ?.entries
                            ?.map(_renderEventItem)
                            ?.toList() ??
                        [],
                  ));
            },
          )
        : SearchEmptyWidget(
            justInformEmpty: true,
            keyWord: Lang.event_no_events_at_this_time.tr(),
          );
  }

  Widget _renderEventItem(MapEntry<String, List<EventInfo>> e) {
    return (e.value.isNotEmpty)
        ? Padding(
            padding: const EdgeInsets.only(top: sizeNormal),
            child: EventsList(
              isShowSeeAll: false,
              onRemovePost: (e) {
                _eventBloc.add(RemoveEvent(e.id.toString()));
              },
              onTurnOffPost: (e) {
                _eventBloc.add(TurnOffEvent(e.id.toString()));
              },
              onItemClick: onItemClickEvent,
              listActivities: e.value,
            ),
          )
        : const SizedBox();
  }

  @override
  void dispose() {
    _eventBloc.close();
    _searchFocusNode.dispose();
    _controllerSearch.dispose();
    scrollController.dispose();
    refreshController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String content) {
    _eventBloc.add(SearchEventChanged(
      textSearch: content,
      cateId: _eventBloc.state.currentEventCateId.toString(),
    ));
  }
}
