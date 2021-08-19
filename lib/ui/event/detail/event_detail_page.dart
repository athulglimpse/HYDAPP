import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shimmer/shimmer.dart';

import '../../../common/constants.dart';
import '../../../common/di/injection/injector.dart';
import '../../../common/localization/lang.dart';
import '../../../common/theme/theme.dart';
import '../../../common/widget/my_listview.dart';
import '../../../common/widget/my_text_view.dart';
import '../../../common/widget/static_maps_provider.dart';
import '../../../data/model/events.dart';
import '../../../data/model/location_model.dart';
import '../../../utils/app_const.dart';
import '../../../utils/navigate_util.dart';
import '../../../utils/ui_util.dart';
import '../../../utils/utils.dart';
import '../../base/base_widget.dart';
import '../../home/components/events_list.dart';
import '../../login/login_page.dart';
import 'bloc/event_detail_bloc.dart';
import 'components/event_title_group.dart';

class EventDetailScreen extends BaseWidget {
  static const routeName = '/EventDetailScreen';
  final EventInfo eventInfo;
  final String id;

  EventDetailScreen({
    this.eventInfo,
    this.id,
  });

  @override
  State<StatefulWidget> createState() {
    return EventDetailScreenState();
  }
}

class EventDetailScreenState extends BaseState<EventDetailScreen> {
  final EventDetailBloc _eventDetailBloc = sl<EventDetailBloc>();
  final refreshController = RefreshController();

  @override
  void initState() {
    super.initState();
    initBasicInfo();

    if (widget.eventInfo != null) {
      _eventDetailBloc.add(CopyEventInfo(widget.eventInfo));
      _eventDetailBloc
          .add(FetchEventDetailInfo(widget.eventInfo.id.toString()));
    } else {
      _eventDetailBloc.add(FetchEventDetailInfo(widget.id));
    }
  }

