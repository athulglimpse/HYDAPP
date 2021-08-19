import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:marvista/common/constants.dart';
import 'package:marvista/utils/ui_util.dart';
import 'package:store_redirect/store_redirect.dart';

import '../../../common/localization/lang.dart';
import '../../../common/theme/theme.dart';
import '../../../common/widget/my_text_view.dart';

class MapSettingCard extends StatelessWidget {
  final Function(bool) onClickAppleMap;
  final Function(bool) onClickGoogleMap;
  final Function(bool) onClickWazeMap;

  final bool appleMapValue;
  final bool googleMapValue;
  final bool wazeMapValue;

  final bool isAppleAvaiable;
  final bool isGoogleAvaiable;
  final bool isWazeAvaiable;

  MapSettingCard({
    Key key,
    this.onClickAppleMap,
    this.onClickGoogleMap,
    this.onClickWazeMap,
    this.appleMapValue,
    this.googleMapValue,
    this.wazeMapValue,
    this.isAppleAvaiable,
    this.isGoogleAvaiable,
    this.isWazeAvaiable,
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
            text: Lang.settings_map_setting.tr(),
            textStyle: textSmallxxx.copyWith(
                color: const Color(0xff212237),
                fontFamily: MyFontFamily.graphik,
                fontWeight: MyFontWeight.semiBold),
          ),
          const SizedBox(height: sizeSmallxxx),
          Column(
            children: [
              Container(
                padding: const EdgeInsets.all(sizeSmall),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    MyTextView(
                      text: Lang.settings_apple_map.tr(),
                      textStyle: textSmallxxx.copyWith(
                          color: const Color(0xff212237),
                          fontFamily: MyFontFamily.graphik,
                          fontWeight: MyFontWeight.medium),
                    ),
                    if (isAppleAvaiable)
                      CupertinoSwitch(
                        value: appleMapValue,
                        activeColor: const Color(0xffFBBC43),
                        onChanged: onClickAppleMap,
                      ),
                    if (!isAppleAvaiable)
                      Material(
                        elevation: 0,
                        borderRadius: const BorderRadius.all(
                            Radius.circular(sizeNormal)),
                        child: InkWell(
                          highlightColor: const Color(0x80FBBC43),
                          splashColor: const Color(0x80FBBC43),
                          borderRadius: const BorderRadius.all(
                              Radius.circular(sizeNormal)),
                          onTap: () {
                            StoreRedirect.redirect(
                                androidAppId: '', iOSAppId: 'id915056765');
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: sizeSmall, horizontal: sizeNormal),
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: const Color(0xffFBBC43), width: 1),
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(sizeNormal))),
                            child: MyTextView(
                              text: Lang.settings_get.tr(),
                            ),
                          ),
                        ),
                      )
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
          Column(
            children: [
              Container(
                padding: const EdgeInsets.all(sizeSmall),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    MyTextView(
                      text: Lang.settings_google_map.tr(),
                      textStyle: textSmallxxx.copyWith(
                          color: const Color(0xff212237),
                          fontFamily: MyFontFamily.graphik,
                          fontWeight: MyFontWeight.medium),
                    ),
                    if (isGoogleAvaiable)
                      CupertinoSwitch(
                        value: googleMapValue,
                        activeColor: const Color(0xffFBBC43),
                        onChanged: onClickGoogleMap,
                      ),
                    if (!isGoogleAvaiable)
                      Material(
                        elevation: 0,
                        borderRadius: const BorderRadius.all(
                            Radius.circular(sizeNormal)),
                        child: InkWell(
                          highlightColor: const Color(0x80FBBC43),
                          splashColor: const Color(0x80FBBC43),
                          borderRadius: const BorderRadius.all(
                              Radius.circular(sizeNormal)),
                          onTap: () {
                            StoreRedirect.redirect(
                                androidAppId: '', iOSAppId: 'id585027354');
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: sizeSmall, horizontal: sizeNormal),
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: const Color(0xffFBBC43), width: 1),
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(sizeNormal))),
                            child: MyTextView(
                              text: Lang.settings_get.tr(),
                            ),
                          ),
                        ),
                      )
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
          Column(
            children: [
              Container(
                padding: const EdgeInsets.all(sizeSmall),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    MyTextView(
                      text: Lang.settings_waze_map.tr(),
                      textStyle: textSmallxxx.copyWith(
                          color: const Color(0xff212237),
                          fontFamily: MyFontFamily.graphik,
                          fontWeight: MyFontWeight.medium),
                    ),
                    if (isWazeAvaiable)
                      CupertinoSwitch(
                        value: wazeMapValue,
                        activeColor: const Color(0xffFBBC43),
                        onChanged: onClickWazeMap,
                      ),
                    if (!isWazeAvaiable)
                      Material(
                        elevation: 0,
                        borderRadius: const BorderRadius.all(
                            Radius.circular(sizeNormal)),
                        child: InkWell(
                          highlightColor: const Color(0x80FBBC43),
                          splashColor: const Color(0x80FBBC43),
                          borderRadius: const BorderRadius.all(
                              Radius.circular(sizeNormal)),
                          onTap: () {
                            StoreRedirect.redirect(
                                androidAppId: '', iOSAppId: 'id323229106');
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: sizeSmall, horizontal: sizeNormal),
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: const Color(0xffFBBC43), width: 1),
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(sizeNormal))),
                            child: MyTextView(
                              text: Lang.settings_get.tr(),
                            ),
                          ),
                        ),
                      )
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
