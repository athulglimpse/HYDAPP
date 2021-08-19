import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:marvista/common/constants.dart';
import 'package:marvista/utils/ui_util.dart';

import '../../../common/localization/lang.dart';
import '../../../common/theme/theme.dart';
import '../../../common/widget/my_text_view.dart';

class AccountSettingsCard extends StatelessWidget {
  final Function() onClickDeactivateAccount;
  final Function() onClickChangePassword;
  final bool showChangePassword;

  const AccountSettingsCard(
      {Key key,
      this.onClickDeactivateAccount,
      this.onClickChangePassword,
      this.showChangePassword})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        left: sizeNormal,
        top: sizeNormal,
        right: sizeNormal,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
            bottom: BorderSide(
          color: Color(0xffE8E8EB),
        )),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MyTextView(
            text: Lang.settings_account_settings.tr(),
            textStyle: textSmallxxx.copyWith(
                color: const Color(0xff212237),
                fontFamily: MyFontFamily.graphik,
                fontWeight: MyFontWeight.semiBold),
          ),
          const SizedBox(height: sizeSmallxxx),
          if(showChangePassword)
            InkWell(
            onTap: onClickChangePassword,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(sizeSmall),
                  child: Row(
                    children: <Widget>[
                      UIUtil.makeImageWidget(Res.setting_icon_change_password,
                          width: sizeNormalx, height: sizeNormalx),
                      const SizedBox(
                        width: sizeNormalxx,
                      ),
                      MyTextView(
                        text: Lang.settings_change_password.tr(),
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
                    right: sizeSmall,
                  ),
                  child: Divider(color: Colors.grey, height: 1),
                ),
              ],
            ),
          ),
          // InkWell(
          //   onTap: () {
          //     // onClickItemMenu();
          //   },
          //   child: Column(
          //     children: [
          //       Container(
          //         padding: const EdgeInsets.all(sizeSmall),
          //         child: Row(
          //           children: <Widget>[
          //             const SizedBox(
          //                 width: sizeNormalxx,
          //                 height: sizeNormalxx,
          //                 child: Icon(
          //                   Icons.mail_outline,
          //                   color: Color(0xffFBBC43),
          //                 )),
          //             const SizedBox(
          //               width: sizeNormal,
          //             ),
          //             MyTextView(
          //               text: Lang.settings_change_email.tr(),
          //               textStyle: textSmallxxx.copyWith(
          //                   color: const Color(0xff212237),
          //                   fontFamily: MyFontFamily.graphik,
          //                   fontWeight: MyFontWeight.medium),
          //             ),
          //           ],
          //         ),
          //       ),
          //       const Padding(
          //         padding: EdgeInsets.only(
          //             left: sizeLargexxx, bottom: sizeSmall, right: sizeSmall),
          //         child: Divider(color: Colors.grey, height: 1),
          //       ),
          //     ],
          //   ),
          // ),
          InkWell(
            onTap: onClickDeactivateAccount,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(sizeSmall),
                  child: Row(
                    children: <Widget>[
                      UIUtil.makeImageWidget(
                          Res.setting_icon_deactivate_account,
                          width: sizeNormalx,
                          height: sizeNormalx),
                      const SizedBox(
                        width: sizeNormalxx,
                      ),
                      MyTextView(
                        text: Lang.settings_deactivate_account.tr(),
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
