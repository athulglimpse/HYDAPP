import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import '../../../common/constants.dart';
import '../../../common/localization/lang.dart';
import '../../../common/theme/theme.dart';
import '../../../common/widget/my_text_view.dart';
import '../../../data/model/community_model.dart';
import '../../../utils/ui_util.dart';

@immutable
class CommunityList extends StatelessWidget {
  final List<CommunityPost> listPost;
  final Function(CommunityPost value) onItemClick;
  final Function(CommunityPost value) onItemClickFav;
  final Function onClickSeeAll;
  final EdgeInsets padding;
  final EdgeInsets margin;
  final bool isShowAll;

  CommunityList(
      {Key key,
      this.onItemClick,
      this.onItemClickFav,
      this.listPost,
      this.onClickSeeAll,
      this.margin = const EdgeInsets.only(left: sizeNormal),
      this.padding =
          const EdgeInsets.only(left: sizeSmallxxx, right: sizeSmallxxx),
      this.isShowAll})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      Padding(
        padding: padding,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            MyTextView(
              text: Lang.home_from_the_community.tr(),
              textStyle: textSmallxxx.copyWith(
                  color: Colors.black,
                  fontFamily: MyFontFamily.graphik,
                  fontWeight: MyFontWeight.bold),
            ),
            if (isShowAll)
            MyTextView(
              padding: const EdgeInsets.symmetric(
                  vertical: sizeVerySmall, horizontal: sizeVerySmall),
              onTap: onClickSeeAll,
              text: Lang.home_see_all.tr(),
              textStyle: textSmallxx.copyWith(
                  color: const Color(0xff419C9B),
                  fontFamily: MyFontFamily.graphik,
                  fontWeight: MyFontWeight.medium),
            )
          ],
        ),
      ),
      const SizedBox(
        height: sizeSmall,
      ),
      Container(
          margin: margin,
          height: sizeImageLarge + sizeNormal,
          child: ListView.builder(
              itemCount: listPost?.length ?? 0,
              scrollDirection: Axis.horizontal,
              itemBuilder: (BuildContext context, int index) {
                return CardCommunityItem(
                  onItemClickAddFav: onItemClickFav,
                  communityInfo: listPost[index],
                  onItemClick: onItemClick,
                );
              }))
    ]);
  }
}

class CardCommunityItem extends StatelessWidget {
  final CommunityPost communityInfo;
  final Function(CommunityPost) onItemClick;
  final Function(CommunityPost) onItemClickAddFav;
  final EdgeInsetsGeometry margin;
  final EdgeInsetsGeometry horizontalMarginInfoCard;
  final double borderRadius;
  final TextStyle textSizeTitle;
  final TextStyle textSizeSubTitle;
  final bool showFa;

  CardCommunityItem(
      {Key key,
      this.communityInfo,
      this.onItemClickAddFav,
      this.showFa = true,
      this.textSizeSubTitle = textSmall,
      this.textSizeTitle = textSmallx,
      this.horizontalMarginInfoCard =
          const EdgeInsets.symmetric(horizontal: sizeVerySmall),
      this.onItemClick,
      this.margin = const EdgeInsets.only(right: sizeNormal),
      this.borderRadius = sizeSmall})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var imgCard =
        (communityInfo.image != null && communityInfo.image.isNotEmpty)
            ? communityInfo.image[0]
            : null;

    ///get Amenity Image if post dont have image
    imgCard ??= communityInfo?.place?.image;
    return Container(
      margin: margin,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: AspectRatio(
          aspectRatio: 0.8,
          child: Container(
            color: Colors.transparent,
            child: Stack(
              fit: StackFit.expand,
              children: [
                GestureDetector(
                  onTap: () {
                    onItemClick(communityInfo);
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: sizeNormalxx),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(borderRadius),
                      child: imgCard != null
                          ? UIUtil.makeImageWidget(imgCard.url,
                              boxFit: BoxFit.cover)
                          : UIUtil.makeImageWidget(Res.image_lorem,
                              boxFit: BoxFit.cover),
                    ),
                  ),
                ),
                Positioned.fill(
                    child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: sizeVerySmall),
                    child: Container(
                      margin: horizontalMarginInfoCard,
                      padding: const EdgeInsets.symmetric(
                          vertical: sizeSmall, horizontal: sizeSmall),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              spreadRadius: 1,
                              blurRadius: 1,
                              offset: const Offset(
                                  0, 1.5), // changes position of shadow
                            ),
                          ],
                          borderRadius: const BorderRadius.all(
                              Radius.circular(sizeSmall))),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                MyTextView(
                                  text: communityInfo?.caption ?? '',
                                  textAlign: TextAlign.start,
                                  maxLine: 1,
                                  textStyle: textSizeTitle,
                                ),
                                SizedBox(
                                  height: showFa ? sizeSmall : sizeVerySmall,
                                ),
                                MyTextView(
                                  text: communityInfo?.author?.username ?? '',
                                  textAlign: TextAlign.start,
                                  maxLine: 1,
                                  textStyle: textSizeSubTitle.copyWith(
                                      color: Colors.black.withAlpha(128)),
                                )
                              ],
                            ),
                          ),
                          showFa
                              ? GestureDetector(
                                  onTap: () {
                                    if (onItemClickAddFav != null) {
                                      onItemClickAddFav(communityInfo);
                                    }
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(sizeSmall),
                                    child: Icon(
                                      Icons.favorite,
                                      color:
                                          (communityInfo?.isFavorite ?? false)
                                              ? Colors.red
                                              : Colors.grey[350],
                                      size: sizeNormal,
                                    ),
                                  ),
                                )
                              : const SizedBox()
                        ],
                      ),
                    ),
                  ),
                ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
