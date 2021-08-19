import 'package:flutter/material.dart';

import '../../../../common/constants.dart';
import '../../../../common/theme/theme.dart';
import '../../../../common/widget/my_text_view.dart';
import '../../../../utils/ui_util.dart';

class AssetInfoCard extends StatelessWidget {
  final EdgeInsetsGeometry margin;
  final EdgeInsetsGeometry horizontalMarginInfoCard;
  final double borderRadius;
  final TextStyle textSizeTitle;
  final TextStyle textSizeSubTitle;

  AssetInfoCard({
    Key key,
    this.textSizeSubTitle = textSmall,
    this.textSizeTitle = textSmallx,
    this.horizontalMarginInfoCard =
        const EdgeInsets.symmetric(horizontal: sizeVerySmall),
    this.margin = const EdgeInsets.only(right: sizeNormal),
    this.borderRadius = sizeSmall,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      child: GestureDetector(
        onTap: () {},
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
                      child: UIUtil.makeImageWidget(Res.img_temp_05,
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
                                    text: 'communityInfo.title',
                                    textAlign: TextAlign.start,
                                    maxLine: 1,
                                    textStyle: textSizeTitle,
                                  ),
                                  const SizedBox(height: sizeVerySmall),
                                  MyTextView(
                                    text: 'communityInfo.category',
                                    textAlign: TextAlign.start,
                                    maxLine: 1,
                                    textStyle: textSizeSubTitle.copyWith(
                                        color: Colors.black.withAlpha(128)),
                                  )
                                ],
                              ),
                            ),
                            const Icon(
                              Icons.directions,
                              color: Color(0xff419C9B),
                              size: sizeNormalxx,
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