  void initBasicInfo() {
    _eventDetailBloc.listen((state) {
      if (state.currentRoute == EventRoute.enterRemoveEvent ||
          state.currentRoute == EventRoute.enterTurnOffEvent) {
        NavigateUtil.pop(context, argument: {'initRefresh': true});
      }
      if (refreshController.isRefresh) {
        refreshController.refreshCompleted();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: BlocProvider(
          create: (_) => _eventDetailBloc,
          child: BlocBuilder<EventDetailBloc, EventDetailState>(
              builder: (context, state) {
            if (state.eventDetailInfo == null || state.isRefreshing) {
              return SafeArea(
                child: Center(
                  child: Shimmer.fromColors(
                    baseColor: Colors.grey[300],
                    highlightColor: Colors.grey[100],
                    child: SvgPicture.asset(
                      Res.default_img_write_review,
                      fit: BoxFit.cover,
                      height: sizeImageNormalxxx + sizeNormalx,
                    ),
                  ),
                ),
              );
            }
            return LayoutBuilder(builder: (context, constraints) {
              return Stack(
                children: [
                  Container(
                    height: sizeImageLargexxx,
                    width: constraints.maxWidth,
                    child: UIUtil.makeImageWidget(
                        state?.eventDetailInfo?.image?.url ?? Res.image_lorem,
                        boxFit: BoxFit.cover),
                  ),
                  Container(
                    height: sizeImageSmall,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            colors: [
                          Colors.black.withOpacity(0.8),
                          Colors.black.withOpacity(0)
                        ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter)),
                  ),
                  MyRefreshList(
                    textColorRefresh: Colors.white,
                    enablePullDown: true,
                    onRefresh: () {
                      _eventDetailBloc.add(FetchEventDetailInfo(
                          state.eventDetailInfo.id.toString()));
                    },
                    refreshController: refreshController,
                    listView: SizedBox(
                      height: sizeImageLargexxx,
                      width: constraints.maxWidth,
                    ),
                  ),
                  DraggableScrollableSheet(
                      maxChildSize: 0.88,
                      initialChildSize: 0.7,
                      minChildSize: 0.7,
                      builder: (context, scrollController) {
                        return Container(
                          padding: const EdgeInsets.only(
                            top: sizeVerySmall,
                          ),
                          decoration: const BoxDecoration(
                              color: Color(0xffFDFBF5),
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(sizeNormalxx))),
                          child: SingleChildScrollView(
                            controller: scrollController,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                    left: sizeSmallxxx,
                                    right: sizeSmallxxx,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(
                                        height: sizeNormalxx,
                                      ),
                                      EventTitleGroup(
                                        onClickAddFa: () {
                                          if (state.userInfo.isUser()) {
                                            _eventDetailBloc.add(AddFavorite(
                                                id: state.eventDetailInfo.id
                                                    .toString()));
                                          } else {
                                            NavigateUtil.openPage(
                                                context, LoginPage.routeName);
                                          }
                                        },
                                        onClickShare: () {
                                          Utils.shareContent(
                                              state.eventDetailInfo.title ?? '',
                                              state?.eventDetailInfo
                                                      ?.shareUrl ??
                                                  'http://www.hudayriyat.com/');
                                        },
                                        state: state,
                                      ),
                                      const SizedBox(
                                        height: sizeNormal,
                                      ),
                                      const Divider(
                                        height: 2,
                                        color: Color(0x20212237),
                                      ),
                                      const SizedBox(
                                        height: sizeNormalxx,
                                      ),
                                      MyTextView(
                                        text: Lang.asset_detail_location.tr(),
                                        textStyle: textSmallxxx.copyWith(
                                            color: Colors.black,
                                            fontWeight: MyFontWeight.semiBold,
                                            fontFamily: MyFontFamily.graphik),
                                      ),
                                      const SizedBox(
                                        height: sizeNormal,
                                      ),
                                      SizedBox(
                                        height: sizeImageLargex,
                                        child: renderStaticMap(state
                                            .eventDetailInfo.pickOneLocation),
                                      ),
                                    ],
                                  ),
                                ),
                                if (state?.listEventAlsoLike != null &&
                                    state.listEventAlsoLike.isNotEmpty)
                                  EventsList(
                                      isShowSeeAll: false,
                                      onRemovePost: (e) {
                                        onRemoveEventAlsoLike(e);
                                      },
                                      onTurnOffPost: (e) {
                                        onTurnOffEventAlsoLike(e);
                                      },
                                      title:
                                          Lang.event_more_event_like_this.tr(),
                                      onItemClick: openEventDetail,
                                      padding: const EdgeInsets.only(
                                          left: sizeSmallxxx,
                                          top: sizeLargexx,
                                          right: sizeSmallxxx),
                                      listActivities:
                                          state?.listEventAlsoLike ?? []),
                                const SizedBox(
                                  height: sizeNormal,
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                  SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: sizeSmall, vertical: sizeSmall),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            height: sizeNormalxxx,
                            width: sizeNormalxxx,
                            decoration: const BoxDecoration(
                                shape: BoxShape.circle, color: Colors.white),
                            child: GestureDetector(
                              onTap: () {
                                NavigateUtil.pop(context);
                              },
                              child: Icon(
                                UIUtil.getCircleIconBack(context),
                                color: Colors.black,
                                size: sizeNormalxx,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              UIUtil.showEventDialogMenu(
                                  context: context,
                                  eventDetailInfo: state.eventDetailInfo,
                                  onRemovePost: () {
                                    onRemoveEvent(
                                        state.eventDetailInfo.id.toString());
                                  },
                                  onTurnOffPost: () {
                                    onTurnOffEvent(
                                        state.eventDetailInfo.id.toString());
                                  });
                            },
                            child: Container(
                              width: sizeNormalxxx,
                              height: sizeNormalxxx,
                              alignment: Alignment.center,
                              decoration: const BoxDecoration(
                                  border: Border(
                                      top: BorderSide(
                                        width: 1.0,
                                        color: Colors.white,
                                      ),
                                      left: BorderSide(
                                        width: 1.0,
                                        color: Colors.white,
                                      ),
                                      right: BorderSide(
                                        width: 1.0,
                                        color: Colors.white,
                                      ),
                                      bottom: BorderSide(
                                        width: 1.0,
                                        color: Colors.white,
                                      )),
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(sizeNormalxxx))),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Icon(
                                    Icons.fiber_manual_record_sharp,
                                    color: Colors.white,
                                    size: sizeVerySmall,
                                  ),
                                  SizedBox(
                                    width: sizeIcon,
                                  ),
                                  Icon(
                                    Icons.fiber_manual_record_sharp,
                                    color: Colors.white,
                                    size: sizeVerySmall,
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              );
            });
          }),
        ),
      ),
    );
  }

  void onRemoveEvent(String id) {
    _eventDetailBloc.add(RemoveEvent(id));
  }

  void onTurnOffEvent(String id) {
    _eventDetailBloc.add(TurnOffEvent(id));
  }

  void onRemoveEventAlsoLike(EventInfo e) {
    _eventDetailBloc
        .add(RemoveEventAlsoLike(e.id.toString(), e.category.id.toString()));
  }

  void onTurnOffEventAlsoLike(EventInfo e) {
    _eventDetailBloc
        .add(TurnOffEventAlsoLike(e.id.toString(), e.category.id.toString()));
  }

  Widget renderStaticMap(LocationModel locationModel) {
    return StaticMapsProvider(
      MAP_API_KEY,
      locationModel: locationModel,
      markers: [
        {
          'latitude': double.tryParse(locationModel?.lat ?? '0'),
          'longitude': double.tryParse(locationModel?.long ?? '0')
        },
      ],
      height: sizeImageLargex.round(),
      width: 400,
    );
  }

  void openEventDetail(EventInfo value) {
    NavigateUtil.openPage(context, EventDetailScreen.routeName,
        argument: {'data': value}).then((value) {
      if (value != null && (value as Map).containsKey('initRefresh')) {
        _eventDetailBloc.add(FetchMoreEventLikeThis(
            widget.eventInfo.id.toString(),
            widget.eventInfo.category.id.toString()));
      }
    });
  }

  @override
  void dispose() {
    _eventDetailBloc.close();
    super.dispose();
  }
}
