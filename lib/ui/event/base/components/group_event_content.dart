import 'package:flutter/material.dart';

import '../../../../common/theme/theme.dart';
import '../../../../common/widget/my_text_view.dart';
import '../../../../data/model/events.dart';

class GroupEventContent extends StatelessWidget {
  final String titleNote;
  final List<EventInfo> events;

  const GroupEventContent({Key key, this.titleNote, this.events})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        MyTextView(
          text: titleNote,
          textStyle: textSmallxxx.copyWith(
              color: Colors.black,
              fontWeight: MyFontWeight.semiBold,
              fontFamily: MyFontFamily.graphik),
        ),
      ],
    );
  }
}
