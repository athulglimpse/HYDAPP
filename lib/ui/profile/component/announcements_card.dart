import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../common/constants.dart';
import '../../../common/theme/theme.dart';
import '../../../common/widget/my_text_view.dart';
import '../bloc/bloc.dart';

class AnnouncementCard extends StatelessWidget {
  final ProfileState state;

  const AnnouncementCard({Key key, this.state}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.center,
      children: [
        SvgPicture.asset(
          Res.icon_announcements,
          fit: BoxFit.fill,
        ),
        const Positioned(
          right: sizeLargexx,
          top: sizeSmall,
          child: Icon(
            Icons.clear,
            size: sizeSmallxx,
            color: Colors.white,
          ),
        ),
        Container(
          child: Padding(
            padding: const EdgeInsets.only(
                left: sizeLargexx, right: sizeImageNormalxx),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MyTextView(
                  textAlign: TextAlign.left,
                  text: 'Check out your saved items',
                  textStyle: textSmallxx.copyWith(
                    color: Colors.white,
                    fontFamily: MyFontFamily.graphik,
                    fontWeight: MyFontWeight.medium,
                  ),
                ),
                const SizedBox(height: sizeSmall),
                MyTextView(
                  textAlign: TextAlign.left,
                  text: 'Lorem Ipsum is simply dummy text of the printing .',
                  textStyle: textSmallx.copyWith(
                    color: Colors.white,
                    fontFamily: MyFontFamily.graphik,
                    fontWeight: MyFontWeight.regular,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
