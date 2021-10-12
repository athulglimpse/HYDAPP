import 'package:flutter/material.dart';
import 'package:marvista/common/localization/lang.dart';

import 'package:marvista/common/theme/theme.dart';
import 'package:marvista/common/widget/my_text_view.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../data/model/static_content.dart';
import '../../../utils/ui_util.dart';

class StartedItem extends StatelessWidget {
  final GetStatedContent itemIntro;
  final int index;

  const StartedItem({
    Key key,
    this.itemIntro,this.index
  }) : super(key: key);

  static List<String> itemList = <String>[];

  @override
  Widget build(BuildContext context) {
    itemList.clear();
    itemList.add(Lang.started_item_1);
    itemList.add(Lang.started_item_2);
    itemList.add(Lang.started_item_3);
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
                          text: itemList[index].tr(),
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
