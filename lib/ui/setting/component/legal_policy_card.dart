import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:marvista/common/constants.dart';
import 'package:marvista/utils/ui_util.dart';

import '../../../common/localization/lang.dart';
import '../../../common/theme/theme.dart';
import '../../../common/widget/my_text_view.dart';

class LegalPolicySettingsCard extends StatelessWidget {
  final Function() onClickItemPolicy;
  final Function() onClickItemCondition;

  const LegalPolicySettingsCard({
    Key key,
    this.onClickItemPolicy,
    this.onClickItemCondition,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
          left: sizeNormal, top: sizeNormal, right: sizeNormal),
      decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(bottom: BorderSide(color: Color(0xffE8E8EB)))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MyTextView(
            text: Lang.settings_legal_and_policies.tr(),
            textStyle: textSmallxxx.copyWith(
                color: const Color(0xff212237),
                fontFamily: MyFontFamily.graphik,
                fontWeight: MyFontWeight.semiBold),
          ),
          const SizedBox(height: sizeSmallxxx),
          InkWell(
            onTap: onClickItemCondition,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(sizeSmall),
                  child: Row(
                    children: <Widget>[
                      UIUtil.makeImageWidget(Res.setting_icon_term,
                          width: sizeNormalx, height: sizeNormalx),
                      const SizedBox(width: sizeNormalxx),
                      MyTextView(
                        text: Lang.settings_terms_and_conditions.tr(),
                        textStyle: textSmallxxx.copyWith(
                            color: const Color(0xff212237),
                            fontFamily: MyFontFamily.graphik,
                            fontWeight: MyFontWeight.medium),
                      ),
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(
                      left: sizeLargexxx + sizeVerySmallx,
                      bottom: sizeSmall,
                      right: sizeSmall),
                  child: Divider(color: Colors.grey, height: 1),
                ),
              ],
            ),
          ),
          InkWell(
            onTap: onClickItemPolicy,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(sizeSmall),
                  child: Row(
                    children: <Widget>[
                      UIUtil.makeImageWidget(Res.setting_icon_privacy,
                          width: sizeNormalx, height: sizeNormalx),
                      const SizedBox(width: sizeNormalxx),
                      MyTextView(
                        text: Lang.settings_privacy_policy.tr(),
                        textStyle: textSmallxxx.copyWith(
                            color: const Color(0xff212237),
                            fontFamily: MyFontFamily.graphik,
                            fontWeight: MyFontWeight.medium),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
