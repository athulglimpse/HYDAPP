import 'package:after_layout/after_layout.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marvista/utils/ui_util.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../common/di/injection/injector.dart';
import '../../../common/localization/lang.dart';
import '../../../common/theme/theme.dart';
import '../../../common/widget/my_listview.dart';
import '../../../common/widget/my_text_view.dart';
import '../../../data/model/activity_model.dart';
import '../../../utils/navigate_util.dart';
import '../../base/base_widget.dart';
import '../../home/components/weekend_activities_list.dart';
import '../detail/weekend_activity_detail_page.dart';
import 'bloc/weekend_activity_see_all_bloc.dart';

class WeekendActivitySeeAllScreen extends BaseWidget {
  static const routeName = 'WeekendActivitySeeAllScreen';

  final int experienceId;
  final Map<int, Map> filterAdv;

  WeekendActivitySeeAllScreen({
    this.experienceId,
    this.filterAdv,
  });

  @override
  State<StatefulWidget> createState() {
    return WeekendActivitySeeAllScreenState();
  }
}

class WeekendActivitySeeAllScreenState
    extends BaseState<WeekendActivitySeeAllScreen> with AfterLayoutMixin {
  final _amenitySeeAllBloc = sl<WeekendActivitySeeAllBloc>();
  final RefreshController refreshController = RefreshController();

  @override
  void initState() {
    super.initState();
    initBasicInfo();
  }

  void initBasicInfo() {
    _amenitySeeAllBloc.listen((state) {
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
              textStyle: textNormal.copyWith(
                  color: Colors.black,
                  fontWeight: MyFontWeight.bold,
                  fontFamily: MyFontFamily.publicoBanner),
              text: Lang.home_it_a_sunny_weekend_to.tr(),
            ),
          ),
          body: LayoutBuilder(
            builder: (context, constraints) {
              return BlocProvider(
                create: (_) => _amenitySeeAllBloc,
                child: BlocBuilder<WeekendActivitySeeAllBloc,
                    WeekendActivitySeeAllState>(builder: (context, state) {
                  var listItemsTop = state.items;
                  // var listItemsBottom;
                  // if (state.items.length > 3) {
                  //   listItemsTop = state.items.sublist(0, 3);
                  //   listItemsBottom =
                  //       state.items.sublist(3, state.items.length);
                  // }
                  return MyRefreshList(
                    textColorRefresh: Colors.white,
                    enablePullDown: true,
                    onRefresh: () {
                      _amenitySeeAllBloc.add(FetchActivities(
                          experience: widget.experienceId,
                          filterAdv: widget.filterAdv));
                    },
                    refreshController: refreshController,
                    listView: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: sizeNormal, right: sizeNormal),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: listItemsTop
                                      ?.map((e) => Container(
                                            height: sizeImageNormalxxx,
                                            child: CardActivityWidget(
                                              aspectRatio: 1.96,
                                              onItemClick: onItemClick,
                                              padding: const EdgeInsets.all(
                                                  sizeSmall),
                                              activityModel: e,
                                            ),
                                          ))
                                      ?.toList() ??
                                  [],
                            ),
                            const SizedBox(height: sizeNormal),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              );
            },
          ),
        ),
      ),
    );
  }

  void onItemClick(ActivityModel item) {
    NavigateUtil.openPage(context, ActivityDetailScreen.routeName,
        argument: item);
  }

  @override
  void dispose() {
    _amenitySeeAllBloc.close();
    super.dispose();
  }

  @override
  void afterFirstLayout(BuildContext context) {
    if (refreshController != null) {
      refreshController.requestRefresh();
    }
  }
}
