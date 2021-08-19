import 'package:flutter/material.dart';
import '../../../../common/theme/theme.dart';
import '../../../../common/widget/my_text_view.dart';

class RecentWidget extends StatelessWidget {
  final String title;
  final String subTitle;

  const RecentWidget({
    Key key,
    this.title,
    this.subTitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Row(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: sizeNormal),
          child: const Icon(Icons.access_time,
              color: Colors.black, size: sizeNormalx),
        ),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MyTextView(
                text: title ?? '',
                textStyle: textSmallxx.copyWith(
                    color: Colors.black,
                    fontFamily: MyFontFamily.graphik,
                    fontWeight: MyFontWeight.medium),
              ),
              // Padding(
              //   padding:
              //       const EdgeInsets.only(top: sizeIcon, bottom: sizeVerySmall),
              //   child: MyTextView(
              //     text: subTitle ?? '',
              //     textStyle: textSmallx.copyWith(
              //         color: Colors.black,
              //         fontFamily: MyFontFamily.graphik,
              //         fontWeight: MyFontWeight.regular),
              //   ),
              // ),
              Container(
                width: size.width - (sizeLargexxx + sizeVerySmallx),
                height: 1,
                color: Colors.grey,
              )
            ],
          ),
        )
      ],
    );
  }
}
