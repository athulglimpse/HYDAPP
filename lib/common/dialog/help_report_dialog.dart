import 'package:flutter/material.dart';
import 'package:marvista/data/model/help_report_model.dart';
import '../../data/model/more_item.dart';

import '../../utils/navigate_util.dart';
import '../theme/theme.dart';
import '../widget/my_text_view.dart';
import 'normal_dialog_template.dart';

class HelpReportDialog extends StatelessWidget {
  final List<HelpReportModel> list;
  final Function(HelpReportModel) onSelectItem;
  final HelpReportModel itemSelected;

  const HelpReportDialog(
      {Key key, this.list, this.onSelectItem, this.itemSelected})
      : super(key: key);

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
              itemCount: list.length,
              itemBuilder: (BuildContext context, int index) {
                return renderItemCountry(context, index, list);
              },
            ),
          ),
        ],
      ),
      positionDialog: PositionDialog.center,
      insetMargin: const EdgeInsets.all(sizeLarge),
    );
  }

  Widget renderItemCountry(
      BuildContext context, int index, List<dynamic> arrMenu) {
    final HelpReportModel item = arrMenu[index];
    return Material(
        color: Colors.white,
        child: InkWell(
          splashColor: Colors.blue.withAlpha(30),
          onTap: () {
            NavigateUtil.pop(context);
            onSelectItem(item);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(
                horizontal: sizeSmallxxx, vertical: sizeSmall),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: MyTextView(
                      textAlign: TextAlign.start,
                      // ignore: prefer_interpolation_to_compose_strings
                      text: item.name,
                      textStyle: textSmallxx.copyWith(
                          color: Colors.black,
                          fontFamily: Fonts.Helvetica,
                          fontWeight: MyFontWeight.regular)),
                ),
                const SizedBox(width: sizeSmall),
                (itemSelected != null && itemSelected.id == item.id)
                    ? const Icon(
                        Icons.check_circle,
                        color: Colors.greenAccent,
                        size: sizeSmallxxx,
                      )
                    : const SizedBox(width: sizeSmallxxx)
              ],
            ),
          ),
        ));
  }
}
