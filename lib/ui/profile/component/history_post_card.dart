import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../common/localization/lang.dart';
import '../../../common/theme/theme.dart';
import '../../../common/widget/my_text_view.dart';
import '../bloc/bloc.dart';

@immutable
class HistoryPostCard extends StatelessWidget {
  final ProfileState state;

  const HistoryPostCard({Key key, this.state}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final listHistory = ['', '', '', '', ''];
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: sizeNormalxx),
      padding: const EdgeInsets.all(sizeSmallxxx),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MyTextView(
            text: Lang.profile_post_and_review.tr(),
            textStyle: textSmallxxx.copyWith(
                fontFamily: MyFontFamily.graphik,
                fontWeight: MyFontWeight.semiBold),
          ),
          const SizedBox(height: sizeSmallxxx),
          Container(
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(sizeSmall))),
            child: Column(
                children: listHistory
                    .asMap()
                    .map((index, e) => MapEntry(
                        index,
                        Container(
                          padding: const EdgeInsets.all(sizeVerySmallx),
                          child: Column(
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  ClipOval(
                                    child: Material(
                                      color: Colors.grey, // button color
                                      child: InkWell(
                                        splashColor: Colors.white,
                                        onTap: () {},
                                        // inkwell color
                                        child: const SizedBox(
                                            width: sizeNormalxx,
                                            height: sizeNormalxx,
                                            child: Icon(Icons.menu)),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: sizeNormal,
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        MyTextView(
                                          textAlign: TextAlign.start,
                                          text: 'Marsana Beach with the family',
                                          textStyle: textSmallxx.copyWith(
                                              color: const Color(0xff212237),
                                              fontFamily: MyFontFamily.graphik,
                                              fontWeight: MyFontWeight.regular),
                                        ),
                                        MyTextView(
                                          textAlign: TextAlign.start,
                                          text: 'Submitted on 17 October 2020',
                                          textStyle: textSmallx.copyWith(
                                              color: const Color(0xff212237)
                                                  .withOpacity(0.5),
                                              fontFamily: MyFontFamily.graphik,
                                              fontWeight: MyFontWeight.regular),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    width: sizeNormal,
                                  ),
                                  MyTextView(
                                    text: 'Pending',
                                    textStyle: textSmall.copyWith(
                                        color: const Color(0xffFBBC43),
                                        fontFamily: MyFontFamily.graphik,
                                        fontWeight: MyFontWeight.regular),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: sizeSmall,
                              ),
                              index == listHistory.length - 1
                                  ? const SizedBox()
                                  : const Padding(
                                      padding:
                                          EdgeInsets.only(left: sizeLargexx),
                                      child: Divider(
                                          color: Colors.grey, height: 1),
                                    )
                            ],
                          ),
                        )))
                    .values
                    .toList()),
          ),
        ],
      ),
    );
  }
}
