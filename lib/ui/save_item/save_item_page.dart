import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marvista/data/model/post_detail.dart';
import 'package:marvista/ui/community/community_detail/community_detail_page.dart';
import 'package:marvista/utils/ui_util.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../common/di/injection/injector.dart';
import '../../common/localization/lang.dart';
import '../../common/theme/theme.dart';
import '../../common/widget/my_listview.dart';
import '../../common/widget/my_text_view.dart';
import '../../common/widget/search_empty_widget.dart';
import '../../data/model/events.dart';
import '../../data/model/places_model.dart';
import '../../data/model/save_item_model.dart';
import '../../data/source/api_end_point.dart';
import '../../utils/navigate_util.dart';
import '../assets/asset_detail/asset_detail_page.dart';
import '../base/base_widget.dart';
import '../event/detail/event_detail_page.dart';
import 'bloc/bloc.dart';
import 'components/card_save_item.dart';

class SaveItemPage extends BaseWidget {
  static const routeName = 'SaveItemPage';

  SaveItemPage();

  @override
  State<StatefulWidget> createState() {
    return SaveItemPageState();
  }
}

class SaveItemPageState extends BaseState<SaveItemPage> {
  final SaveItemBloc _saveItemBloc = sl<SaveItemBloc>();
  final RefreshController refreshController = RefreshController();

  @override
  void initState() {
    super.initState();
    initBasicInfo();
  }

  void initBasicInfo() {
    _saveItemBloc.add(FetchLocalSaveItem(experienceId: '0'));
    _saveItemBloc.add(FetchSaveItem(experienceId: '0'));
    _saveItemBloc.listen((state) {
      if (refreshController.isRefresh) {
        refreshController.refreshCompleted();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      color: const Color(0xffFDFBF5),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            elevation: 0,
            centerTitle: true,
            leading: IconButton(
              icon: Icon(
                UIUtil.getCircleIconBack(context),
                color: Colors.black,
                size: sizeNormalxx,
              ),
              onPressed: () {
                NavigateUtil.pop(context);
              },
            ),
            backgroundColor: const Color(0xffFDFBF5),
            title: MyTextView(
              textStyle: textNormal.copyWith(color: Colors.black),
              text: Lang.profile_saved_items_title.tr(),
            ),
          ),
          body: LayoutBuilder(
            builder: (context, constraints) {
              return BlocProvider(
                create: (_) => _saveItemBloc,
                child: BlocBuilder<SaveItemBloc, SaveItemState>(
                    builder: (context, state) {
                  final len =
                      state.groupSaveItems[state.currentAreaId]?.length ?? 0;
                  return Column(
                    children: [
                      categoriesRender(state),
                      if (len <= 0)
                        SearchEmptyWidget(
                          justInformEmpty: true,
                        ),
                      Expanded(
                        child: MyRefreshList(
                          refreshController: refreshController,
                          enablePullDown: true,
                          onRefresh: () {
                            _saveItemBloc.add(FetchSaveItem(
                                experienceId: state.currentAreaId.toString()));
                          },
                          listView: ListView.builder(
                            itemCount: len,
                            scrollDirection: Axis.vertical,
                            itemBuilder: (BuildContext context, int index) {
                              final e = state
                                  .groupSaveItems[state.currentAreaId][index];
                              return TweenAnimationBuilder(
                                  tween: Tween<double>(begin: 0, end: 1),
                                  duration:
                                      Duration(milliseconds: 300 + index * 100),
                                  curve: Curves.linear,
                                  builder: (_, offset, __) {
                                    return Opacity(
                                      opacity: offset,
                                      child: Container(
                                        margin: const EdgeInsets.only(
                                            left: sizeNormal,
                                            right: sizeNormal,
                                            bottom: sizeSmallxx),
                                        child: CardSaveItem(
                                          height: sizeImageLarge,
                                          onItemClick: onClickSaveItem,
                                          item: e,
                                        ),
                                      ),
                                    );
                                  });
                            },
                          ),
                        ),
                      ),
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

  Widget categoriesRender(SaveItemState state) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: sizeSmall),
      height: sizeNormalxxx,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: sizeNormal),
          itemCount: state.listAreas?.length ?? 0,
          itemBuilder: (e, index) {
            final areaItem = state.listAreas[index];
            return GestureDetector(
              onTap: () async {
                _saveItemBloc
                    .add(SelectArea(experienceId: areaItem.id.toString()));
              },
              child: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(
                    vertical: sizeVerySmallx, horizontal: sizeSmallxxx),
                margin: const EdgeInsets.only(right: sizeSmall),
                decoration: BoxDecoration(
                    border: areaItem.id != state.currentAreaId
                        ? Border.all(color: Colors.grey)
                        : null,
                    color: areaItem.id == state.currentAreaId
                        ? const Color(0xff419C9B)
                        : Colors.transparent,
                    borderRadius:
                        const BorderRadius.all(Radius.circular(sizeVerySmall))),
                child: MyTextView(
                  textAlign: TextAlign.center,
                  text: areaItem.name,
                  textStyle: textSmallxx.copyWith(
                      color: areaItem.id == state.currentAreaId
                          ? Colors.white
                          : const Color(0xff419C9B)),
                ),
              ),
            );
          }),
    );
  }

  void onClickSaveItem(SaveItemModel item) {
    switch (item.type) {
      case PARAM_EVENT_DETAILS:
        openEventDetail(EventInfo.convertFromSaveItem(item));
        break;
      case 'photo':
      case 'review':
        openPostDetail(PostDetail.convertFromSaveItem(item));
        break;
      case PARAM_AMENITIES_DETAILS:
        openAssetDetail(PlaceModel.convertFromSaveItem(item));
        break;
    }
  }

  void openPostDetail(PostDetail value) {
    NavigateUtil.openPage(context, CommunityDetailScreen.routeName,
        argument: {'data': value}).then((value) {
      refreshController.requestRefresh();
    });
  }

  void openAssetDetail(PlaceModel value) {
    NavigateUtil.openPage(context, AssetDetailScreen.routeName,
        argument: {'data': value}).then((value) {
      refreshController.requestRefresh();
    });
  }

  void openEventDetail(EventInfo value) {
    NavigateUtil.openPage(context, EventDetailScreen.routeName,
        argument: {'data': value}).then((value) {
      refreshController.requestRefresh();
    });
  }

  @override
  void dispose() {
    _saveItemBloc.close();
    refreshController.dispose();
    super.dispose();
  }
}
