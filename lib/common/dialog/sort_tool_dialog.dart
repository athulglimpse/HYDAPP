import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../utils/navigate_util.dart';
import '../localization/lang.dart';
import '../theme/theme.dart';
import '../widget/my_button.dart';
import '../widget/my_text_view.dart';
import 'normal_dialog_template.dart';

class SortToolDialog extends StatefulWidget {
  final SortType currentValue;
  final bool hasSoonest;
  SortToolDialog({Key key, this.currentValue, this.hasSoonest = false})
      : super(key: key);
  @override
  _SortToolDialogState createState() => _SortToolDialogState();
}

class _SortToolDialogState extends State<SortToolDialog> {
  SortType currentValue = SortType.ASC;

  @override
  void initState() {
    super.initState();
    currentValue = widget.currentValue;
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
            top: sizeSmall,
            bottom: sizeNormal),
        useDragDismiss: true,
        onDismiss: () => NavigateUtil.pop(context),
        key: const Key('SortToolDialog'),
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
            text: Lang.home_sort_by.tr(),
            textStyle: textSmallxxx.copyWith(
              fontWeight: MyFontWeight.medium,
            ),
          ),
          const SizedBox(
            height: sizeSmall,
          ),
          Row(
            children: [
              Radio(
                value: SortType.ASC,
                groupValue: currentValue,
                activeColor: const Color(0xffFBBC43),
                focusColor: const Color(0xffFBBC43),
                onChanged: (SortType value) {
                  setState(() {
                    currentValue = value;
                  });
                },
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    currentValue = SortType.ASC;
                  });
                },
                child: MyTextView(
                  text: Lang.home_ascending_a_z.tr(),
                  textAlign: TextAlign.start,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Radio(
                value: SortType.DESC,
                activeColor: const Color(0xffFBBC43),
                hoverColor: const Color(0xffFBBC43),
                focusColor: const Color(0xffFBBC43),
                groupValue: currentValue,
                onChanged: (SortType value) {
                  setState(() {
                    currentValue = value;
                  });
                },
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    currentValue = SortType.DESC;
                  });
                },
                child: MyTextView(
                  text: Lang.home_descending_z_a.tr(),
                  textAlign: TextAlign.start,
                ),
              ),
            ],
          ),
          if (widget.hasSoonest)
            Row(
              children: [
                Radio(
                  value: SortType.SOONEST,
                  activeColor: const Color(0xffFBBC43),
                  hoverColor: const Color(0xffFBBC43),
                  focusColor: const Color(0xffFBBC43),
                  groupValue: currentValue,
                  onChanged: (SortType value) {
                    setState(() {
                      currentValue = value;
                    });
                  },
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      currentValue = SortType.SOONEST;
                    });
                  },
                  child: MyTextView(
                    text: Lang.event_soonest.tr(),
                    textAlign: TextAlign.start,
                  ),
                ),
              ],
            ),
          const SizedBox(
            height: sizeLarge,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MyButton(
                text: Lang.home_apply_filter.tr(),
                onTap: () {
                  NavigateUtil.pop(context,
                      argument: {'sort_type': currentValue});
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
}

enum SortType { ASC, DESC, SOONEST }
