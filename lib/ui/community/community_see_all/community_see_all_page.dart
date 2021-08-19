import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marvista/utils/ui_util.dart';

import '../../../common/di/injection/injector.dart';
import '../../../common/localization/lang.dart';
import '../../../common/theme/theme.dart';
import '../../../common/widget/my_indicator.dart';
import '../../../common/widget/my_text_view.dart';
import '../../../data/model/community_model.dart';
import '../../../utils/navigate_util.dart';
import '../../base/base_widget.dart';
import '../../home/components/community_list.dart';
import '../community_detail/community_detail_page.dart';
import 'bloc/community_see_all_bloc.dart';

class CommunitySeeAllScreen extends BaseWidget {
  static const routeName = '/CommunitySeeAllScreen';

  final int experienceId;
  CommunitySeeAllScreen({
    this.experienceId,
  });

  @override
  State<StatefulWidget> createState() {
    return CommunitySeeAllScreenState();
  }
}

class CommunitySeeAllScreenState extends BaseState<CommunitySeeAllScreen> {
  final _communitySeeAllBloc = sl<CommunitySeeAllBloc>();
  final _indicatorState = GlobalKey<MyIndicatorState>();
  final PageController _controller = PageController(
    initialPage: 0,
    keepPage: false,
  );

  @override
  void initState() {
    super.initState();
    initBasicInfo();
  }

  void initBasicInfo() {}

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
              text: Lang.from_the_community_from_the_community.tr(),
            ),
          ),
          body: LayoutBuilder(
            builder: (context, constraints) {
              return BlocProvider(
                create: (_) => _communitySeeAllBloc,
                child: BlocBuilder<CommunitySeeAllBloc, CommunitySeeAllState>(
                    builder: (context, state) {
                  return Padding(
                    padding: const EdgeInsets.only(
                        left: sizeNormal, right: sizeNormal),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        MyTextView(
                          textAlign: TextAlign.start,
                          text: Lang.from_the_community_trending_posts.tr(),
                          textStyle: textSmallxxx.copyWith(
                              color: Colors.black,
                              fontFamily: MyFontFamily.graphik,
                              fontWeight: MyFontWeight.bold),
                        ),
                        Expanded(
                          flex: 5,
                          child: Container(
                            child: PageView.builder(
                              physics: const ClampingScrollPhysics(),
                              itemCount: state.listTrendingPosts?.length ?? 0,
                              controller: _controller,
                              onPageChanged: (index) {
                                _indicatorState.currentState.pageChanged(index);
                              },
                              itemBuilder: (context, index) {
                                return CardCommunityItem(
                                  onItemClickAddFav: (e) {
                                    _communitySeeAllBloc
                                        .add(AddPostToFavorite(e));
                                  },
                                  onItemClick: openCommunityDetail,
                                  horizontalMarginInfoCard:
                                      const EdgeInsets.symmetric(
                                          horizontal: sizeNormal),
                                  borderRadius: sizeNormalx,
                                  margin: const EdgeInsets.symmetric(
                                      vertical: sizeSmall),
                                  communityInfo: state.listTrendingPosts[index],
                                );
                              },
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.only(
                              bottom: sizeSmallxx, top: 0),
                          child: MyIndicator(
                            key: _indicatorState,
                            normalColor: Colors.grey,
                            selectedColor: Colors.black,
                            needScaleSelected: false,
                            controller: _controller,
                            itemCount: state.listTrendingPosts?.length ?? 0,
                          ),
                        ),
                        MyTextView(
                          text: Lang.from_the_community_all_posts.tr(),
                          textStyle: textSmallxxx.copyWith(
                              color: Colors.black,
                              fontFamily: MyFontFamily.graphik,
                              fontWeight: MyFontWeight.bold),
                        ),
                        Expanded(
                          flex: 2,
                          child: Container(
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: state?.listAllPosts?.length ?? 0,
                              itemBuilder: (context, index) {
                                return CardCommunityItem(
                                  onItemClick: openCommunityDetail,
                                  textSizeSubTitle: textSmall,
                                  textSizeTitle: textSmall,
                                  showFa: false,
                                  borderRadius: sizeSmall,
                                  horizontalMarginInfoCard:
                                      const EdgeInsets.symmetric(
                                          horizontal: sizeSmall),
                                  margin: const EdgeInsets.only(
                                      right: sizeSmall,
                                      top: sizeSmall,
                                      bottom: sizeSmall),
                                  communityInfo: state.listAllPosts[index],
                                );
                              },
                            ),
                          ),
                        ),
                      ],
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

  void openCommunityDetail(CommunityPost value) {
    NavigateUtil.openPage(context, CommunityDetailScreen.routeName,
        argument: {'data': value});
  }

  @override
  void dispose() {
    _communitySeeAllBloc.close();
    super.dispose();
  }
}
