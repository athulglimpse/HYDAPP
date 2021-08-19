import 'package:flutter/material.dart';

import 'my_date_header_button.dart';
import 'my_date_range_picker.dart';

const double _kDayPickerRowHeight = 42.0;
const int _kMaxDayPickerRowCount = 6; // A 31 day month that starts on Saturday.
// Two extra rows: one for the day-of-week header and one for the month header.
const double _kMaxDayPickerHeight =
    _kDayPickerRowHeight * (_kMaxDayPickerRowCount + 2);

const double _kMonthPickerPortraitWidth = 330.0;

const double _kDialogActionBarHeight = 52.0;
const double _kDatePickerLandscapeHeight =
    _kMaxDayPickerHeight + _kDialogActionBarHeight;

const double _kDatePickerHeaderPortraitHeight = 72.0;
const double _kDatePickerHeaderLandscapeWidth = 168.0;

class MyDatePickerHeader extends StatelessWidget {
  const MyDatePickerHeader({
    Key key,
    @required this.selectedFirstDate,
    this.selectedLastDate,
    @required this.mode,
    @required this.onModeChanged,
    @required this.orientation,
  })  : assert(selectedFirstDate != null, 'selectedFirstDate must not be null'),
        assert(mode != null, 'mode must not be null'),
        assert(orientation != null, 'orientation must not be null'),
        super(key: key);

  final DateTime selectedFirstDate;
  final DateTime selectedLastDate;
  final MyDatePickerMode mode;
  final ValueChanged<MyDatePickerMode> onModeChanged;
  final Orientation orientation;

  void _handleChangeMode(MyDatePickerMode value) {
    if (value != mode) {
      onModeChanged(value);
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = MaterialLocalizations.of(context);
    final themeData = Theme.of(context);
    final headerTextTheme = themeData.primaryTextTheme;
    Color dayColor;
    Color yearColor;
    switch (themeData.primaryColorBrightness) {
      case Brightness.light:
        dayColor =
            mode == MyDatePickerMode.day ? Colors.black87 : Colors.black54;
        yearColor =
            mode == MyDatePickerMode.year ? Colors.black87 : Colors.black54;
        break;
      case Brightness.dark:
        dayColor = mode == MyDatePickerMode.day ? Colors.white : Colors.white70;
        yearColor =
            mode == MyDatePickerMode.year ? Colors.white : Colors.white70;
        break;
    }
    final dayStyle =
        headerTextTheme.headline4.copyWith(color: dayColor, height: 1.4);
    final yearStyle =
        headerTextTheme.subtitle1.copyWith(color: yearColor, height: 1.4);

    Color backgroundColor;
    switch (themeData.brightness) {
      case Brightness.light:
        backgroundColor = themeData.primaryColor;
        break;
      case Brightness.dark:
        backgroundColor = themeData.backgroundColor;
        break;
    }

    double width;
    double height;
    EdgeInsets padding;
    switch (orientation) {
      case Orientation.portrait:
        width = _kMonthPickerPortraitWidth;
        height = _kDatePickerHeaderPortraitHeight;
        padding = const EdgeInsets.symmetric(horizontal: 8.0);
        break;
      case Orientation.landscape:
        height = _kDatePickerLandscapeHeight;
        width = _kDatePickerHeaderLandscapeWidth;
        padding = const EdgeInsets.all(8.0);
        break;
    }
    Widget renderYearButton(date) {
      return IgnorePointer(
        ignoring: mode != MyDatePickerMode.day,
        ignoringSemantics: false,
        child: MyDateHeaderButton(
          color: backgroundColor,
          onTap: Feedback.wrapForTap(
              () => _handleChangeMode(MyDatePickerMode.year), context),
          child: Semantics(
              selected: mode == MyDatePickerMode.year,
              child: Text(localizations.formatYear(date), style: yearStyle)),
        ),
      );
    }

    Widget renderDayButton(date) {
      return IgnorePointer(
        ignoring: mode == MyDatePickerMode.day,
        ignoringSemantics: false,
        child: MyDateHeaderButton(
          color: backgroundColor,
          onTap: Feedback.wrapForTap(
              () => _handleChangeMode(MyDatePickerMode.day), context),
          child: Semantics(
              selected: mode == MyDatePickerMode.day,
              child: Text(
                localizations.formatMediumDate(date),
                style: dayStyle,
                textScaleFactor: 0.5,
              )),
        ),
      );
    }

    final Widget startHeader = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        renderYearButton(selectedFirstDate),
        renderDayButton(selectedFirstDate),
      ],
    );
    final endHeader = selectedLastDate != null
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              renderYearButton(selectedLastDate),
              renderDayButton(selectedLastDate),
            ],
          )
        : Container();

    return Container(
      width: width,
      height: height,
      padding: padding,
      color: backgroundColor,
      child: orientation == Orientation.portrait
          ? Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [startHeader, endHeader],
            )
          : Column(
              children: [
                Container(
                  width: width,
                  child: startHeader,
                ),
                Container(
                  width: width,
                  child: endHeader,
                ),
              ],
            ),
    );
  }
}
