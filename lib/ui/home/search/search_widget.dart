import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/localization/lang.dart';
import '../../../common/theme/theme.dart';
import '../../../common/widget/my_text_view.dart';
import '../../../common/widget/search_empty_widget.dart';
import '../../../data/model/events.dart';
import '../../../data/model/places_model.dart';
import '../../../data/model/recent_model.dart';
import '../../../utils/navigate_util.dart';
import '../../assets/asset_detail/asset_detail_page.dart';
import '../../assets/asset_see_all/asset_see_all_grid_page.dart';
import '../../assets/asset_see_all/asset_see_all_list_page.dart';
import '../../event/detail/event_detail_page.dart';
import '../components/events_list.dart';
import '../components/short_list_assets.dart';
import 'bloc/homesearch_bloc.dart';
import 'widgets/recent_widget.dart';

class SearchWidget extends StatefulWidget {
  final String keyWord;
  final TextEditingController controllerSearch;
  final List<PlaceModel> listTrending;
  final int experienceId;

  const SearchWidget({
    Key key,
    @required this.keyWord,
    this.controllerSearch,
    this.listTrending,
    this.experienceId,
  }) : super(key: key);

  @override
  _SearchWidgetState createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  HomeSearchBloc get homeSearchBloc => BlocProvider.of<HomeSearchBloc>(context);

  @override
  void initState() {
    homeSearchBloc.add(GetSearchRecentEvent(experienceId: widget.experienceId));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeSearchBloc, HomeSearchState>(
      builder: (context, state) {
        if (state is HomeSearchSuccess) {
          if (state.events.isEmpty && state.amenities.isEmpty) {
            return SearchEmptyWidget(
              keyWord: widget.keyWord,
            );
          }

          return SingleChildScrollView(
            child: Column(
              children: [
                if (state.events?.isNotEmpty ?? false)
                  EventsList(
                    isShowSeeAll: false,
                    onItemClick: (e) {
                      openEventDetail(e);
                    },
                    padding: const EdgeInsets.only(
                        left: sizeSmallxxx, right: sizeSmallxxx),
                    listActivities: state.events ?? [],
                  ),
                if (state.amenities?.isNotEmpty ?? false)
                  ShortListAssets(
                    title: Lang.home_amenities.tr(),
                    shortAssetType: ShortAssetType.NORMAL,
                    isShowAll: false,
                    onItemClick: openAssetDetail,
                    padding: const EdgeInsets.only(
                        left: sizeSmallxxx, right: sizeSmallxxx),
                    listActivities: state.amenities,
                  ),
                const SizedBox(height: 70),
              ],
            ),
          );
        } else if (state is Searching) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is HomeSearchDisplayed) {
          var recentToday = <RecentModel>[];
          var recentYesterday = <RecentModel>[];
          if (state.recentModels?.isNotEmpty ?? false) {
            recentToday = state.recentTodayModels;
            recentYesterday = state.recentYesModels;
          }

          return SingleChildScrollView(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(sizeNormal),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  if (recentToday?.isNotEmpty ?? false) ...[
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: MyTextView(
                        text: Lang.home_today.tr(),
                        textAlign: TextAlign.start,
                        textStyle: textSmallxxx.copyWith(color: Colors.black45),
                      ),
                    ),
                    ...List.generate(recentToday?.length ?? 0, (index) {
                      final recent = recentToday[index];
                      return GestureDetector(
                        onTap: () {
                          widget.controllerSearch.text = recent.content;
                          homeSearchBloc
                              .add(SearchkeyWordEvent(keyword: recent.content));
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: sizeSmall),
                          child: RecentWidget(
                            title: recent.content,
                            subTitle: recent.search_date,
                          ),
                        ),
                      );
                    }),
                  ],
                  if (recentYesterday?.isNotEmpty ?? false) ...[
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: MyTextView(
                        text: Lang.home_yesterday.tr(),
                        textAlign: TextAlign.start,
                        textStyle: textSmallxxx.copyWith(color: Colors.black45),
                      ),
                    ),
                    ...List.generate(recentYesterday?.length ?? 0, (index) {
                      final recent = recentYesterday[index];
                      return GestureDetector(
                        onTap: () {
                          widget.controllerSearch.text = recent.content;
                          homeSearchBloc
                              .add(SearchkeyWordEvent(keyword: recent.content));
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: sizeSmall),
                          child: RecentWidget(
                            title: recent.content,
                            subTitle: recent.search_date,
                          ),
                        ),
                      );
                    }),
                  ],
                  if (state is HomeSearchDisplayed &&
                      (widget.listTrending?.isNotEmpty ?? false)) ...[
                    ShortListAssets(
                      onItemClick: openAssetDetail,
                      onClickAll: onClickSeeAllList,
                      title: Lang.home_trending_this_week.tr(),
                      shortAssetType: ShortAssetType.SMALL,
                      padding: const EdgeInsets.only(
                          left: sizeSmallxxx,
                          top: sizeLargexx,
                          right: sizeSmallxxx),
                      listActivities: widget.listTrending ?? [],
                    ),
                    const SizedBox(
                      height: sizeLarge,
                    )
                  ]
                ],
              ),
            ),
          );
        }
        return const SizedBox(
          width: double.infinity,
        );
      },
    );
  }

  void onClickSeeAllList() {
    NavigateUtil.openPage(context, AssetSeeAllListScreen.routeName, argument: {
      'type': ViewAssetType.TRENDING_THIS_WEEK,
      'experId': homeSearchBloc.state.experienceId
    });
  }

  void openAssetDetail(PlaceModel value) {
    NavigateUtil.openPage(context, AssetDetailScreen.routeName,
        argument: {'data': value});
  }

  void openEventDetail(EventInfo value) {
    NavigateUtil.openPage(context, EventDetailScreen.routeName,
        argument: {'data': value});
  }
}
