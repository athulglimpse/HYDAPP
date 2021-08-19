import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../data/model/post_detail.dart';
import '../../ui/report/report_page.dart';
import '../../utils/navigate_util.dart';
import '../../utils/ui_util.dart';
import '../constants.dart';
import '../localization/lang.dart';
import '../theme/theme.dart';
import '../widget/my_text_view.dart';

class MenuCommunityDetailDialog extends StatelessWidget {
  final PostDetail postDetail;
  final Function() onTurnOffPost;
  final Function() onRemovePost;

  MenuCommunityDetailDialog(
      {this.postDetail, this.onTurnOffPost, this.onRemovePost});

  @override
  Widget build(BuildContext context) {
    final img = (postDetail.image != null && postDetail.image.isNotEmpty)
        ? postDetail.image[0]
        : null;
    return Padding(
      padding: const EdgeInsets.only(
          right: sizeNormal,
          left: sizeNormal,
          bottom: sizeNormal,
          top: sizeSmall),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
                margin: const EdgeInsets.only(bottom: sizeSmallxxx),
                width: sizeNormalxxx,
                height: 4,
                decoration: const BoxDecoration(
                    color: Color(0x21212237),
                    borderRadius:
                        BorderRadius.all(Radius.circular(sizeVerySmall)))),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius:
                      const BorderRadius.all(Radius.circular(sizeNormal)),
                  child: UIUtil.makeImageWidget(
                    img?.url ?? Res.image_lorem,
                    size: const Size(sizeExLargex, sizeExLargex),
                    boxFit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: sizeVerySmallx),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MyTextView(
                      text: Lang.community_detail_image_shared_by.tr(),
                      textStyle: textSmall.copyWith(
                        color: const Color(0xff212237).withOpacity(0.5),
                        fontFamily: MyFontFamily.graphik,
                        fontWeight: MyFontWeight.regular,
                      ),
                    ),
                    const SizedBox(height: sizeSmall),
                    Row(
                      children: [
                        UIUtil.makeCircleImageWidget(postDetail?.author?.photo,
                            initialName: postDetail?.author?.username ?? '',
                            size: sizeNormal),
                        const SizedBox(width: sizeVerySmall),
                        MyTextView(
                          text: postDetail?.author?.username ?? '',
                          textStyle: textSmallx.copyWith(
                            color: const Color(0xff212237),
                            fontFamily: MyFontFamily.graphik,
                            fontWeight: MyFontWeight.regular,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            Divider(color: Colors.grey[350]),
            const SizedBox(height: sizeSmallxx),
            GestureDetector(
              onTap: () {
                NavigateUtil.pop(context);
                onRemovePost();
              },
              child: Row(
                children: [
                  const Icon(
                    Icons.highlight_remove_rounded,
                    color: Color(0xff212237),
                    size: sizeNormalxx,
                  ),
                  const SizedBox(width: sizeSmallxxx),
                  MyTextView(
                    text: Lang.community_detail_remove_post_from_feed.tr(),
                    textStyle: textSmallx.copyWith(
                      color: const Color(0xff212237),
                      fontFamily: MyFontFamily.graphik,
                      fontWeight: MyFontWeight.regular,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: sizeSmallx),
            GestureDetector(
              onTap: () {
                NavigateUtil.pop(context);
                onTurnOffPost();
              },
              child: Row(
                children: [
                  const Icon(
                    Icons.power_settings_new,
                    color: Color(0xff212237),
                    size: sizeNormalxx,
                  ),
                  const SizedBox(width: sizeSmallxxx),
                  MyTextView(
                    text:
                        // ignore: lines_longer_than_80_chars
                        "${Lang.community_detail_turn_off_posts_by.tr()} ${postDetail?.author?.username ?? ""}",
                    textStyle: textSmallx.copyWith(
                      color: const Color(0xff212237),
                      fontFamily: MyFontFamily.graphik,
                      fontWeight: MyFontWeight.regular,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: sizeSmallx),
            Row(
              children: [
                SvgPicture.asset(
                  Res.icon_flag,
                  fit: BoxFit.contain,
                  height: sizeNormalxx,
                  color: const Color(0xff212237),
                ),
                const SizedBox(width: sizeSmallxxx),
                MyTextView(
                  onTap: () {
                    NavigateUtil.openPage(context, ReportPage.routeName);
                  },
                  text: Lang.community_detail_report_issue.tr(),
                  textStyle: textSmallx.copyWith(
                    color: const Color(0xff212237),
                    fontFamily: MyFontFamily.graphik,
                    fontWeight: MyFontWeight.regular,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
