import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../common/localization/lang.dart';
import '../../../../common/theme/theme.dart';
import '../../../../common/widget/my_text_view.dart';
import '../../../../data/model/comment_model.dart';
import '../../../../utils/date_util.dart';
import '../../../../utils/ui_util.dart';

class CommentItemWidget extends StatelessWidget {
  final CommentModel commentModel;
  final List<CommentModel> replies;
  final Function(CommentModel commentModel) onLikeComment;
  final bool isShowAllReplies;
  final Function(CommentModel commentModel) onReplyComment;
  final Function onClickReplyComment;

  CommentItemWidget({
    Key key,
    this.commentModel,
    this.onLikeComment,
    this.replies,
    this.isShowAllReplies = false,
    this.onReplyComment,
    this.onClickReplyComment,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var timeCreate = Lang.community_just_now.tr();
    if (commentModel.createDateTime != null &&
        commentModel.createDateTime.isNotEmpty) {
      timeCreate = DateUtil.convertTimeAgo(commentModel.created);
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        UIUtil.makeCircleImageWidget(commentModel.image,
            size: sizeNormalxx, initialName: commentModel.username),
        Expanded(
          flex: 1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.only(top: 0, left: sizeNormalx),
                decoration: const BoxDecoration(
                    borderRadius:
                        BorderRadius.all(Radius.circular(sizeSmallxx))),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MyTextView(
                      text: commentModel.username,
                      textStyle: textSmallx.copyWith(
                        color: const Color(0xff242655),
                        fontFamily: MyFontFamily.graphik,
                        fontWeight: MyFontWeight.medium,
                      ),
                    ),
                    const SizedBox(
                      height: sizeVerySmall,
                    ),
                    MyTextView(
                      text: commentModel?.comment ?? '',
                      textAlign: TextAlign.start,
                      textStyle: textSmallx.copyWith(
                        color: const Color(0xff212237).withOpacity(0.5),
                        fontFamily: MyFontFamily.graphik,
                        fontWeight: MyFontWeight.regular,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.only(top: sizeSmall, left: sizeNormalx),
                child: Row(
                  children: [
                    MyTextView(
                      text: Lang.community_like.tr(),
                      textAlign: TextAlign.start,
                      onTap: () {
                        onLikeComment(commentModel);
                      },
                      textStyle: textSmallx.copyWith(
                        color: commentModel.liked
                            ? const Color(0xff242655)
                            : const Color(0xffBAB9BC),
                        fontFamily: MyFontFamily.graphik,
                        fontWeight: MyFontWeight.medium,
                      ),
                    ),
                    const SizedBox(width: sizeSmall),
                    MyTextView(
                      text: Lang.community_reply.tr(),
                      onTap: () {
                        if (!isShowAllReplies) {
                          onClickReplyComment();
                        }
                      },
                      textAlign: TextAlign.start,
                      padding: const EdgeInsets.all(sizeVerySmall),
                      textStyle: textSmallx.copyWith(
                        color: const Color(0xffBAB9BC),
                        fontFamily: MyFontFamily.graphik,
                        fontWeight: MyFontWeight.medium,
                      ),
                    ),
                    const SizedBox(width: sizeSmall),
                    MyTextView(
                      text: timeCreate,
                      textAlign: TextAlign.start,
                      textStyle: textSmallx.copyWith(
                        color: const Color(0xffBAB9BC),
                        fontFamily: MyFontFamily.graphik,
                        fontWeight: MyFontWeight.medium,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: sizeNormalx, vertical: sizeSmall),
                child: Column(
                  children: <Widget>[
                    isShowAllReplies
                        ? listRepliedWidgetsShowAll(replies ?? [])
                        : GestureDetector(
                            onTap: onClickReplyComment,
                            child: Container(
                                color: Colors.transparent,
                                child: listRepliedWidgets(
                                    commentModel.replied ?? [])),
                          )
                  ],
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget listRepliedWidgetsShowAll(List<CommentModel> item) {
    return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: item.length ?? 0,
        itemBuilder: (BuildContext context, int index) {
          final replied = item[index];
          return renderItemReplyShowAll(replied);
        });
  }

  Widget listRepliedWidgets(List<CommentModel> item) {
    final list = <Widget>[];
    for (var i = 0; i < item.length; i++) {
      final replied = item[i];
      if (item.length > 2) {
        if (i == 0) {
          final leftComment = item.length - 2;
          list.add(
            Column(
              children: [
                MyTextView(
                  text: Lang.community_show_number_reply
                      .tr()
                      .format([leftComment.toString()]),
                  textAlign: TextAlign.start,
                  textStyle: textSmallx.copyWith(
                    color: const Color(0xff212237).withOpacity(0.5),
                    fontFamily: MyFontFamily.graphik,
                    fontWeight: MyFontWeight.medium,
                  ),
                ),
                const SizedBox(height: sizeSmallx)
              ],
            ),
          );
          list.add(renderItemReply(replied));
        } else {
          if (i == 2) {
            return Wrap(children: list);
          }
          list.add(renderItemReply(replied));
        }
      } else {
        list.add(renderItemReply(replied));
      }
    }
    return Wrap(children: list);
  }

  Widget renderItemReplyShowAll(CommentModel replied) {
    var timeCreate = Lang.community_just_now.tr();
    if (replied.createDateTime != null && replied.createDateTime.isNotEmpty) {
      timeCreate = DateUtil.convertTimeAgo(replied.created);
    }
    return Padding(
      padding: const EdgeInsets.only(bottom: sizeVerySmallx),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: sizeNormal,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                UIUtil.makeCircleImageWidget(replied.image,
                    size: sizeNormal,
                    initialName: replied.username,
                    textStyle: textSmall),
                const SizedBox(width: sizeSmall),
                MyTextView(
                  text: replied.username,
                  textAlign: TextAlign.start,
                  textStyle: textSmallx.copyWith(
                    color: const Color(0xff242655),
                    fontFamily: MyFontFamily.graphik,
                    fontWeight: MyFontWeight.medium,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: sizeNormalxx),
            child: MyTextView(
              text: replied.comment,
              textAlign: TextAlign.start,
              textStyle: textSmallx.copyWith(
                color: const Color(0xff212237).withOpacity(0.5),
                fontFamily: MyFontFamily.graphik,
                fontWeight: MyFontWeight.regular,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: sizeNormalxx),
            child: MyTextView(
              text: timeCreate,
              textAlign: TextAlign.start,
              textStyle: textSmall.copyWith(
                color: const Color(0xffBAB9BC),
                fontFamily: MyFontFamily.graphik,
                fontWeight: MyFontWeight.medium,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget renderItemReply(CommentModel replied) {
    return Padding(
      padding: const EdgeInsets.only(bottom: sizeVerySmallx),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          UIUtil.makeCircleImageWidget(replied.image, size: sizeNormal),
          const SizedBox(width: sizeIcon),
          MyTextView(
            text: replied.username,
            textAlign: TextAlign.start,
            textStyle: textSmallx.copyWith(
              color: const Color(0xff242655),
              fontFamily: MyFontFamily.graphik,
              fontWeight: MyFontWeight.medium,
            ),
          ),
          const SizedBox(width: sizeSmall),
          Expanded(
            flex: 1,
            child: MyTextView(
              text: replied.comment,
              textAlign: TextAlign.start,
              maxLine: 1,
              textStyle: textSmallx.copyWith(
                color: const Color(0xff212237).withOpacity(0.5),
                fontFamily: MyFontFamily.graphik,
                fontWeight: MyFontWeight.regular,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
