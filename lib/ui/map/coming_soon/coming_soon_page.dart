import 'package:flutter/material.dart';

import 'package:easy_localization/easy_localization.dart';
import '../../../common/localization/lang.dart';
import '../../../common/widget/search_empty_widget.dart';

class ComingSoonPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffFDFBF5),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SearchEmptyWidget(
              keyWord: Lang.map_coming_soon.tr(),
              justInformEmpty: true,
            ),
          ],
        ),
      ),
    );
  }
}
