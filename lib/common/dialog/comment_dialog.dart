import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:marvista/ui/login/login_page.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shimmer/shimmer.dart';

import '../../data/model/comment_model.dart';
import '../../ui/community/community_detail/bloc/community_detail_bloc.dart';
import '../../ui/community/community_detail/component/comment_item_widget.dart';
import '../../utils/navigate_util.dart';
import '../../utils/ui_util.dart';
import '../constants.dart';
import '../localization/lang.dart';
import '../theme/theme.dart';
import '../widget/my_listview.dart';
import '../widget/my_text_view.dart';

class CommentDialog extends StatefulWidget {
  final CommunityDetailBloc communityDetailBloc;

  const CommentDialog({Key key, this.communityDetailBloc}) : super(key: key);
  @override
  _CommentDialogState createState() => _CommentDialogState();
}

class _CommentDialogState extends State<CommentDialog> {
  final ScrollController _scrollControllerComment = ScrollController();
  final TextEditingController _commentController = TextEditingController();
  final ScrollController _scrollControllerReplies = ScrollController();
  final RefreshController refreshControllerComment = RefreshController();
  CommunityDetailBloc communityDetailBloc;

  @override
  void initState() {
    communityDetailBloc = widget.communityDetailBloc;
    super.initState();
    communityDetailBloc.listen((state) {
      if (!state.isShowComment && !state.isReplying) {
        return;
      }
      if (refreshControllerComment.isLoading) {
        refreshControllerComment?.loadComplete();
      }
      switch (state.statusAPISubmit) {
        case StatusAPISubmit.LIKE_COMMENT_SUCCESS:
          break;
        case StatusAPISubmit.ADD_FAVORITE_SUCCESS:
          break;
        case StatusAPISubmit.ADD_COMMENT_SUCCESS:
          _scrollControllerComment?.animateTo(
            0,
            curve: Curves.easeOut,
            duration: const Duration(milliseconds: 300),
          );
          break;
        case StatusAPISubmit.REPLY_COMMENT_SUCCESS:
          _scrollControllerReplies?.animateTo(
            0,
            curve: Curves.easeOut,
            duration: const Duration(milliseconds: 300),
          );
          break;
        case StatusAPISubmit.REMOVE_POST_SUCCESS:
          break;
        case StatusAPISubmit.TURN_OFF_POST_SUCCESS:
          break;
        default:
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xffFDFBF5),
      child: WillPopScope(
        onWillPop: () {
          if (communityDetailBloc.state.isReplying) {
            communityDetailBloc.add(SwitchCommentLayout());
            return Future(() => false);
          } else {
            return Future(() => true);
          }
        },
        child: Container(
          margin: const EdgeInsets.only(top: sizeNormalxx),
          child: Scaffold(
            backgroundColor: const Color(0xffFDFBF5),
            body: SafeArea(
              child: BlocProvider.value(
                value: communityDetailBloc,
                child: BlocBuilder<CommunityDetailBloc, CommunityDetailState>(
                    builder: (context, state) {
                  return Column(
                    children: [
                      Expanded(
                          flex: 1,
                          child: Stack(
                            children: [
                              commentLayout(state),
                              if (state.isReplying) replyLayout(state),
                            ],
                          )),
                      if (state.userInfo.isUser() ?? false)
                        Material(
                          color: Colors.transparent,
                          child: Container(
                            padding: const EdgeInsets.only(
                                left: sizeSmallx, right: sizeSmallx),
                            constraints: const BoxConstraints(
                              maxWidth: sizeImageLargexx,
                            ),
                            margin: const EdgeInsets.only(bottom: sizeNormal),
                            height: sizeLargexxx,
                            decoration: const BoxDecoration(
                                color: Color(0xff242655),
                                borderRadius: BorderRadius.all(
                                    Radius.circular(sizeLarge))),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                UIUtil.makeCircleImageWidget(
                                    state.userInfo?.photo?.url ?? '',
                                    initialName: state.userInfo.fullName,
                                    size: sizeNormalxxx),
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: sizeSmall),
                                    child: TextField(
                                      controller: _commentController,
                                      autofocus: false,
                                      style: textSmallxx.copyWith(
                                        color: Colors.white,
                                        fontFamily: MyFontFamily.graphik,
                                        fontWeight: MyFontWeight.regular,
                                      ),
                                      maxLines: null,
                                      decoration: InputDecoration(
                                        filled: true,
                                        fillColor: Colors.transparent,
                                        hintText:
                                            Lang.community_add_a_comment.tr(),
                                        hintStyle: textSmallxx.copyWith(
                                          color: Colors.white.withOpacity(0.8),
                                          fontFamily: MyFontFamily.graphik,
                                          fontWeight: MyFontWeight.regular,
                                        ),
                                        contentPadding: const EdgeInsets.only(
                                            left: sizeSmallxx,
                                            bottom: sizeSmallxx,
                                            top: sizeSmall),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color: Colors.transparent),
                                          borderRadius: BorderRadius.circular(
                                              sizeNormalx),
                                        ),
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide: const BorderSide(
                                              color: Colors.transparent),
                                          borderRadius: BorderRadius.circular(
                                              sizeNormalx),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                IconButton(
                                    padding: const EdgeInsets.all(0),
                                    icon: const Icon(
                                      Icons.send_rounded,
                                      size: sizeNormalx,
                                      color: Colors.white,
                                    ),
                                    onPressed: () {
                                      onSubmitComment(_commentController.text);
                                    })
                              ],
                            ),
                          ),
                        )
                    ],
                  );
                }),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget commentLayout(CommunityDetailState state) {
    return Scaffold(
      backgroundColor: const Color(0xffFDFBF5),
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
          text: Lang.community_comments.tr(),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(
                left: sizeNormal, right: sizeNormal, bottom: sizeNormal),
            child: Divider(
              color: const Color(0xff212237).withOpacity(0.2),
              height: 1,
            ),
          ),
          Expanded(
            flex: 1,
            child: MyRefreshList(
              refreshController: refreshControllerComment,
              enablePullUp: true,
              textIdle: 'Swipe up to load more',
              onLoading: () {
                communityDetailBloc.add(FetchMoreComments());
              },
              listView: ListView.builder(
                shrinkWrap: true,
                itemCount: state?.comment?.length ?? 0,
                physics: const ScrollPhysics(),
                controller: _scrollControllerComment,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.only(
                        left: sizeNormalx, right: sizeNormalx, top: sizeSmall),
                    child: CommentItemWidget(
                        onLikeComment: onLikeComment,
                        onClickReplyComment: () {
                          communityDetailBloc
                              .add(SwitchReplyLayout(state?.comment[index]));
                        },
                        commentModel: state?.comment[index]),
                  );
                },
              ),
            ),
          ),
          Container(
            height: state.isLoadingComments ? 50.0 : 0,
            color: Colors.transparent,
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          ),
        ],
      ),
    );
  }

