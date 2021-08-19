import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:marvista/ui/login/login_page.dart';
import 'package:shimmer/shimmer.dart';

import '../../../common/constants.dart';
import '../../../common/di/injection/injector.dart';
import '../../../common/dialog/comment_dialog.dart';
import '../../../common/dialog/menu_community_detail_dialog.dart';
import '../../../common/localization/lang.dart';
import '../../../common/theme/theme.dart';
import '../../../common/widget/my_button.dart';
import '../../../common/widget/my_indicator.dart';
import '../../../data/model/comment_model.dart';
import '../../../data/model/community_model.dart';
import '../../../data/model/places_model.dart';
import '../../../data/model/post_detail.dart';
import '../../../utils/navigate_util.dart';
import '../../../utils/ui_util.dart';
import '../../assets/asset_detail/asset_detail_page.dart';
import '../../base/base_widget.dart';
import 'bloc/community_detail_bloc.dart';
import 'component/community_share_card.dart';

class CommunityDetailScreen extends BaseWidget {
  static const routeName = '/CommunityDetailScreen';
  final CommunityPost communityPost;
  final String id;

  CommunityDetailScreen({
    this.id,
    this.communityPost,
  });

  @override
  State<StatefulWidget> createState() {
    return CommunityDetailScreenState();
  }
}

class CommunityDetailScreenState extends BaseState<CommunityDetailScreen> {
  final _communityDetailBloc = sl<CommunityDetailBloc>();
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

