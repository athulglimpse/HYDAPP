import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../data/model/places_model.dart';
import '../../utils/ui_util.dart';
import '../constants.dart';
import '../theme/theme.dart';
import 'my_text_view.dart';

class AssetNormalETAItem extends StatelessWidget {
  final Function(PlaceModel) onItemClick;
  final PlaceModel item;

  AssetNormalETAItem({
    Key key,
    this.onItemClick,
    this.item,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onItemClick(item);
      },
      child: Padding(
        padding: const EdgeInsets.all(sizeVerySmall),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(sizeSmall),
              child: UIUtil.makeImageWidget(item?.image?.url ?? Res.image_lorem,
                  height: sizeImageSmall,
                  width: sizeImageNormalx,
                  boxFit: BoxFit.cover),
            ),
            const SizedBox(height: sizeVerySmall),
            MyTextView(
              text: item.title,
              maxLine: 1,
              textStyle: textSmallxx.copyWith(
                  color: Colors.black,
                  fontFamily: MyFontFamily.graphik,
                  fontWeight: MyFontWeight.medium),
            ),
            (item.eta != null)
                ? SizedBox(
                    width: sizeImageNormalx,
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
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
                    ),
                  )
                : SizedBox(
                    width: sizeImageNormalx,
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
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
                  ),
          ],
        ),
      ),
    );
  }
}
