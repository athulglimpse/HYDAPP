import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../utils/app_const.dart';
import '../../utils/ui_util.dart';
import '../constants.dart';
import '../localization/lang.dart';
import '../theme/theme.dart';
import 'my_text_view.dart';

class MySocialMedia extends StatelessWidget {
  final String title;
  final String iconFacebook;
  final String iconInstagram;
  final String iconTwitter;
  final String linkFacebook;
  final String linkInstagram;
  final String linkTwitter;
  final EdgeInsets padding;
  final bool isHorizontal;

  const MySocialMedia({Key key,
    this.title,
    this.iconFacebook,
    this.iconInstagram,
    this.iconTwitter,
    this.linkFacebook,
    this.linkInstagram,
    this.linkTwitter,
    this.padding =
    const EdgeInsets.only(left: sizeSmallxxx, right: sizeSmallxxx),
    this.isHorizontal = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: padding,
        child: isHorizontal
            ? renderHorizontalButton()
            : ((linkFacebook != null ||
            linkInstagram != null ||
            linkTwitter != null)
            ? renderVerticalButton()
            : const SizedBox()));
  }

  Widget renderHorizontalButton() {
    return Row(
      children: [
        MyTextView(
          text: title ?? Lang.more_follow_us_on_social_media.tr(),
          textStyle: textSmallxxx.copyWith(
              color: Colors.black,
              fontFamily: MyFontFamily.graphik,
              fontWeight: MyFontWeight.semiBold),
        ),
        const SizedBox(width: sizeNormal),
        GestureDetector(
            onTap: () {
              launch(linkFacebook ?? DEFAULT_URL_FACEBOOK);
            },
            child: iconFacebook != null
                ? UIUtil.makeImageWidget(iconFacebook,
                boxFit: BoxFit.contain)
                : SvgPicture.asset(Res.ic_facebook_social,
                fit: BoxFit.contain)),
        const SizedBox(width: sizeSmall),
        GestureDetector(
            onTap: () {
              launch(linkInstagram ?? DEFAULT_URL_INSTAGRAM);
            },
            child: iconInstagram != null
                ? UIUtil.makeImageWidget(iconInstagram,
                boxFit: BoxFit.contain)
                : SvgPicture.asset(Res.ic_instagram_social,
                fit: BoxFit.contain)),
        const SizedBox(width: sizeSmall),
        GestureDetector(
            onTap: () {
              launch(linkTwitter ?? DEFAULT_URL_TWITTER);
            },
            child: iconTwitter != null
                ? UIUtil.makeImageWidget(iconTwitter,
                boxFit: BoxFit.contain)
                : SvgPicture.asset(Res.ic_twitter_social,
                fit: BoxFit.contain)),
      ],
    );
  }

  Widget renderVerticalButton() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MyTextView(
          text: title ?? Lang.more_follow_us_on_social_media.tr(),
          textStyle: textSmallxxx.copyWith(
              color: Colors.black,
              fontFamily: MyFontFamily.graphik,
              fontWeight: MyFontWeight.semiBold),
        ),
        const SizedBox(height: sizeSmallxxx),
        Row(
          children: [
            linkFacebook != null
                ? GestureDetector(
                onTap: () {
                  launch(linkFacebook ?? DEFAULT_URL_FACEBOOK);
                },
                child: iconFacebook != null
                    ? UIUtil.makeImageWidget(iconFacebook,
                    boxFit: BoxFit.contain)
                    : SvgPicture.asset(Res.ic_facebook_social,
                    fit: BoxFit.contain))
                : const SizedBox(),
            const SizedBox(width: sizeSmall),
            linkInstagram != null
                ? GestureDetector(
                onTap: () {
                  launch(linkInstagram ?? DEFAULT_URL_INSTAGRAM);
                },
                child: iconInstagram != null
                    ? UIUtil.makeImageWidget(iconInstagram,
                    boxFit: BoxFit.contain)
                    : SvgPicture.asset(Res.ic_instagram_social,
                    fit: BoxFit.contain))
                : const SizedBox(),
            const SizedBox(width: sizeSmall),
            linkTwitter != null
                ? GestureDetector(
                onTap: () {
                  launch(linkTwitter ?? DEFAULT_URL_TWITTER);
                },
                child: iconTwitter != null
                    ? UIUtil.makeImageWidget(iconTwitter,
                    boxFit: BoxFit.contain)
                    : SvgPicture.asset(Res.ic_twitter_social,
                    fit: BoxFit.contain))
                : const SizedBox(),
          ],
        ),
      ],
    );
  }
}
