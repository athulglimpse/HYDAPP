import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marvista/utils/ui_util.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../common/di/injection/injector.dart';
import '../../common/localization/lang.dart';
import '../../common/theme/theme.dart';
import '../../common/widget/my_listview.dart';
import '../../common/widget/my_text_view.dart';
import '../../common/widget/search_empty_widget.dart';
import '../../utils/navigate_util.dart';
import '../base/base_widget.dart';
import 'bloc/my_community_bloc.dart';
import 'bloc/my_community_event.dart';
import 'bloc/my_community_state.dart';
import 'components/card_my_community.dart';

class MyCommunityPage extends BaseWidget {
  static const routeName = 'MyCommunityPage';

  MyCommunityPage();

  @override
  State<StatefulWidget> createState() {
    return MyCommunityPageState();
  }
}

class MyCommunityPageState extends BaseState<MyCommunityPage> {
  final MyCommunityBloc _myCommunityBloc = sl<MyCommunityBloc>();
  final RefreshController refreshController = RefreshController();

  @override
  void initState() {
    super.initState();
    initBasicInfo();
  }

  void initBasicInfo() {
    _myCommunityBloc.add(FetchMyCommunity());
    _myCommunityBloc.listen((state) {
      if (refreshController.isRefresh) {
        refreshController.refreshCompleted();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        return BlocProvider(
          create: (_) => _myCommunityBloc,
          child: BlocBuilder<MyCommunityBloc, MyCommunityState>(
              builder: (context, state) {
            final len = state.listUserCommunityModel?.length ?? 0;
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
                        text: Lang.profile_post_and_review.tr(),
                      ),
                    ),
                    body: Stack(
                      fit: StackFit.expand,
                      children: [
                        if (len <= 0)
                          Positioned.fill(
                            top: sizeLarge,
                            child: SearchEmptyWidget(
                              justInformEmpty: true,
                            ),
                          ),
                        Positioned.fill(
                          child: MyRefreshList(
                            refreshController: refreshController,
                            enablePullDown: true,
                            onRefresh: () {
                              _myCommunityBloc.add(FetchMyCommunity());
                            },
                            listView: ListView.builder(
                              itemCount: len,
                              itemBuilder: (BuildContext context, int index) {
                                final e = state.listUserCommunityModel[index];
                                return Container(
                                  margin: const EdgeInsets.only(
                                      top: sizeSmallxxxx,
                                      left: sizeNormal,
                                      right: sizeNormal,
                                      bottom: sizeSmallxxxx),
                                  child: CardMyCommunity(
                                    height: sizeImageLarge,
                                    item: e,
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    )),
              ),
            );
          }),
        );
      },
    );
  }


  @override
  void dispose() {
    _myCommunityBloc.close();
    refreshController.dispose();
    super.dispose();
  }
}
