import 'package:flutter/material.dart';
import 'package:marvista/data/source/api_end_point.dart';

import '../../data/model/app_config.dart';
import '../../utils/navigate_util.dart';
import '../theme/theme.dart';
import '../widget/my_text_view.dart';
import 'normal_dialog_template.dart';

class MaritalDialog extends StatelessWidget {
  final List<MaritalStatus> listMarital;
  final Function(MaritalStatus) onSelectMarital;
  final MaritalStatus maritalSelected;

  MaritalDialog(
      {@required this.listMarital, this.maritalSelected, this.onSelectMarital});

  @override
  Widget build(BuildContext context) {
    return NormalDialogTemplate.makeTemplate(
      Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            flex: 1,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: listMarital.length,
              itemBuilder: (BuildContext context, int index) {
                return renderItemGender(context, index, listMarital);
              },
            ),
          ),
        ],
      ),
      positionDialog: PositionDialog.center,
      insetMargin: const EdgeInsets.all(sizeExLarge),
    );
  }

  Widget renderItemGender(
      BuildContext context, int index, List<dynamic> arrMenu) {
    final item = arrMenu[index];
    return Material(
        color: Colors.white,
        child: InkWell(
          splashColor: Colors.blue.withAlpha(30),
          onTap: () {
            NavigateUtil.pop(context);
            onSelectMarital(item);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(
                horizontal: sizeSmallxxx, vertical: sizeSmall),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                MyTextView(
                    text: langCode.toUpperCase() == PARAM_EN ? item.nameEn : item.nameAr,
                    textStyle: textSmallxx.copyWith(
                        color: Colors.black, fontFamily: Fonts.Helvetica)),
                (maritalSelected != null && maritalSelected == item)
                    ? const Icon(
                        Icons.check_circle,
                        color: Colors.greenAccent,
                        size: sizeSmallxxx,
                      )
                    : const SizedBox()
              ],
            ),
          ),
        ));
  }
}
