import 'package:after_layout/after_layout.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marvista/utils/date_util.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../common/constants.dart';
import '../../common/di/injection/injector.dart';
import '../../common/localization/lang.dart';
import '../../common/theme/theme.dart';
import '../../common/widget/my_listview.dart';
import '../../common/widget/my_text_view.dart';
import '../../data/model/notification_history_model.dart';
import '../../data/source/api_end_point.dart';
import '../../utils/navigate_util.dart';
import '../../utils/ui_util.dart';
import '../assets/asset_detail/asset_detail_page.dart';
import '../base/base_widget.dart';
import '../community/community_detail/community_detail_page.dart';
import '../event/detail/event_detail_page.dart';
import 'bloc/notification_history_bloc.dart';

class NotificationHistoryScreen extends BaseWidget {
  static const routeName = 'NotificationHistoryScreen';

  NotificationHistoryScreen();

  @override
  State<StatefulWidget> createState() {
    return NotificationHistoryScreenState();
  }
}

class NotificationHistoryScreenState
    extends BaseState<NotificationHistoryScreen> with AfterLayoutMixin {
  final _notificationHistoryBloc = sl<NotificationHistoryBloc>();
  final refreshController = RefreshController();

  @override
  void initState() {
    super.initState();
    // _notificationHistoryBloc.add(FetchNotificationData());
    _notificationHistoryBloc.listen((state) {
      if (refreshController.isRefresh) {
        refreshController.refreshCompleted();
      }
      if (refreshController.isLoading) {
        refreshController.loadComplete();
      }
    });
  }

  void initBasicInfo() {}

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      color: const Color(0xffFDFBF5),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: const Color(0xffFDFBF5),
          appBar: AppBar(
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
              onPressed: () {
                NavigateUtil.pop(context);
              },
            ),
            elevation: 0,
            backgroundColor: const Color(0xffFDFBF5),
            title: MyTextView(
              textAlign: TextAlign.center,
              textStyle: textNormal.copyWith(color: Colors.black),
              text: Lang.settings_notifications.tr(),
            ),
          ),
          body: BlocProvider(
            create: (_) => _notificationHistoryBloc,
            child:
                BlocBuilder<NotificationHistoryBloc, NotificationHistoryState>(
                    builder: (context, state) {
              return MyRefreshList(
                refreshController: refreshController,
                enablePullDown: true,
                enablePullUp: true,
                onLoading: () {
                  _notificationHistoryBloc.add(FetchMoreNotificationData());
                },
                onRefresh: () {
                  _notificationHistoryBloc.add(FetchNotificationData());
                },
                listView: ListView.builder(
                  padding: const EdgeInsets.only(
                      left: sizeSmallxxx, right: sizeSmallxxx),
                  itemCount: state?.notificationItemHistoryList?.length ?? 0,
                  itemBuilder: (context, position) {
                    return TweenAnimationBuilder(
                        tween: Tween<double>(begin: 0, end: 1),
                        duration: Duration(milliseconds: 300 + position * 100),
                        curve: Curves.linear,
                        builder: (_, offset, __) {
                          return Opacity(
                            opacity: offset,
                            child: notificationItemWidget(
                                state.notificationItemHistoryList[position],
                                context),
                          );
                        });
                  },
                ),
              );
            }),
          ),
        ),
      ),
    );
  }

  Widget notificationItemWidget(NotificationHistoryModel item, BuildContext context) {
    return GestureDetector(
      onTap: () {
        onClickNotification(item);
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: sizeSmall),
        child: Container(
          height: sizeExLargex,
          margin: const EdgeInsets.only(top: sizeSmallxx),
          decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 1,
                  offset: const Offset(0, 1.5),
                  // changes position of shadow
                ),
              ],
              borderRadius: const BorderRadius.all(Radius.circular(sizeSmall))),
          child: Row(
            children: [
              (item.type == PARAM_EVENT_DETAILS
                  ? ClipRRect(
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(sizeSmall),
                          bottomLeft: Radius.circular(sizeSmall)),
                      child: UIUtil.makeImageWidget(
                          item?.data?.image?.url ?? Res.image_lorem,
                          height: sizeExLargex,
                          width: sizeExLargex,
                          boxFit: BoxFit.fill),
                    )
                  : const SizedBox()),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: sizeSmallxxx, vertical: sizeSmallxxx),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: MyTextView(
                          textAlign: TextAlign.start,
                          text: item?.data?.content ?? '',
                          maxLine: 2,
                          textStyle: textSmallx.copyWith(
                              color: const Color(0xff212237),
                              fontWeight: MyFontWeight.regular,
                              fontFamily: MyFontFamily.graphik),
                        ),
                      ),
                      MyTextView(
                        text: DateUtil.convertDateTime(
                          item?.datetime.toString() ?? '',
                          locale: context.locale.languageCode
                        ),
                        textStyle: textSmall.copyWith(
                            color: const Color(0xff212237).withOpacity(0.5),
                            fontWeight: MyFontWeight.regular,
                            fontFamily: MyFontFamily.graphik),
                      )
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: sizeSmallxxx),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    (item.isNew ?? false)
                        ? const Icon(
                            Icons.fiber_manual_record,
                            color: Color(0xffE75D52),
                            size: sizeSmall,
                          )
                        : const SizedBox(),
                    Expanded(
                      child: IconButton(
                        icon: const Icon(
                          Icons.more_horiz,
                          color: Color(0xffD9D9E8),
                        ),
                        onPressed: () {
                          UIUtil.showNotificationDialogMenu(
                              context: context,
                              historyModel: item,
                              onRemoveNotification: () {
                                onRemoveNotification(item);
                              },
                              onTurnOffNotification: () {
                                onTurnOffNotification(item);
                              });
                        },
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void onRemoveNotification(NotificationHistoryModel item) {
    _notificationHistoryBloc.add(RemoveNotification(item));
  }

  void onTurnOffNotification(NotificationHistoryModel item) {
    _notificationHistoryBloc.add(TurnOffNotification(item));
  }

  @override
  void dispose() {
    refreshController.dispose();
    _notificationHistoryBloc.close();
    super.dispose();
  }

  void onClickNotification(NotificationHistoryModel item) {
    print(item.type);
    switch (item.type) {
      case PARAM_MY_POST:
      case PARAM_COMMUNITY_POST:
      case PARAM_COMMENT:
        NavigateUtil.openPage(context, CommunityDetailScreen.routeName,
            argument: {
              'id': item?.data?.postId?.toString() ??
                  item?.data?.amenityId?.toString()
            }).then((value) {
          _notificationHistoryBloc.add(TagReady(item));
        });
        break;
      case PARAM_AMENITY:
        NavigateUtil.openPage(context, AssetDetailScreen.routeName, argument: {
          'id': item?.data?.postId?.toString() ??
              item?.data?.amenityId?.toString()
        }).then((value) {
          _notificationHistoryBloc.add(TagReady(item));
        });
        break;
      case PARAM_EVENT_DETAILS:
        NavigateUtil.openPage(context, EventDetailScreen.routeName,
            argument: {'id': item?.data?.eventId?.toString()}).then((value) {
          _notificationHistoryBloc.add(TagReady(item));
        });
        break;
      default:
        break;
    }
  }

  @override
  void afterFirstLayout(BuildContext context) {
    refreshController?.requestRefresh(
        duration: const Duration(milliseconds: 300));
  }
}
