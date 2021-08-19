import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../data/model/filter_date_model.dart';
import '../../utils/navigate_util.dart';
import '../localization/lang.dart';
import '../theme/theme.dart';
import '../widget/my_button.dart';
import '../widget/my_date_range_picker/my_date_range_picker.dart';
import '../widget/my_text_view.dart';
import 'normal_dialog_template.dart';

class EventDatePickerDialog extends StatefulWidget {
  final List<FilterDateModel> filterDates;
  final FilterDateModel currentFilterDate;
  final DateTime startDate;
  final DateTime endDate;

  const EventDatePickerDialog({
    Key key,
    this.filterDates,
    this.currentFilterDate,
    this.startDate,
    this.endDate,
  }) : super(key: key);

  @override
  EventDatePickerDialogState createState() => EventDatePickerDialogState();
}

class EventDatePickerDialogState extends State<EventDatePickerDialog> {
  static const String filterDateTypeKey = 'filter_type';
  static const String filterStartDateKey = 'start_date';
  static const String filterEndDateKey = 'end_date';

  GlobalKey<DatePickerDialogCustomState> dateState = GlobalKey();
  List<FilterDateModel> filterDates;
  FilterDateModel currentFilterDate;
  DateTime startDate;
  DateTime endDate;
  bool disableDate = true;

  @override
  void initState() {
    filterDates = widget.filterDates;
    currentFilterDate = widget.currentFilterDate;
    super.initState();

    startDate = widget.startDate ?? DateTime.now();
    endDate = widget.endDate ?? DateTime.now();
  }

  void onSelectDateFilter(FilterDateModel item) {
    switch (item.type) {
      case FilterDateType.SOONEST:
        startDate = DateTime.now();
        endDate = DateTime.now();
        disableDate = true;
        break;
      case FilterDateType.TODAY:
        startDate = DateTime.now();
        endDate = DateTime.now();
        disableDate = false;
        break;
      case FilterDateType.THIS_MONTH:
        startDate = DateTime(DateTime.now().year, DateTime.now().month, 1);
        endDate = DateTime(DateTime.now().year, DateTime.now().month + 1, 0);
        disableDate = false;
        break;
      case FilterDateType.THIS_WEEK:
        startDate =
            DateTime.now().subtract(Duration(days: DateTime.now().weekday - 1));
        endDate = DateTime.now()
            .add(Duration(days: DateTime.daysPerWeek - DateTime.now().weekday));
        disableDate = false;
        break;
    }
    dateState.currentState.updateStartEndDate(startDate, endDate);
    setState(() {
      currentFilterDate = item;
    });
  }

  @override
  Widget build(BuildContext context) {
    return NormalDialogTemplate.makeTemplate(
        Row(
          children: [
            Expanded(
              flex: 1,
              child: Material(
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      child: MyTextView(
                        text: Lang.event_choose_dates.tr(),
                        textStyle: textSmallxxx.copyWith(
                            fontFamily: MyFontFamily.graphik,
                            fontWeight: MyFontWeight.semiBold),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: sizeSmall),
                      height: sizeNormalxxx,
                      child: ListView.builder(
                          itemCount: filterDates.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (e, index) {
                            final item = filterDates[index];
                            return GestureDetector(
                              onTap: () => onSelectDateFilter(item),
                              child: Container(
                                alignment: Alignment.center,
                                padding: const EdgeInsets.symmetric(
                                    vertical: sizeVerySmallx,
                                    horizontal: sizeSmallxxx),
                                margin: const EdgeInsets.only(right: sizeSmall),
                                decoration: BoxDecoration(
                                    border: item != currentFilterDate
                                        ? Border.all(color: Colors.grey)
                                        : null,
                                    color: item == currentFilterDate
                                        ? const Color(0xff419C9B)
                                        : Colors.transparent,
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(sizeVerySmall))),
                                child: MyTextView(
                                  textAlign: TextAlign.center,
                                  text: item.name,
                                  textStyle: textSmallxx.copyWith(
                                      color: item == currentFilterDate
                                          ? Colors.white
                                          : const Color(0xff419C9B)),
                                ),
                              ),
                            );
                          }),
                    ),
                    DatePickerDialogCustom(
                      key: dateState,
                      disableDate: disableDate,
                      initialFirstDate: startDate,
                      initialLastDate: endDate,
                      onChangeDay: onChangeDay,
                      firstDate:
                          DateTime.now().add(const Duration(days: -1000)),
                      lastDate: DateTime.now().add(const Duration(days: 1000)),
                      initialDatePickerMode: MyDatePickerMode.day,
                    ),
                    MyButton(
                      text: Lang.event_apply_dates.tr(),
                      onTap: () {
                        NavigateUtil.pop(context, argument: {
                          filterDateTypeKey: currentFilterDate,
                          filterStartDateKey: startDate,
                          filterEndDateKey: endDate
                        });
                      },
                      paddingHorizontal: sizeLargexxx,
                      textStyle: textSmallxxx.copyWith(
                          color: Colors.white, fontWeight: FontWeight.bold),
                      buttonColor: const Color(0xff242655),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: sizeNormalxx),
                      width: sizeNormalxxx,
                      height: 4,
                      decoration: const BoxDecoration(
                          color: Color(0x21212237),
                          borderRadius:
                              BorderRadius.all(Radius.circular(sizeVerySmall))),
                    ),
                    const SizedBox(height: sizeSmallxxx)
                  ],
                ),
              ),
            )
          ],
        ),
        insetPadding: const EdgeInsets.only(
            bottom: 0, left: sizeNormal, top: sizeLarge, right: sizeNormal),
        useDragDismiss: true,
        onDismiss: () => NavigateUtil.pop(context),
        key: const Key('EventDatePickerDialogState'),
        positionDialog: PositionDialog.topCenter);
  }

  void onChangeDay(DateTime selectedFirstDate, DateTime selectedLastDate) {
    startDate = selectedFirstDate;
    endDate = selectedLastDate;
  }
}
