import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../data/model/language.dart';
import '../../utils/navigate_util.dart';
import '../../utils/ui_util.dart';
import '../constants.dart';
import '../localization/lang.dart';
import '../theme/theme.dart';
import '../widget/my_text_view.dart';

@immutable
class DialogSelectLang extends StatelessWidget {
  final List<Language> arrLanguage;

  DialogSelectLang({
    @required this.arrLanguage,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(sizeSmall),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(sizeSmallxxx),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: dialogContent(context),
    );
  }

  Widget dialogContent(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.only(
            top: sizeSmall,
            bottom: sizeSmall,
            left: sizeSmall,
            right: sizeSmall,
          ),
          margin: const EdgeInsets.only(top: sizeNormalxxx),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(sizeSmallxxx),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: sizeSmall,
                offset: Offset(0.0, sizeSmall),
              ),
            ],
          ),
          child: ListView.builder(
              shrinkWrap: true,
              itemCount: arrLanguage.length,
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                  splashColor: Colors.blue.withAlpha(30),
                  onTap: () {
                    print(arrLanguage[index].toJson());
                    NavigateUtil.pop(context, argument: arrLanguage[index]);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(sizeSmallxxx),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        UIUtil.makeImageWidget(
                            Res.getFlagPath(arrLanguage[index].image),
                            width: sizeNormal),
                        const SizedBox(width: sizeSmallxxx),
                        MyTextView(
                            textAlign: TextAlign.center,
                            text: arrLanguage[index].name,
                            textStyle: textSmallxx.copyWith(
                              color: Colors.black,
                            )),
                      ],
                    ),
                  ),
                );
              }),
        ),
        Positioned(
          left: sizeSmallxxx,
          child: MyTextView(
            text: Lang.started_select_language.tr(),
            textStyle: textSmallxx.copyWith(
                color: Colors.white, fontFamily: Fonts.Helvetica),
          ),
        ),
      ],
    );
  }
}
