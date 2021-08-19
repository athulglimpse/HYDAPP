import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:marvista/utils/date_util.dart';

import '../../../common/localization/lang.dart';
import '../../../common/theme/theme.dart';
import '../../../common/widget/my_text_view.dart';
import '../../../data/model/area_item.dart';
import '../../../utils/ui_util.dart';

class RangeDateView extends StatelessWidget {
  final FilterArea itemFilter;
  final Function(FilterArea, DateTime) onSelectStartDate;
  final Function(FilterArea, DateTime) onSelectEndDate;
  final Function(FilterArea) onClearSelection;
  final DateTime startDate;
  final DateTime endDate;

  const RangeDateView({
    Key key,
    this.itemFilter,
    this.onSelectStartDate,
    this.onSelectEndDate,
    this.startDate,
    this.endDate,
    this.onClearSelection,
  }) : super(key: key);

  Future<void> _selectStartDate(BuildContext context, DateTime date) async {
    final picked = await showDatePicker(
        context: context,
        initialDate: date,
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(const Duration(days: 700)));
    if (picked != null && picked != date) {
      onSelectStartDate(itemFilter, picked);
    }
  }

  Future<void> _selectEndDate(BuildContext context, DateTime date) async {
    final picked = await showDatePicker(
        context: context,
        initialDate: date,
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(const Duration(days: 700)));
    if (picked != null && picked != date) {
      onSelectEndDate(itemFilter, picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: sizeSmallxx),
              child: MyTextView(
                  textStyle: textSmallxxx.copyWith(
                      color: Colors.black, fontWeight: FontWeight.bold),
                  text: itemFilter?.name ?? ''),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: sizeSmallxx),
              child: MyTextView(
                onTap: () {
                  onClearSelection(itemFilter);
                },
                textStyle: textSmallx.copyWith(
                    color: const Color(0xff419c9b),
                    fontWeight: FontWeight.bold),
                text: Lang.home_clear.tr(),
              ),
            ),
          ],
        ),
        const SizedBox(height: sizeNormal),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            GestureDetector(
              onTap: () {
                _selectStartDate(context, startDate ?? DateTime.now());
              },
              child: Container(
                padding: const EdgeInsets.all(sizeSmallxx),
                decoration: BoxDecoration(
                  border: Border.all(width: 1.0, color: Colors.grey),
                  borderRadius: const BorderRadius.all(Radius.circular(
                          sizeSmall) //                 <--- border radius here
                      ),
                ),
                child: Row(
                  children: [
                    Text(
                      startDate != null
                          ? DateUtil.dateFormatYYYYMMdd(startDate,
                              format: DateUtil.DATE_FORMAT_DDMMYYYY)
                          : Lang.home_start_date.tr(),
                      style: textSmallxx,
                    ),
                    const SizedBox(
                      width: sizeNormal,
                    ),
                    const Icon(
                      Icons.keyboard_arrow_down_sharp,
                      size: sizeNormal,
                      color: Colors.grey,
                    )
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                _selectEndDate(context, endDate ?? DateTime.now());
              },
              child: Container(
                padding: const EdgeInsets.all(sizeSmallxx),
                decoration: BoxDecoration(
                  border: Border.all(width: 1.0, color: Colors.grey),
                  borderRadius: const BorderRadius.all(Radius.circular(
                          sizeSmall) //                 <--- border radius here
                      ),
                ),
                child: Row(
                  children: [
                    Text(
                      endDate != null
                          ? DateUtil.dateFormatYYYYMMdd(endDate,
                              format: DateUtil.DATE_FORMAT_DDMMYYYY)
                          : Lang.home_end_date.tr(),
                      style: textSmallxx,
                    ),
                    const SizedBox(
                      width: sizeNormal,
                    ),
                    const Icon(
                      Icons.keyboard_arrow_down_sharp,
                      size: sizeNormal,
                      color: Colors.grey,
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ],
    );
  }
}
