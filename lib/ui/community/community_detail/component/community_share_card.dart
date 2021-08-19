import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:share/share.dart';

import '../../../../common/constants.dart';
import '../../../../common/di/injection/injector.dart';
import '../../../../common/localization/lang.dart';
import '../../../../common/theme/theme.dart';
import '../../../../common/widget/my_text_view.dart';
import '../../../../data/model/asset_detail.dart';
import '../../../../data/model/post_detail.dart';
import '../../../../utils/app_const.dart';
import '../../../../utils/location_wrapper.dart';
import '../../../../utils/ui_util.dart';
import '../../../../utils/utils.dart';
import '../bloc/community_detail_bloc.dart';

@immutable
class CommunityShareCard extends StatelessWidget {
  final CommunityDetailState state;
  final Function onClickFavorite;
  final Function(AssetDetail) onClickFavoriteAmenity;
  final Function(AssetDetail) onClickAmenity;
  final locationWrapper = sl<LocationWrapper>();

  CommunityShareCard({
    Key key,
    this.state,
    this.onClickAmenity,
    this.onClickFavoriteAmenity,
    this.onClickFavorite,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: sizeNormalxx),
      padding: const EdgeInsets.only(
          left: sizeSmall, right: sizeSmall, top: sizeSmall),
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(sizeSmallxx))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                flex: 1,
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    GestureDetector(
                      onTap: onClickFavorite,
                      child: Padding(
                        padding: const EdgeInsets.all(sizeSmall),
                        child: Icon(
                          Icons.favorite,
                          color: state?.postDetail?.isFavorite ?? false
                              ? Colors.red
                              : Colors.grey[350],
                          size: sizeSmallxxxx,
                        ),
                      ),
                    ),
                    const SizedBox(width: sizeVerySmallx),
                    Expanded(
                      flex: 1,
                      child: Container(
                        width: sizeImageNormalxx,
                        height: sizeSmallxxx,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Stack(
                            alignment: AlignmentDirectional.centerStart,
                            children: listOfFavoriteWidgets(
                                    state?.postDetail?.favouriteList ?? [])
                                .map((e) => e)
                                .toList(),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  Share.share(state?.postDetail?.shareUrl ??
                      'http://www.hudayriyat.com/');
                },
                child: Padding(
                  padding: const EdgeInsets.all(sizeVerySmall),
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        Res.icon_share,
                        fit: BoxFit.fill,
                        width: sizeSmallxxx,
                        height: sizeSmallxxx,
                      ),
                      const SizedBox(width: sizeVerySmallx),
                      Padding(
                        padding: const EdgeInsets.only(right: sizeSmall),
                        child: MyTextView(
                          text: Lang.community_share.tr(),
                          textStyle: textSmallx.copyWith(
                            color: const Color(0xff242655),
                            fontFamily: MyFontFamily.graphik,
                            fontWeight: MyFontWeight.regular,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Divider(color: Colors.grey[350]),
          const SizedBox(height: sizeSmall),
          MyTextView(
            textAlign: TextAlign.start,
            text: state?.postDetail?.caption ?? '',
            textStyle: textSmallx.copyWith(
              color: Colors.black,
              fontFamily: MyFontFamily.graphik,
              fontWeight: MyFontWeight.medium,
            ),
          ),
          const SizedBox(height: sizeSmallx),
          Padding(
            padding: const EdgeInsets.only(right: sizeNormal),
            child: renderItemLocationTag(),
          ),
          const SizedBox(height: sizeSmallxxxx),
        ],
      ),
    );
  }

  List<Widget> listOfFavoriteWidgets(List<Favourite> item) {
    final list = <Widget>[];

    for (var i = 0; i < item.length; i++) {
      if (item.length >= 3 && i == 3) {
        list.add(Positioned(
            left: i * sizeSmallxxx,
            child: const Icon(
              Icons.add,
              size: sizeSmallxxx,
            )));
        return list;
      } else {
        list.add(Positioned(
            left: i * (sizeSmallxxx - sizeIcon),
            child: UIUtil.makeCircleImageWidget(item[i].photo,
                textStyle: textSmall,
                initialName: item[i]?.username ?? '',
                size: sizeSmallxxx)));
      }
    }
    return list;
  }

  Widget renderItemLocationTag() {
    final assetDetail = state.postDetail.place;
    final totalReviews = assetDetail?.totalReview ?? 0;
    return AspectRatio(
      aspectRatio: 3.2,
      child: Padding(
        padding: const EdgeInsets.only(bottom: sizeVerySmall),
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 1,
                  offset: const Offset(0, 1.5), // changes position of shadow
                ),
              ],
              borderRadius: const BorderRadius.all(Radius.circular(sizeSmall))),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius:
                    const BorderRadius.all(Radius.circular(sizeVerySmall)),
                child: GestureDetector(
                  onTap: () {
                    onClickAmenity(assetDetail);
                  },
                  child: UIUtil.makeImageWidget(
                      assetDetail?.image?.url ?? Res.image_lorem,
                      boxFit: BoxFit.cover,
                      width: sizeExLargexx,
                      height: sizeImageSmall),
                ),
              ),
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: sizeSmall),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: MyTextView(
                              text: assetDetail?.title ?? '',
                              maxLine: 1,
                              textAlign: TextAlign.start,
                              textStyle: textSmallx.copyWith(
                                color: const Color(0xff242655),
                                fontFamily: MyFontFamily.graphik,
                                fontWeight: MyFontWeight.medium,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              onClickFavoriteAmenity(assetDetail);
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(sizeVerySmall),
                              child: Icon(
                                Icons.favorite,
                                color: (assetDetail?.isFavorite ?? false)
                                    ? Colors.red
                                    : Colors.grey[350],
                                size: sizeSmallxxx,
                              ),
                            ),
                          ),
                        ],
                      ),
                      (assetDetail?.eta != null)
                          ? Row(
                              children: [
                                Icon(
                                  Icons.directions_walk,
                                  color: Colors.grey[350],
                                  size: sizeSmallxxx,
                                ),
                                const SizedBox(width: sizeVerySmall),
                                Expanded(
                                  child: MyTextView(
                                    text: assetDetail.eta,
                                    textAlign: TextAlign.start,
                                    textStyle: textSmall.copyWith(
                                      color: Colors.grey[350],
                                      fontFamily: MyFontFamily.graphik,
                                      fontWeight: MyFontWeight.regular,
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : Row(
                              children: [
                                SvgPicture.asset(
                                  Res.icon_car,
                                  fit: BoxFit.contain,
                                  color: Colors.grey,
                                  width: sizeSmallxxx,
                                ),
                                const SizedBox(width: sizeVerySmall),
                                Expanded(
                                  child: MyTextView(
                                    text: assetDetail?.etaCar ?? '..',
                                    textAlign: TextAlign.start,
                                    textStyle: textSmall.copyWith(
                                      color: Colors.grey[350],
                                      fontFamily: MyFontFamily.graphik,
                                      fontWeight: MyFontWeight.regular,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: sizeSmall, vertical: sizeVerySmall),
                            decoration: const BoxDecoration(
                              color: Color(0xffE6E4DE),
                              borderRadius: BorderRadius.all(
                                Radius.circular(sizeSmallxx),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.star_rate,
                                  size: sizeSmallxxx,
                                  color: Color(0xffFBBC43),
                                ),
                                MyTextView(
                                  text: assetDetail?.rate ?? '..',
                                  textStyle: textSmall.copyWith(
                                      fontFamily: MyFontFamily.graphik,
                                      fontWeight: MyFontWeight.medium),
                                )
                              ],
                            ),
                          ),
                          const SizedBox(width: sizeVerySmall),
                          MyTextView(
                            text: '$totalReviews '
                                '${totalReviews == 1 ? Lang.asset_detail_review.tr() : Lang.asset_detail_reviews.tr()}',
                            textStyle: textSmall.copyWith(
                              color: const Color(0xff242655),
                              fontFamily: MyFontFamily.graphik,
                              fontWeight: MyFontWeight.regular,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: sizeIcon),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
