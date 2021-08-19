import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../data/model/area_item.dart';
import '../../utils/navigate_util.dart';
import '../localization/lang.dart';
import '../theme/theme.dart';
import '../widget/my_button.dart';
import '../widget/my_text_view.dart';
import 'normal_dialog_template.dart';

class FilterToolDialog extends StatefulWidget {
  final FilterArea filterArea;
  FilterToolDialog({
    Key key,
    this.filterArea,
  }) : super(key: key);
  @override
  _FilterToolDialogState createState() => _FilterToolDialogState();
}

class _FilterToolDialogState extends State<FilterToolDialog> {
  Map<int, bool> values = <int, bool>{};
  @override
  void initState() {
    super.initState();
    values = widget?.filterArea?.filterItem
            ?.asMap()
            ?.map((key, value) => MapEntry(value.id, value.selected)) ??
        {};
  }

  @override
  Widget build(BuildContext context) {
    return NormalDialogTemplate.makeTemplate(
        SafeArea(
          child: Material(
            color: Colors.white,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 1,
                  child: contentSort(),
                )
              ],
            ),
          ),
        ),
        insetPadding: const EdgeInsets.only(
          left: sizeNormalxxx,
          right: sizeNormalxxx,
          bottom: sizeNormal,
          top: sizeSmall,
        ),
        useDragDismiss: true,
        onDismiss: () => NavigateUtil.pop(context),
        key: const Key('FilterToolDialog'),
        positionDialog: PositionDialog.topCenter);
  }

  Widget contentSort() {
    return Theme(
      data: ThemeData(
        // Define the default brightness and colors.
        unselectedWidgetColor: const Color(0x80FBBC43),
        disabledColor: const Color(0x80FBBC43),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          MyTextView(
            text: widget.filterArea?.name ?? '',
            textStyle: textSmallxxx.copyWith(
              fontWeight: MyFontWeight.medium,
            ),
          ),
          const SizedBox(
            height: sizeNormal,
          ),
          Container(
            constraints: const BoxConstraints(
              maxHeight: sizeImageLargex,
            ),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: widget.filterArea?.filterItem?.length ?? 0,
              itemBuilder: (BuildContext context, int index) {
                return renderItemGender(
                    context, widget.filterArea.filterItem[index]);
              },
            ),
          ),
          const SizedBox(
            height: sizeNormalxx,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MyButton(
                text: Lang.home_apply_filter.tr(),
                onTap: () {
                  NavigateUtil.pop(context, argument: {'data': values});
                },
                paddingHorizontal: sizeLargexxx,
                textStyle: textSmallxxx.copyWith(
                  color: Colors.white,
                ),
                buttonColor: const Color(0xff242655),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
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
          )
        ],
      ),
    );
  }

  Widget renderItemGender(BuildContext context, FilterItem item) {
    return Material(
        color: Colors.white,
        child: InkWell(
          splashColor: Colors.blue.withAlpha(30),
          onTap: () {
            setState(() {
              values[item.id] = !values[item.id];
            });
          },
          child: Container(
            margin: const EdgeInsets.symmetric(
                vertical: sizeSmall, horizontal: sizeSmall),
            decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: (values[item.id])
                    ? [
                        const BoxShadow(
                          color: Color(0xe6fbbc43),
                          spreadRadius: 2,
                          blurRadius: 3,
                          offset: Offset(0, 1), // changes position of shadow
                        ),
                      ]
                    : [],
                border: Border.all(
                    color: (values[item.id])
                        ? const Color(0xe6fbbc43)
                        : Colors.grey),
                borderRadius: const BorderRadius.all(
                  Radius.circular(sizeSmall),
                )),
            padding: const EdgeInsets.symmetric(
                horizontal: sizeSmallxxx, vertical: sizeSmallxxx),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                MyTextView(
                    text: item.name,
                    textStyle: textSmallxx.copyWith(color: Colors.black)),
                (values[item.id])
                    ? Icon(
                        Icons.check_circle,
                        color: Colors.green[900],
                        size: sizeSmallxxxx,
                      )
                    : const SizedBox()
              ],
            ),
          ),
        ));
  }
}
