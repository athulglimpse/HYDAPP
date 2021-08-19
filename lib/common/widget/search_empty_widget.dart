import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../utils/ui_util.dart';
import '../constants.dart';
import '../localization/lang.dart';
import '../theme/theme.dart';

class SearchEmptyWidget extends StatelessWidget {
  final String keyWord;
  final bool justInformEmpty;

  SearchEmptyWidget({
    this.keyWord,
    this.justInformEmpty = false,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: sizeNormalxxx),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: sizeNormalx),
              child: UIUtil.makeImageWidget(Res.default_search,
                  boxFit: BoxFit.cover),
            ),
            if (!justInformEmpty)
              Padding(
                  padding: const EdgeInsets.all(sizeSmall),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        Lang.home_sorry_we_could_not_find_anything.tr(),
                        style: textNormal,
                      ),
                      Text.rich(TextSpan(
                        text: Lang.home_to_show_for.tr(),
                        style: textNormal,
                        children: <InlineSpan>[
                          TextSpan(
                            text: '\"$keyWord\"' ?? '',
                            style: textNormal.copyWith(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),textAlign: TextAlign.center,),
                    ],
                  )),
            if (!justInformEmpty)
              Text(
                Lang.home_please_try_searching_with_another_term.tr(),
                textAlign: TextAlign.center,
                style: textSmallxx.copyWith(color: Colors.black87),
              ),
            if (justInformEmpty && (keyWord?.isNotEmpty ?? false))
              Column(
                children: [
                  const SizedBox(
                    height: sizeNormal,
                  ),
                  Text(
                    keyWord,
                    textAlign: TextAlign.center,
                    style: textNormalxxx.copyWith(
                        color: Colors.grey,
                        fontWeight: MyFontWeight.black,
                        fontFamily: MyFontFamily.publicoBanner),
                  ),
                ],
              )
          ],
        ),
      ),
    );
  }
}
