import 'package:flutter/material.dart';

import '../../../common/theme/theme.dart';
import '../../../common/widget/my_text_view.dart';
import '../bloc/bloc.dart';

@immutable
class ProfileInfoCard extends StatelessWidget {
  final ProfileState state;

  const ProfileInfoCard({Key key, this.state}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: sizeNormalxx),
      padding: const EdgeInsets.all(sizeSmallxxx),
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(sizeSmallxx))),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          MyTextView(
            text: state?.userInfo?.fullName ?? '',
            maxLine: 1,
            textStyle: textNormalxxx.copyWith(
              color: const Color(0xff212237),
              fontFamily: MyFontFamily.publicoBanner,
              fontWeight: MyFontWeight.bold,
            ),
          ),
          const SizedBox(height: sizeSmallx),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: MyTextView(
                  text: state?.userInfo?.email ?? '',
                  textStyle: textSmallxxx.copyWith(
                    color: const Color(0xff212237).withOpacity(0.5),
                    fontFamily: MyFontFamily.graphik,
                    fontWeight: MyFontWeight.regular,
                  ),
                ),
              ),
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
