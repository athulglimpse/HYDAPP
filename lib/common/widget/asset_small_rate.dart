import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../data/model/places_model.dart';
import '../../utils/ui_util.dart';
import '../constants.dart';
import '../theme/theme.dart';
import 'my_text_view.dart';

class AssetSmallRateItem extends StatelessWidget {
  final Function(PlaceModel) onItemClick;
  final PlaceModel item;

  AssetSmallRateItem({
    Key key,
    this.onItemClick,
    this.item,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final totalReviews = item?.totalReview ?? 0;
    return GestureDetector(
      onTap: () {
        onItemClick(item);
      },
      child: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: sizeSmall),
            padding: const EdgeInsets.only(bottom: sizeSmallxxx),
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
                borderRadius:
                    const BorderRadius.all(Radius.circular(sizeSmall))),
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      UIUtil.makeCircleImageWidget(
                          item?.image?.url ?? Res.image_lorem,
                          size: constraints.maxWidth - sizeLarge),
                      Column(
                        children: [
                          MyTextView(
                            text: item?.title ?? '',
                            maxLine: 2,
                            textStyle: textSmallxx.copyWith(
                                fontFamily: MyFontFamily.graphik,
                                fontWeight: MyFontWeight.medium),
                          ),
                          const SizedBox(
                            height: sizeVerySmall,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: sizeSmall),
                            child: (item.eta != null)
                                ? Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SvgPicture.asset(
                                        Res.icon_walk,
                                        fit: BoxFit.contain,
                                        color: Colors.grey,
                                        width: sizeVerySmallx,
                                      ),
                                      const SizedBox(
                                        width: sizeVerySmall,
                                      ),
                                      Flexible(
                                        child: MyTextView(
                                          maxLine: 1,
                                          text: item.eta ?? '...',
                                          textStyle: textSmallx.copyWith(
                                              color: Colors.grey,
                                              fontFamily: MyFontFamily.graphik,
                                              fontWeight: MyFontWeight.regular),
                                        ),
                                      ),
                                    ],
                                  )
                                : Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SvgPicture.asset(
                                        Res.icon_car,
                                        fit: BoxFit.contain,
                                        color: Colors.grey,
                                        width: sizeSmallxxx,
                                      ),
                                      const SizedBox(
                                        width: sizeVerySmall,
                                      ),
                                      Flexible(
                                        child: MyTextView(
                                          maxLine: 1,
                                          text: item.etaCar ?? '...',
                                          textStyle: textSmallx.copyWith(
                                              color: Colors.grey,
                                              fontFamily: MyFontFamily.graphik,
                                              fontWeight: MyFontWeight.regular),
                                        ),
                                      ),
                                    ],
                                  ),
                          )
                        ],
                      )
                    ],
                  ),
                );
              },
            ),
          ),
          if (totalReviews > 0)
            Positioned.fill(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
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
                        text: item?.rate ?? '0',
                        textStyle: textSmall.copyWith(
                            fontFamily: MyFontFamily.graphik,
                            fontWeight: MyFontWeight.medium),
                      )
                    ],
                  ),
                ),
              ),
            )
        ],
      ),
    );
  }
}