  void initBasicInfo() {
    _communityDetailBloc.listen((state) {
      switch (state.statusAPISubmit) {
        case StatusAPISubmit.SUBMIT_FAIL:
          UIUtil.showToast(state.errorMessage);
          break;
        case StatusAPISubmit.LIKE_COMMENT_SUCCESS:
          break;
        case StatusAPISubmit.ADD_FAVORITE_SUCCESS:
          break;
        case StatusAPISubmit.ADD_COMMENT_SUCCESS:
          break;
        case StatusAPISubmit.REPLY_COMMENT_SUCCESS:
          break;
        case StatusAPISubmit.REMOVE_POST_SUCCESS:
          break;
        case StatusAPISubmit.TURN_OFF_POST_SUCCESS:
          break;
        default:
      }
    });
    _communityDetailBloc
        .add(InitPostAndCommentFromCache(widget?.communityPost));

    final id = widget?.communityPost?.id?.toString() ?? widget.id;
    _communityDetailBloc.add(FetchPostDetail(id));
    _communityDetailBloc.add(FetchNewComments(id));
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocProvider(
      create: (_) => _communityDetailBloc,
      child: BlocBuilder<CommunityDetailBloc, CommunityDetailState>(
          builder: (context, state) {
        var totalImage = state?.postDetail?.image?.length ?? 0;

        ///get Amenity Image if post dont have image
        final amenityImage = state?.postDetail?.place?.image;
        if (totalImage == 0 && amenityImage != null) {
          state?.postDetail?.image?.add(amenityImage);
          totalImage = 1;
        }
        if (state.isRefreshing) {
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
        return LayoutBuilder(
          builder: (context, constraints) {
            return Scaffold(
              body: Container(
                color: const Color.fromARGB(255, 250, 251, 243),
                child: Column(
                  children: [
                    Expanded(
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Container(
                            margin: EdgeInsets.only(
                                bottom: constraints.maxHeight * 0.35),
                            child: ClipRRect(
                              borderRadius: const BorderRadius.only(
                                  bottomLeft: Radius.circular(sizeNormalxx),
                                  bottomRight: Radius.circular(sizeNormalxx)),
                              child: PageView.builder(
                                  physics: const ClampingScrollPhysics(),
                                  itemCount: totalImage,
                                  controller: _controller,
                                  onPageChanged: (index) {
                                    _indicatorState.currentState
                                        .pageChanged(index);
                                  },
                                  itemBuilder: (context, index) {
                                    return UIUtil.makeImageWidget(
                                        state?.postDetail?.image[index]?.url ??
                                            Res.image_lorem,
                                        boxFit: BoxFit.cover,
                                        width: constraints.maxWidth,
                                        height:
                                            sizeImageLargexxx + sizeNormalx);
                                  }),
                            ),
                          ),
                          Positioned.fill(
                            child: Align(
                              alignment: Alignment.topCenter,
                              child: renderHeader(state),
                            ),
                          ),
                          Positioned.fill(
                            bottom: sizeNormal,
                            child: Align(
                              alignment: Alignment.bottomCenter,
                              child: Wrap(
                                alignment: WrapAlignment.center,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  Container(
                                    height: sizeLarge,
                                    child: totalImage > 1
                                        ? MyIndicator(
                                            key: _indicatorState,
                                            normalColor: Colors.grey,
                                            selectedColor: Colors.black,
                                            needScaleSelected: false,
                                            controller: _controller,
                                            itemCount: totalImage,
                                          )
                                        : const SizedBox(),
                                  ),
                                  CommunityShareCard(
                                    state: state,
                                    onClickAmenity: (v) {
                                      openAssetDetail(v);
                                    },
                                    onClickFavoriteAmenity: (value) {
                                      if (_communityDetailBloc.state.userInfo
                                          .isUser()) {
                                        if (value != null) {
                                          _communityDetailBloc.add(
                                              AddFavorite(value.id.toString()));
                                        }
                                      } else {
                                        NavigateUtil.openPage(
                                            context, LoginPage.routeName);
                                      }
                                    },
                                    onClickFavorite: () {
                                      if (_communityDetailBloc.state.userInfo
                                          .isUser()) {
                                        _communityDetailBloc
                                            .add(AddPostFavorite());
                                      } else {
                                        NavigateUtil.openPage(
                                            context, LoginPage.routeName);
                                      }
                                    },
                                  ),
                                  Container(
                                    padding: const EdgeInsets.only(
                                        bottom: sizeSmallx, top: sizeNormalxx),
                                    child: MyButton(
                                      text: Lang.community_comment.tr(),
                                      onTap: onShowDialogComment,
                                      paddingHorizontal: sizeExLarge,
                                      textStyle: textSmallxxx.copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                      buttonColor: const Color(0xff242655),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }

  Widget renderHeader(CommunityDetailState state) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: sizeSmall, vertical: sizeSmall),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () {
                NavigateUtil.pop(context);
              },
              child: Container(
                height: sizeNormalxxx,
                width: sizeNormalxxx,
                decoration: const BoxDecoration(
                    shape: BoxShape.circle, color: Colors.white),
                child: Icon(
                  UIUtil.getCircleIconBack(context),
                  color: Colors.black,
                  size: sizeNormalxx,
                ),
              ),
            ),
            Container(
                child: UIUtil.makeCircleImageWidget(
                    state?.postDetail?.author?.photo,
                    initialName: state?.postDetail?.author?.username ?? '',
                    size: sizeNormalxxx)),
            GestureDetector(
              onTap: () {
                showDialogMenu(state.postDetail);
              },
              child: Container(
                width: sizeNormalxxx,
                height: sizeNormalxxx,
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
                    borderRadius:
                        BorderRadius.all(Radius.circular(sizeNormalxxx))),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.fiber_manual_record_sharp,
                      color: Colors.white,
                      size: sizeVerySmall,
                    ),
                    SizedBox(width: sizeIcon),
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
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _communityDetailBloc.close();
    super.dispose();
  }

  void onSubmitComment(String value) {
    _communityDetailBloc.add(AddPostComment(value));
  }

  void onLikeComment(CommentModel commentModel) {
    _communityDetailBloc.add(LikeComment(commentModel));
  }

  void openAssetDetail(PlaceModel value) {
    NavigateUtil.openPage(context, AssetDetailScreen.routeName,
        argument: {'data': value}).then((value) {
      _communityDetailBloc.add(
          FetchPostDetail(_communityDetailBloc.state.postDetail.id.toString()));
    });
  }

  void showDialogMenu(PostDetail postDetail) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      clipBehavior: Clip.hardEdge,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(sizeNormal),
              topRight: Radius.circular(sizeNormal)),
        ),
        child: MenuCommunityDetailDialog(
          postDetail: postDetail,
          onRemovePost: onRemovePost,
          onTurnOffPost: onTurnOffPost,
        ),
      ),
      isDismissible: true,
      enableDrag: true,
      isScrollControlled: true,
    );
  }

  void onShowDialogComment() {
    _communityDetailBloc.add(ShowCommentLayout());

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      clipBehavior: Clip.hardEdge,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(sizeNormal),
              topRight: Radius.circular(sizeNormal)),
        ),
        child: CommentDialog(
          communityDetailBloc: _communityDetailBloc,
        ),
      ),
      isDismissible: true,
      enableDrag: true,
      isScrollControlled: true,
    ).then((value) {
      _communityDetailBloc.add(HideCommentLayout());
    });
  }

  void onRemovePost() {
    _communityDetailBloc.add(RemovePostFromFeed());
  }

  void onTurnOffPost() {
    _communityDetailBloc.add(TurnOffPostFromOwner());
  }
}
