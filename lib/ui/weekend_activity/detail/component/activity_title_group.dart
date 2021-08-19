import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../common/constants.dart';
import '../../../../common/localization/lang.dart';
import '../../../../common/theme/theme.dart';
import '../../../../common/widget/my_text_view.dart';
import '../bloc/weekend_activity_detail_bloc.dart';

class ActivityTitleGroup extends StatelessWidget {
  final WeekendActivityDetailState state;

  const ActivityTitleGroup({Key key, this.state}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MyTextView(
                text: state.activityModel?.title ?? '',
                textStyle: textNormalxxx.copyWith(
                    color: Colors.black,
                    fontWeight: MyFontWeight.bold,
                    fontFamily: MyFontFamily.publicoBanner),
              ),
              const SizedBox(height: sizeSmall),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MyTextView(
                    text: state.activityModel?.description ?? '',
                    textAlign: TextAlign.start,
                    textStyle: textSmallxx.copyWith(
                        color: Colors.black,
                        fontWeight: MyFontWeight.medium,
                        fontFamily: MyFontFamily.graphik),
                  ),
                  // MyTextView(
                  //   text: '${Lang.amenity_detail_suitable_for.tr()} '
                  //       '${state.activityModel?.pickOneSuitable?.name ?? ''}',
                  //   textStyle: textSmallx.copyWith(
                  //       color: Colors.grey,
                  //       fontWeight: MyFontWeight.regular,
                  //       fontFamily: MyFontFamily.graphik),
                  // ),
                ],
              ),
            ],
          ),
        ),
        if (state.activityModel?.phoneNumber?.isNotEmpty ?? false)
          GestureDetector(
            onTap: () {
              if (state.activityModel.phoneNumber.isNotEmpty) {
                launch('tel://${state.activityModel.phoneNumber}');
              }
            },
            child: Container(
              padding: const EdgeInsets.all(sizeSmallx),
              decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 1), // changes position of shadow
                    ),
                  ],
                  color: Colors.white,
                  borderRadius:
                      const BorderRadius.all(Radius.circular(sizeSmallxxx))),
              child: SvgPicture.asset(
                Res.ic_call,
                fit: BoxFit.cover,
                color: const Color(0xff429C9B),
                height: sizeNormalx,
              ),
            ),
          )
      ],
    );
  }
}
