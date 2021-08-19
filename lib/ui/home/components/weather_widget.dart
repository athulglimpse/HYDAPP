import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../common/di/injection/injector.dart';
import '../../../common/localization/lang.dart';
import '../../../common/theme/theme.dart';
import '../../../common/widget/my_text_view.dart';
import '../../../data/model/user_info.dart';
import '../../../data/model/weather_info.dart';
import '../../../utils/date_util.dart';
import '../../../utils/ui_util.dart';
import '../../../utils/weather_service.dart';

@immutable
class WeatherWidget extends StatelessWidget {
  final WeatherInfo weatherInfo;
  final WeatherService weatherService = sl<WeatherService>();
  final UserInfo userInfo;
  WeatherWidget({Key key, this.weatherInfo, this.userInfo}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    String iconWeather;
    if (weatherInfo?.weatherIcon != null) {
      iconWeather = weatherInfo.weatherIcon.toString();
    }
    return Container(
      margin: const EdgeInsets.only(top: sizeNormal),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Row(
              children: [
                if (userInfo?.isUser() ?? false)
                  UIUtil.makeCircleImageWidget(userInfo?.photo?.url?.trim(),
                      size: sizeLarge,
                      initialName: userInfo?.fullName ?? 'Guest'),
                const SizedBox(
                  width: sizeSmall,
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      MyTextView(
                        text: DateUtil.dateFormatEEEEddMM(DateTime.now(),
                            local: context.locale.languageCode),
                        textStyle: textSmallx.copyWith(
                            color: Colors.grey,
                            fontFamily: MyFontFamily.graphik,
                            fontWeight: MyFontWeight.regular),
                      ),
                      (userInfo?.isUser() ?? false)
                          ? MyTextView(
                              maxLine: 1,
                              textAlign: TextAlign.start,
                              text: '${DateUtil.greeting()}, '
                                  '${userInfo.fullName}',
                              textStyle: textSmallxxx.copyWith(
                                  color: Colors.black,
                                  fontFamily: MyFontFamily.publicoBanner,
                                  fontWeight: MyFontWeight.bold),
                            )
                          : MyTextView(
                              textAlign: TextAlign.start,
                              text: Lang.home_welcome.tr(),
                              textStyle: textSmallxxx.copyWith(
                                  color: Colors.black,
                                  fontFamily: MyFontFamily.publicoBanner,
                                  fontWeight: MyFontWeight.bold),
                            )
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: sizeSmall),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    MyTextView(
                      text: weatherInfo != null
                          ? '${weatherInfo.temperature.value}\u2103'
                          : '__',
                      textAlign: TextAlign.center,
                      textStyle: textSmallxxx.copyWith(
                          color: Colors.black,
                          fontFamily: MyFontFamily.graphik,
                          fontWeight: MyFontWeight.regular),
                    ),
                    const SizedBox(
                      width: sizeVerySmall,
                    ),
                    if (iconWeather != null)
                      UIUtil.makeImageWidget(
                          weatherService.getImageLink(iconWeather),
                          size: const Size(sizeNormalxxx, sizeNormalxxx)),
                  ],
                ),
                MyTextView(
                  text: Lang.home_powered_by_accuweather.tr(),
                  textStyle: textVerySmallx.copyWith(
                      color: Colors.black,
                      fontFamily: MyFontFamily.graphik,
                      fontWeight: MyFontWeight.regular),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
