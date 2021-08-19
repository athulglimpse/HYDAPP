import 'package:flutter/material.dart';

import '../../data/model/places_model.dart';
import '../../utils/ui_util.dart';
import '../constants.dart';
import '../theme/theme.dart';
import 'my_text_view.dart';

class AssetSmallItem extends StatelessWidget {
  final Function(PlaceModel) onItemClick;
  final PlaceModel item;

  AssetSmallItem({
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
      child: Stack(
        fit: StackFit.expand,
        children: [
          Container(
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
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                UIUtil.makeImageWidget(
                                    item?.category?.icon ?? Res.image_lorem,
                                    width: sizeSmallxxx),
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
                          )
                        ],
                      )
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
