import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../common/constants.dart';
import '../../../common/localization/lang.dart';
import '../../../common/theme/theme.dart';
import '../../../common/widget/my_text_view.dart';
import '../../../utils/navigate_util.dart';
import '../../../utils/ui_util.dart';
import '../../notification_setting/notification_setting_page.dart';

class AppSettingsCard extends StatelessWidget {
  final Function onClickLanguage;
  final Function(bool) onClickNotification;
  final bool isNotification;
  final bool showNotificationSetting;

  const AppSettingsCard({
    Key key,
    this.onClickLanguage,
    this.onClickNotification,
    this.isNotification,
    this.showNotificationSetting,
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
            text: Lang.settings_app_settings.tr(),
            textStyle: textSmallxxx.copyWith(
                color: const Color(0xff212237),
                fontFamily: MyFontFamily.graphik,
                fontWeight: MyFontWeight.semiBold),
          ),
          const SizedBox(height: sizeSmallxxx),
          InkWell(
            onTap: onClickLanguage,
            child: Column(
              children: [
                GestureDetector(
                  onTap: onClickLanguage,
                  child: Container(
                    padding: const EdgeInsets.all(sizeSmall),
                    child: Row(
                      children: <Widget>[
                        UIUtil.makeImageWidget(Res.setting_icon_language,
                            width: sizeNormalx, height: sizeNormalx),
                        const SizedBox(width: sizeNormalxx),
                        MyTextView(
                          text: Lang.settings_language.tr(),
                          textStyle: textSmallxxx.copyWith(
                              color: const Color(0xff212237),
                              fontFamily: MyFontFamily.graphik,
                              fontWeight: MyFontWeight.medium),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          showNotificationSetting
              ? Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(
                          left: sizeLargexxx + sizeVerySmallx,
                          bottom: sizeSmall,
                          right: sizeSmall),
                      child: Divider(color: Colors.grey, height: 1),
                    ),
                    Container(
                      padding: const EdgeInsets.only(
                          left: sizeSmall, bottom: sizeSmall),
                      child: Row(
                        children: <Widget>[
                          UIUtil.makeImageWidget(Res.setting_icon_notification,
                              width: sizeNormalx, height: sizeNormalx),
                          const SizedBox(width: sizeNormalxx),
                          Expanded(
                            flex: 1,
                            child: Padding(
                              padding: const EdgeInsets.only(right: sizeSmall),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: GestureDetector(
                                      onTap: () async {
                                        await NavigateUtil.openPage(
                                            context,
                                            NotificationSettingScreen
                                                .routeName);
                                      },
                                      child: Container(
                                        alignment: Alignment.centerLeft,
                                        margin: const EdgeInsets.only(
                                            right: sizeNormal),
                                        height: sizeNormalxx,
                                        decoration: const BoxDecoration(
                                            color: Colors.white,
                                            border: Border(
                                                right: BorderSide(
                                                    color: Color(0xffE8E8EB)))),
                                        child: MyTextView(
                                          textAlign: TextAlign.start,
                                          text:
                                              Lang.settings_notifications.tr(),
                                          textStyle: textSmallxxx.copyWith(
                                              color: const Color(0xff212237),
                                              fontFamily: MyFontFamily.graphik,
                                              fontWeight: MyFontWeight.medium),
                                        ),
                                      ),
                                    ),
                                  ),
                                  CupertinoSwitch(
                                    value: isNotification,
                                    activeColor: const Color(0xffFBBC43),
                                    onChanged: onClickNotification,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              : const SizedBox(height: sizeNormalxx),
        ],
      ),
    );
  }
}
