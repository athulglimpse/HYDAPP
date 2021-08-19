import 'package:flutter/material.dart';
import 'package:marvista/data/source/api_end_point.dart';

import '../../data/model/area_item.dart';
import '../../utils/navigate_util.dart';
import '../../utils/ui_util.dart';
import '../theme/theme.dart';
import '../widget/my_text_view.dart';
import 'normal_dialog_template.dart';

class ExperiencesDialog extends StatelessWidget {
  final List<AreaItem> listArea;
  final Function(AreaItem) onSelectArea;
  final AreaItem areaSelected;

  ExperiencesDialog({this.listArea, this.onSelectArea, this.areaSelected});

  @override
  Widget build(BuildContext context) {
    return NormalDialogTemplate.makeTemplate(
        Row(
          children: [
            Expanded(
              flex: 1,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListView.builder(
                    padding: const EdgeInsets.only(
                        bottom: sizeNormal, top: sizeLargexx),
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: listArea.length,
                    itemBuilder: (BuildContext context, int index) {
                      final item = listArea[index];
                      return item.isSingle == '1'
                          ? renderAreaSingleItem(context, index, listArea)
                          : renderAreaItem(context, index, listArea);
                    },
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: sizeNormalxx),
                    width: sizeNormalxxx,
                    height: 4,
                    decoration: const BoxDecoration(
                        color: Color(0x21212237),
                        borderRadius:
                        BorderRadius.all(Radius.circular(sizeVerySmall))),
                  )
                ],
              ),
            )
          ],
        ),
        insetPadding: const EdgeInsets.only(
            bottom: sizeNormal, left: 0, top: sizeNormalxxx, right: 0),
        useDragDismiss: true,
        onDismiss: () => NavigateUtil.pop(context),
        key: const Key('experience_dialog'),
        positionDialog: PositionDialog.topCenter);
  }

  Widget renderAreaItem(BuildContext context, int index,
      List<dynamic> arrMenu) {
    final AreaItem item = arrMenu[index];
    return Material(
        color: Colors.white,
        child: InkWell(
          splashColor: Colors.blue.withAlpha(30),
          onTap: () {
            NavigateUtil.pop(context);
            onSelectArea(item);
          },
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: sizeNormalxxx),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: sizeSmallxx),
                  decoration: const BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                            color: Color(0xFFE0E0E0),
                            width: 1.0, // Underline thickness
                          ))),
                  child: Row(
                    children: <Widget>[
                      UIUtil.makeCircleImageWidget(item.icon,
                          size: sizeNormalx),
                      Container(
                        margin: const EdgeInsets.only(
                            left: sizeSmallxx,
                            top: sizeIcon,
                            right: sizeSmallxx),
                        child: Container(
                            padding: const EdgeInsets.only(
                              bottom:
                              sizeVerySmallx, // Space between underline and text
                            ),
                            decoration: (item.id == areaSelected.id)
                                ? const BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                      color: Colors.black,
                                      width: 2.0, // Underline thickness
                                    )))
                                : null,
                            child: MyTextView(
                                text: item.name,
                                textStyle: textNormalxx.copyWith(
                                    color: Colors.black,
                                    fontFamily: Fonts.Helvetica,
                                    fontWeight: FontWeight.bold))),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  Widget renderAreaSingleItem(BuildContext context, int index,
      List<dynamic> arrMenu) {
    final AreaItem item = arrMenu[index];
    final lastPosition = arrMenu.length - 1 == index;
    return Material(
        child: InkWell(
          splashColor: Colors.blue.withAlpha(30),
          onTap: () {
            NavigateUtil.pop(context);
            onSelectArea(item);
          },
          child: Container(
            color: const Color(0xff212237).withOpacity(0.05),
            padding: const EdgeInsets.symmetric(horizontal: sizeNormalxxx),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: sizeSmallxx),
              decoration: lastPosition
                  ? null
                  : const BoxDecoration(
                  border: Border(
                      bottom: BorderSide(
                        color: Color(0xFFE0E0E0),
                        width: 1.0, // Underline thickness
                      ))),
              child: Row(
                children: <Widget>[
                  UIUtil.makeCircleImageWidget(item.icon, size: sizeNormalx),
                  Expanded(
                    flex: 1,
                    child: Container(
                      alignment: UIUtil.getAlignment(context),
                      margin: const EdgeInsets.only(
                          left: sizeSmallxx, top: sizeIcon, right: sizeSmallxx),
                      child: MyTextView(
                          text: item.name,
                          textStyle: textNormalxx.copyWith(
                              color: Colors.black,
                              fontFamily: Fonts.Helvetica,
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
                  Container(
                    child: Icon(
                      UIUtil.getCircleIconNext(context),
                      color: Colors.black,
                      size: sizeNormalxx,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }

}
