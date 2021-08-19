import 'package:flutter/material.dart';

import '../../../../common/constants.dart';
import '../../../../common/theme/theme.dart';
import '../../../../common/widget/my_text_view.dart';
import '../../../../data/model/places_model.dart';
import '../../../../utils/ui_util.dart';

class ActivityPlaceInfoCard extends StatelessWidget {
  final EdgeInsetsGeometry margin;
  final EdgeInsetsGeometry horizontalMarginInfoCard;
  final double borderRadius;
  final TextStyle textSizeTitle;
  final TextStyle textSizeSubTitle;
  final PlaceModel placeModel;
  final Function(PlaceModel) onItemClick;
  final Function(PlaceModel) onItemClickDirection;

  ActivityPlaceInfoCard({
    Key key,
    this.textSizeSubTitle = textSmall,
    this.textSizeTitle = textSmallx,
    this.horizontalMarginInfoCard =
        const EdgeInsets.symmetric(horizontal: sizeVerySmall),
    this.margin = const EdgeInsets.only(right: sizeNormal),
    this.borderRadius = sizeSmall,
    this.placeModel,
    this.onItemClick,
    this.onItemClickDirection,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      child: GestureDetector(
        onTap: () {
          onItemClick(placeModel);
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(borderRadius),
          child: AspectRatio(
            aspectRatio: 1.4,
            child: Container(
              color: Colors.transparent,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Container(
                    margin: const EdgeInsets.only(bottom: sizeNormalxx),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(borderRadius),
                      child: UIUtil.makeImageWidget(
                          placeModel?.image?.url ?? Res.image_lorem,
                          boxFit: BoxFit.cover),
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
                                    text: placeModel?.title ?? '',
                                    textAlign: TextAlign.start,
                                    maxLine: 1,
                                    textStyle: textSizeTitle,
                                  ),
                                  const SizedBox(height: sizeVerySmall),
                                  MyTextView(
                                    text:
                                        placeModel?.pickOneLocation?.address ??
                                            '',
                                    textAlign: TextAlign.start,
                                    maxLine: 2,
                                    textStyle: textSizeSubTitle.copyWith(
                                        color: Colors.black.withAlpha(128)),
                                  )
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                onItemClickDirection(placeModel);
                              },
                              child: const Icon(
                                Icons.directions,
                                color: Color(0xff419C9B),
                                size: sizeNormalxx,
                              ),
                            )
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
      ),
    );
  }
}