  Widget replyLayout(CommunityDetailState state) {
    return TweenAnimationBuilder(
        tween:
            Tween<Offset>(begin: const Offset(1, 0), end: const Offset(0, 0)),
        duration: const Duration(milliseconds: 300),
        curve: Curves.linear,
        builder: (_, offset, __) {
          return FractionalTranslation(
              translation: offset,
              child: Scaffold(
                backgroundColor: const Color(0xffFDFBF5),
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
                      communityDetailBloc.add(SwitchCommentLayout());
                    },
                  ),
                  backgroundColor: const Color(0xffFDFBF5),
                  title: MyTextView(
                    textStyle: textNormal.copyWith(
                        color: Colors.black,
                        fontWeight: MyFontWeight.bold,
                        fontFamily: MyFontFamily.publicoBanner),
                    text: Lang.community_replies.tr(),
                  ),
                ),
                body: SingleChildScrollView(
                  controller: _scrollControllerReplies,
                  child: Stack(
                    children: [
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                left: sizeNormal,
                                right: sizeNormal,
                                bottom: sizeNormal),
                            child: Divider(
                              color: const Color(0xff212237).withOpacity(0.2),
                              height: 1,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: sizeNormalx,
                                right: sizeNormalx,
                                top: sizeSmall),
                            child: CommentItemWidget(
                                onLikeComment: onLikeComment,
                                isShowAllReplies: true,
                                replies: state?.commentReply?.replied ?? [],
                                commentModel: state?.commentReply),
                          ),
                        ],
                      ),
                      if (state.isFetchReplying)
                        Container(
                          color: Colors.white,
                          alignment: Alignment.topCenter,
                          child: Shimmer.fromColors(
                            baseColor: Colors.grey[300],
                            highlightColor: Colors.grey[100],
                            child: SvgPicture.asset(
                              Res.default_img_write_review,
                              fit: BoxFit.cover,
                              height: sizeImageNormalxxx + sizeNormalx,
                            ),
                          ),
                        )
                    ],
                  ),
                ),
              ));
        });
  }

  @override
  void dispose() {
    _commentController.dispose();
    _scrollControllerReplies.dispose();
    refreshControllerComment.dispose();
    _scrollControllerComment.dispose();
    super.dispose();
  }

  void onSubmitComment(String value) {
    if (value.isEmpty) {
      return;
    }
    if (communityDetailBloc.state.isReplying) {
      print(communityDetailBloc.state.commentReply);
      onReplyComment(communityDetailBloc.state.commentReply, value);
    } else {
      communityDetailBloc.add(AddPostComment(value));
    }
    _commentController.clear();
  }

  void onLikeComment(CommentModel commentModel) {
    if (communityDetailBloc.state.userInfo.isUser()) {
      communityDetailBloc.add(LikeComment(commentModel));
    } else {
      NavigateUtil.openPage(context, LoginPage.routeName);
    }
  }

  void onReplyComment(CommentModel commentId, String content) {
    communityDetailBloc.add(ReplyComment(commentId.id.toString(), content));
  }
}
