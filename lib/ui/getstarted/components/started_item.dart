import 'package:flutter/material.dart';
import 'package:marvista/common/theme/theme.dart';
import 'package:marvista/common/widget/my_text_view.dart';

import '../../../data/model/static_content.dart';
import '../../../utils/ui_util.dart';

class StartedItem extends StatelessWidget {
  final GetStatedContent itemIntro;

  const StartedItem({
    Key key,
    this.itemIntro,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 3,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: sizeNormal),
                  child: UIUtil.makeImageWidget(
                    itemIntro.image,
                    boxFit: BoxFit.contain,
                    filterQuality: FilterQuality.high,
                  ),
                ),
              ),
              Positioned.fill(
                child: Align(
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Align(
                        alignment: Alignment.center,
                        child: MyTextView(
                          textAlign: TextAlign.center,
                          text: itemIntro?.title ?? '',
                          textStyle: textLargexxx.copyWith(
                              color: Colors.white, fontFamily: Fonts.Helvetica),
                        ),
                      ),
                      const SizedBox(height: sizeNormalx),
                      Align(
                        alignment: Alignment.center,
                        child: MyTextView(
                          textAlign: TextAlign.center,
                          text: itemIntro.description ?? '',
                          textStyle: textSmallxx.copyWith(
                              color: const Color.fromARGB(153, 255, 255, 255),
                              fontFamily: Fonts.Helvetica),
                        ),
                      ),
                      const SizedBox(height: sizeLargexx),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const Expanded(
          flex: 1,
          child: SizedBox(),
        )
      ],
    );
  }
}
