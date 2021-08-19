import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../../common/localization/lang.dart';
import '../../../common/theme/theme.dart';
import '../../../common/widget/my_button.dart';
import '../../../common/widget/my_text_view.dart';
import '../../../utils/navigate_util.dart';
import '../../login/login_page.dart';
import '../../register_opt/register_opt_page.dart';
import '../bloc/bloc.dart';

@immutable
class ProfileInfoCardForGuest extends StatelessWidget {
  final ProfileState state;

  const ProfileInfoCardForGuest({Key key, this.state}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: sizeNormalxx),
      padding: const EdgeInsets.all(sizeSmallx),
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(sizeSmallxx))),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          MyTextView(
            text: Lang.profile_register_or_login_to_enjoy_the_full.tr(),
            textStyle: textSmallxxx.copyWith(
              color: const Color(0xff212237),
              fontFamily: MyFontFamily.graphik,
              fontWeight: MyFontWeight.medium,
            ),
          ),
          const SizedBox(height: sizeSmall),
          MyButton(
            paddingHorizontal: sizeLarge,
            text: Lang.profile_register.tr(),
            onTap: () {
              NavigateUtil.openPage(context, RegisterOptPage.routeName);
            },
            isFillParent: false,
            textStyle: textNormal.copyWith(color: Colors.white),
            buttonColor: const Color(0xff242655),
          ),
          const SizedBox(height: sizeNormal),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text.rich(TextSpan(
                text: Lang.started_already_have_an_account.tr(),
                style: textSmallx.copyWith(color: Colors.grey),
                children: <InlineSpan>[
                  TextSpan(
                    text: Lang.started_login.tr(),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        NavigateUtil.openPage(context, LoginPage.routeName);
                      },
                    style: textSmallx.copyWith(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                ],
              )),
            ],
          ),
          const SizedBox(height: sizeSmallxxx),
        ],
      ),
    );
  }
}

// MyTextView(
// text: 'Level 2 >',
// textStyle: textSmallxx.copyWith(
// color: const Color(0xffFBBC43),
// fontFamily: MyFontFamily.graphik,
// fontWeight: MyFontWeight.regular,
// ),
// ),
// const SizedBox(height: sizeVerySmallx),
// LinearPercentIndicator(
// lineHeight: sizeVerySmall,
// percent: 0.7,
// backgroundColor: const Color(0xff212237).withOpacity(0.1),
// progressColor: const Color(0xffFBBC43),
// ),
// const SizedBox(height: sizeVerySmallx),
// Row(
// children: [
// Expanded(
// child: Container(
// alignment: Alignment.centerLeft,
// margin: const EdgeInsets.only(left: sizeVerySmallx),
// child: MyTextView(
// text: 'XP 261',
// textStyle: textSmallxx.copyWith(
// color: const Color(0xffFBBC43),
// fontFamily: MyFontFamily.graphik,
// fontWeight: MyFontWeight.regular,
// ),
// ),
// ),
// ),
// Expanded(
// child: Container(
// alignment: Alignment.centerRight,
// margin:const EdgeInsets.only(right: sizeVerySmallx),
// child: MyTextView(
// text: '300',
// textStyle: textSmallxx.copyWith(
// color:const Color(0xff212237).withOpacity(0.2),
// fontFamily: MyFontFamily.graphik,
// fontWeight: MyFontWeight.regular,
// ),
// ),
// ),
// ),
// ],
// ),
