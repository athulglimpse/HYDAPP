import 'package:flutter/material.dart';

import '../../data/model/places_model.dart';
import '../../utils/ui_util.dart';
import '../constants.dart';
import '../theme/theme.dart';
import 'my_text_view.dart';

class AssetLargeItem extends StatelessWidget {
  final double height;
  final Function(PlaceModel) onItemClick;
  final double ratio;
  final PlaceModel item;

  AssetLargeItem({
    Key key,
    this.onItemClick,
    this.ratio = 1.7,
    this.item,
    this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onItemClick(item);
      },
      child: Padding(
        padding: const EdgeInsets.all(0),
        child: AspectRatio(
          aspectRatio: ratio,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: height,
                child: Stack(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(bottom: sizeSmall),
                      child: ClipRRect(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(sizeVerySmall),
                        ),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            UIUtil.makeImageWidget(
                                item.image?.url ?? Res.image_lorem,
                                boxFit: BoxFit.cover),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: height * 1.7,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MyTextView(
                      text: item.title,
                      maxLine: 2,
                      textAlign: TextAlign.start,
                      textStyle: textSmallxxx.copyWith(
                          fontFamily: MyFontFamily.graphik,
                          fontWeight: MyFontWeight.medium),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        UIUtil.makeImageWidget(
                            item?.category?.icon ?? Res.image_lorem,
                            boxFit: BoxFit.contain,
                            filterQuality: FilterQuality.high,
                            height: sizeSmallxxxx),
                        const SizedBox(
                          width: sizeVerySmall,
                        ),
                        Flexible(
                          child: MyTextView(
                            maxLine: 1,
                            text: item.category?.name ?? '',
                            textStyle: textSmallx.copyWith(
                                color: Colors.grey,
                                fontFamily: MyFontFamily.graphik,
                                fontWeight: MyFontWeight.regular),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
