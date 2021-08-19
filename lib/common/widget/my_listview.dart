import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:marvista/common/localization/lang.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../theme/theme.dart';
import 'package:easy_localization/easy_localization.dart';

class MyRefreshList extends StatelessWidget {
  final RefreshController refreshController;
  final Function onRefresh;
  final Function onLoading;
  final Color textColorRefresh;
  final bool enablePullDown;
  final bool enablePullUp;
  final ScrollController scrollController;
  final Axis scrollDirection;
  final ScrollPhysics scrollPhysics;
  final Widget listView;
  final String textIdle;

  const MyRefreshList({
    Key key,
    @required this.refreshController,
    this.onRefresh,
    this.scrollPhysics = const ScrollPhysics(),
    this.enablePullDown = false,
    this.enablePullUp = false,
    this.scrollDirection = Axis.vertical,
    this.textColorRefresh = Colors.grey,
    this.onLoading,
    this.listView,
    this.textIdle,
    this.scrollController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
      enablePullDown: enablePullDown,
      enablePullUp: enablePullUp,
      scrollDirection: scrollDirection,
      physics: scrollPhysics,
      scrollController: scrollController,
      header: WaterDropHeader(
        complete: Text(Lang.community_refresh_completed.tr(),
            style: textSmallxx.copyWith(color: textColorRefresh)),
        waterDropColor: textColorRefresh,
      ),
      footer: CustomFooter(
        builder: (BuildContext context, LoadStatus mode) {
          Widget body;
          if (mode == LoadStatus.idle) {
            body = Text(
              '',
              style: textSmallxx.copyWith(color: textColorRefresh),
            );
          } else if (mode == LoadStatus.loading) {
            body = const CupertinoActivityIndicator();
          } else if (mode == LoadStatus.failed) {
            body = Text('Load Failed!Click retry!',
                style: textSmallxx.copyWith(color: textColorRefresh));
          } else if (mode == LoadStatus.canLoading) {
            body =
                Text('', style: textSmallxx.copyWith(color: textColorRefresh));
          } else {
            body =
                Text('', style: textSmallxx.copyWith(color: textColorRefresh));
          }
          return Container(
            height: 55.0,
            child: Center(child: body),
          );
        },
      ),
      controller: refreshController,
      onRefresh: onRefresh,
      onLoading: onLoading,
      child: listView,
    );
  }
}
