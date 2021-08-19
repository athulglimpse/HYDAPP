import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:marvista/data/source/api_end_point.dart';
import 'package:marvista/utils/ui_util.dart';
import '../../theme/theme.dart';

import 'my_date_picker_header.dart';

/// Initial display mode of the date picker dialog.
///
/// Date picker UI mode for either showing a list of available years or a
/// monthly calendar initially in the dialog shown by calling [showDatePicker].
enum MyDatePickerMode {
  /// Show a date picker UI for choosing a month and day.
  day,

  /// Show a date picker UI for choosing a year.
  year,
}

const Duration _kMonthScrollDuration = Duration(milliseconds: 200);
const double _kDayPickerRowHeight = 38.0;
const int _kMaxDayPickerRowCount = 5; // A 31 day month that starts on Saturday.
// Two extra rows: one for the day-of-week header and one for the month header.
const double _kMaxDayPickerHeight =
    _kDayPickerRowHeight * (_kMaxDayPickerRowCount + 1);

// const double _kMonthPickerPortraitWidth = 410;
const double _kMonthPickerLandscapeWidth = 344.0;

const double _kDialogActionBarHeight = 52.0;
const double _kDatePickerLandscapeHeight =
    _kMaxDayPickerHeight + _kDialogActionBarHeight;

class _DayPickerGridDelegate extends SliverGridDelegate {
  const _DayPickerGridDelegate();

  @override
  SliverGridLayout getLayout(SliverConstraints constraints) {
    const columnCount = DateTime.daysPerWeek;
    final tileWidth = constraints.crossAxisExtent / columnCount;
    final tileHeight = math.min(_kDayPickerRowHeight,
        constraints.viewportMainAxisExtent / (_kMaxDayPickerRowCount + 1));
    return SliverGridRegularTileLayout(
      crossAxisCount: columnCount,
      mainAxisStride: tileHeight,
      crossAxisStride: tileWidth,
      childMainAxisExtent: tileHeight,
      childCrossAxisExtent: tileWidth,
      reverseCrossAxis: axisDirectionIsReversed(constraints.crossAxisDirection),
    );
  }

  @override
  bool shouldRelayout(_DayPickerGridDelegate oldDelegate) => false;
}

const _DayPickerGridDelegate _kDayPickerGridDelegate = _DayPickerGridDelegate();

/// Displays the days of a given month and allows choosing a day.
///
/// The days are arranged in a rectangular grid with one column for each day of
/// the week.
///
/// The day picker widget is rarely used directly. Instead, consider using
/// [showDatePicker], which creates a date picker dialog.
///
/// See also:
///
///  * [showDatePicker].
///  * <https://material.google.com/components/pickers.html#pickers-date-pickers>
class DayPicker extends StatelessWidget {
  /// Creates a day picker.
  ///
  /// Rarely used directly. Instead, typically used as part of a [MonthPicker].
  DayPicker({
    Key key,
    @required this.selectedFirstDate,
    this.selectedLastDate,
    @required this.currentDate,
    @required this.onChanged,
    @required this.firstDate,
    @required this.lastDate,
    @required this.displayedMonth,
    this.selectableDayPredicate,
    this.disableDate,
  })  : assert(selectedFirstDate != null, 'selectedFirstDate must not be null'),
        assert(currentDate != null, 'currentDate must not be null'),
        assert(onChanged != null, 'onChanged must not be null'),
        assert(displayedMonth != null, 'displayedMonth must not be null'),
        assert(!firstDate.isAfter(lastDate), 'lastDate must not be null'),
        assert(
            !selectedFirstDate.isBefore(firstDate) &&
                (selectedLastDate == null ||
                    !selectedLastDate.isAfter(lastDate)),
            'check date validate'),
        assert(
            selectedLastDate == null ||
                !selectedLastDate.isBefore(selectedFirstDate),
            'selectedFirstDate must not be null'),
        super(key: key);

  /// The currently selected date.
  ///
  /// This date is highlighted in the picker.
  final DateTime selectedFirstDate;
  final DateTime selectedLastDate;

  /// The current date at the time the picker is displayed.
  final DateTime currentDate;

  /// disable calender
  final bool disableDate;

  /// Called when the user picks a day.
  final ValueChanged<List<DateTime>> onChanged;

  /// The earliest date the user is permitted to pick.
  final DateTime firstDate;

  /// The latest date the user is permitted to pick.
  final DateTime lastDate;

  /// The month whose days are displayed by this picker.
  final DateTime displayedMonth;

  /// Optional user supplied predicate function to customize selectable days.
  final SelectableDayPredicate selectableDayPredicate;

  /// Builds widgets showing abbreviated days of week. The first widget in the
  /// returned list corresponds to the first day of week for the current locale.
  ///
  /// Examples:
  ///
  /// ```
  /// ┌ Sunday is the first day of week in the US (en_US)
  /// |
  /// S M T W T F S  <-- the returned list contains these widgets
  /// _ _ _ _ _ 1 2
  /// 3 4 5 6 7 8 9
  ///
  /// ┌ But it's Monday in the UK (en_GB)
  /// |
  /// M T W T F S S  <-- the returned list contains these widgets
  /// _ _ _ _ 1 2 3
  /// 4 5 6 7 8 9 10
  /// ```
  List<Widget> _getDayHeaders(
      TextStyle headerStyle, MaterialLocalizations localizations) {
    final result = <Widget>[];
    var breakFlag = true;
    for (var i = localizations.firstDayOfWeekIndex;
        breakFlag;
        i = (i + 1) % 7) {
      final weekday = localizations.narrowWeekdays[i];
      result.add(ExcludeSemantics(
        child: Center(child: Text(weekday, style: headerStyle)),
      ));
      if (i == (localizations.firstDayOfWeekIndex - 1) % 7) {
        breakFlag = false;
        break;
      }
    }
    return result;
  }

  // Do not use this directly - call getDaysInMonth instead.
  static const List<int> _daysInMonth = <int>[
    31,
    -1,
    31,
    30,
    31,
    30,
    31,
    31,
    30,
    31,
    30,
    31
  ];

  /// Returns the number of days in a month, according to the proleptic
  /// Gregorian calendar.
  ///
  /// This applies the leap year logic introduced by the Gregorian reforms of
  /// 1582. It will not give valid results for dates prior to that time.
  static int getDaysInMonth(int year, int month) {
    if (month == DateTime.february) {
      final isLeapYear =
          (year % 4 == 0) && (year % 100 != 0) || (year % 400 == 0);
      if (isLeapYear) {
        return 29;
      }
      return 28;
    }
    return _daysInMonth[month - 1];
  }

  /// Computes the offset from the first day of week that the first day of the
  /// [month] falls on.
  ///
  /// For example, September 1, 2017 falls on a Friday, which in the calendar
  /// localized for United States English appears as:
  ///
  /// ```
  /// S M T W T F S
  /// _ _ _ _ _ 1 2
  /// ```
  ///
  /// The offset for the first day of the months is the number of leading blanks
  /// in the calendar, i.e. 5.
  ///
  /// The same date localized for the Russian calendar has a different offset,
  /// because the first day of week is Monday rather than Sunday:
  ///
  /// ```
  /// M T W T F S S
  /// _ _ _ _ 1 2 3
  /// ```
  ///
  /// So the offset is 4, rather than 5.
  ///
  /// This code consolidates the following:
  ///
  /// - [DateTime.weekday] provides a 1-based index into days of week, with 1
  ///   falling on Monday.
  /// - [MaterialLocalizations.firstDayOfWeekIndex] provides a 0-based index
  ///   into the [MaterialLocalizations.narrowWeekdays] list.
  /// - [MaterialLocalizations.narrowWeekdays] list provides localized names of
  ///   days of week, always starting with Sunday and ending with Saturday.
  int _computeFirstDayOffset(
      int year, int month, MaterialLocalizations localizations) {
    // 0-based day of week, with 0 representing Monday.
    final weekdayFromMonday = DateTime(year, month).weekday - 1;
    // 0-based day of week, with 0 representing Sunday.
    final firstDayOfWeekFromSunday = localizations.firstDayOfWeekIndex;
    // firstDayOfWeekFromSunday recomputed to be Monday-based
    final firstDayOfWeekFromMonday = (firstDayOfWeekFromSunday - 1) % 7;
    // Number of days between the first day of week appearing on the calendar,
    // and the day corresponding to the 1-st of the month.
    return (weekdayFromMonday - firstDayOfWeekFromMonday) % 7;
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final localizations = MaterialLocalizations.of(context);
    final year = displayedMonth.year;
    final month = displayedMonth.month;

    final daysInMonth = getDaysInMonth(year, month);
    final firstDayOffset = _computeFirstDayOffset(year, month, localizations);
    final labels = <Widget>[];
//    labels.addAll(_getDayHeaders(themeData.textTheme.caption, localizations));
    var canBreak = true;
    for (var i = 0; canBreak; i += 1) {
      // 1-based day of month, e.g. 1-31 for January, and 1-29 for February on
      // a leap year.
      final day = i - firstDayOffset + 1;
      if (day > daysInMonth) {
        canBreak = false;
        break;
      }
      if (day < 1) {
        labels.add(Container());
      } else {
        final dayToBuild = DateTime(year, month, day);
        final disabled = dayToBuild.isAfter(lastDate) ||
            dayToBuild.isBefore(firstDate) ||
            (selectableDayPredicate != null &&
                !selectableDayPredicate(dayToBuild));
        BoxDecoration decoration;
        var itemStyle = themeData.textTheme.bodyText2;
        final isSelectedFirstDay = selectedFirstDate.year == year &&
            selectedFirstDate.month == month &&
            selectedFirstDate.day == day;
        final isSelectedLastDay = selectedLastDate != null
            ? (selectedLastDate.year == year &&
                selectedLastDate.month == month &&
                selectedLastDate.day == day)
            : null;
        final isInRange = selectedLastDate != null
            ? (dayToBuild.isBefore(selectedLastDate) &&
                dayToBuild.isAfter(selectedFirstDate))
            : null;
        if (isSelectedFirstDay &&
            (isSelectedLastDay == null || isSelectedLastDay)) {
          itemStyle = themeData.accentTextTheme.bodyText1;
          decoration = const BoxDecoration(
              color: Color(0xff419C9B), shape: BoxShape.circle);
        } else if (isSelectedFirstDay) {
          /// The selected day gets a circle background highlight,
          /// and a contrasting text color.
          itemStyle = themeData.accentTextTheme.bodyText1;
          decoration = UIUtil.getFirstDayBoxDecorationByLang(context);
        } else if (isSelectedLastDay != null && isSelectedLastDay) {
          itemStyle = themeData.accentTextTheme.bodyText1;
          decoration = UIUtil.getLastDayBoxDecorationByLang(context);
        } else if (isInRange != null && isInRange) {
          decoration = BoxDecoration(
              color: const Color(0xff419C9B).withOpacity(0.1),
              shape: BoxShape.rectangle);
        } else if (disabled) {
          itemStyle = themeData.textTheme.bodyText2
              .copyWith(color: themeData.disabledColor);
        } else if (currentDate.year == year &&
            currentDate.month == month &&
            currentDate.day == day) {
          // The current day gets a different text color.
          itemStyle = themeData.textTheme.bodyText1
              .copyWith(color: const Color(0xff419C9B));
        }

        Widget dayWidget = Container(
          decoration: decoration,
          child: Center(
            child: Semantics(
              // We want the day of month to be spoken first irrespective of the
              // locale-specific preferences or TextDirection. This is because
              // an accessibility user is more likely to be interested in the
              // day of month before the rest of the date, as they are looking
              // for the day of month. To do that we prepend day of month to the
              // formatted full date.
              label: '${localizations.formatDecimal(day)}, '
                  '${localizations.formatFullDate(dayToBuild)}',
              selected: isSelectedFirstDay ||
                  isSelectedLastDay != null && isSelectedLastDay,
              child: ExcludeSemantics(
                child: Text(localizations.formatDecimal(day), style: itemStyle),
              ),
            ),
          ),
        );

        if (!disabled) {
          dayWidget = GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              if (disableDate) {
                return;
              }
              DateTime first, last;
              if (selectedLastDate != null) {
                first = dayToBuild;
                last = null;
              } else {
                if (dayToBuild.compareTo(selectedFirstDate) <= 0) {
                  first = dayToBuild;
                  last = selectedFirstDate;
                } else {
                  first = selectedFirstDate;
                  last = dayToBuild;
                }
              }
              onChanged([first, last]);
            },
            child: dayWidget,
          );
        }

        labels.add(dayWidget);
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Wrap(
          alignment: WrapAlignment.start,
          children: [
            Container(
              alignment: Alignment.centerLeft,
              height: _kDayPickerRowHeight,
              child: Text(
                localizations.formatMonthYear(displayedMonth),
                textAlign: TextAlign.start,
                style: themeData.textTheme.subtitle1,
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: _getDayHeaders(themeData.textTheme.caption, localizations)
              .map((e) => SizedBox(
                    width: _kDayPickerRowHeight,
                    height: _kDayPickerRowHeight,
                    child: e,
                  ))
              .toList(),
        ),
        Divider(
          color: const Color(0xff212237).withOpacity(0.1),
          height: 2,
        ),
        Flexible(
          child: GridView.custom(
            shrinkWrap: true,
            padding: const EdgeInsets.all(0),
            gridDelegate: _kDayPickerGridDelegate,
            childrenDelegate:
                SliverChildListDelegate(labels, addRepaintBoundaries: false),
          ),
        ),
      ],
    );
  }
}

/// A scrollable list of months to allow picking a month.
///
/// Shows the days of each month in a rectangular grid with one column for each
/// day of the week.
///
/// The month picker widget is rarely used directly. Instead, consider using
/// [showDatePicker], which creates a date picker dialog.
///
/// See also:
///
///  * [showDatePicker]
///  * <https://material.google.com/components/pickers.html#pickers-date-pickers>
class MonthPicker extends StatefulWidget {
  /// Creates a month picker.
  ///
  /// Rarely used directly. Instead, typically used as part of the dialog shown
  /// by [showDatePicker].
  MonthPicker({
    Key key,
    @required this.selectedFirstDate,
    this.selectedLastDate,
    @required this.onChanged,
    @required this.firstDate,
    @required this.lastDate,
    this.selectableDayPredicate,
    this.disableDate,
  })  : assert(selectedFirstDate != null, ''),
        assert(onChanged != null, ''),
        assert(!firstDate.isAfter(lastDate), ''),
        assert(
            !selectedFirstDate.isBefore(firstDate) &&
                (selectedLastDate == null ||
                    !selectedLastDate.isAfter(lastDate)),
            ''),
        assert(
            selectedLastDate == null ||
                !selectedLastDate.isBefore(selectedFirstDate),
            ''),
        super(key: key);

  /// The currently selected date.
  ///
  /// This date is highlighted in the picker.
  final DateTime selectedFirstDate;
  final DateTime selectedLastDate;

  /// Called when the user picks a month.
  final ValueChanged<List<DateTime>> onChanged;

  /// The earliest date the user is permitted to pick.
  final DateTime firstDate;

  ///Disable calendar
  final bool disableDate;

  /// The latest date the user is permitted to pick.
  final DateTime lastDate;

  /// Optional user supplied predicate function to customize selectable days.
  final SelectableDayPredicate selectableDayPredicate;

  @override
  _MonthPickerState createState() => _MonthPickerState();
}

class _MonthPickerState extends State<MonthPicker>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    // Initially display the pre-selected date.
    int monthPage;
    if (widget.selectedLastDate == null) {
      monthPage = _monthDelta(widget.firstDate, widget.selectedFirstDate);
    } else {
      monthPage = _monthDelta(widget.firstDate, widget.selectedLastDate);
    }
    _dayPickerController = PageController(initialPage: monthPage);
    _handleMonthPageChanged(monthPage);
    _updateCurrentDate();

    // Setup the fade animation for chevrons
    _chevronOpacityController = AnimationController(
        duration: const Duration(milliseconds: 250), vsync: this);
    _chevronOpacityAnimation =
        Tween<double>(begin: 1.0, end: 0.0).animate(CurvedAnimation(
      parent: _chevronOpacityController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void didUpdateWidget(MonthPicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedLastDate == null) {
      final monthPage = _monthDelta(widget.firstDate, widget.selectedFirstDate);
      _dayPickerController = PageController(initialPage: monthPage);
      _handleMonthPageChanged(monthPage);
    } else if (oldWidget.selectedLastDate == null ||
        widget.selectedLastDate != oldWidget.selectedLastDate) {
      final monthPage = _monthDelta(widget.firstDate, widget.selectedLastDate);
      _dayPickerController = PageController(initialPage: monthPage);
      _handleMonthPageChanged(monthPage);
    }
  }

  MaterialLocalizations localizations;
  TextDirection textDirection;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    localizations = MaterialLocalizations.of(context);
    textDirection = Directionality.of(context);
  }

  DateTime _todayDate;
  DateTime _currentDisplayedMonthDate;
  Timer _timer;
  PageController _dayPickerController;
  AnimationController _chevronOpacityController;
  Animation<double> _chevronOpacityAnimation;

  void _updateCurrentDate() {
    _todayDate = DateTime.now();
    final tomorrow =
        DateTime(_todayDate.year, _todayDate.month, _todayDate.day + 1);
    var timeUntilTomorrow = tomorrow.difference(_todayDate);
    timeUntilTomorrow +=
        const Duration(seconds: 1); // so we don't miss it by rounding
    _timer?.cancel();
    _timer = Timer(timeUntilTomorrow, () {
      setState(_updateCurrentDate);
    });
  }

  static int _monthDelta(DateTime startDate, DateTime endDate) {
    return (endDate.year - startDate.year) * 12 +
        endDate.month -
        startDate.month;
  }

  /// Add months to a month truncated date.
  DateTime _addMonthsToMonthDate(DateTime monthDate, int monthsToAdd) {
    return DateTime(
        monthDate.year + monthsToAdd ~/ 12, monthDate.month + monthsToAdd % 12);
  }

  Widget _buildItems(BuildContext context, int index) {
    final month = _addMonthsToMonthDate(widget.firstDate, index);
    return DayPicker(
      key: ValueKey<DateTime>(month),
      disableDate: widget.disableDate,
      selectedFirstDate: widget.selectedFirstDate,
      selectedLastDate: widget.selectedLastDate,
      currentDate: _todayDate,
      onChanged: widget.onChanged,
      firstDate: widget.firstDate,
      lastDate: widget.lastDate,
      displayedMonth: month,
      selectableDayPredicate: widget.selectableDayPredicate,
    );
  }

  void _handleNextMonth() {
    if (!_isDisplayingLastMonth) {
      SemanticsService.announce(
          localizations.formatMonthYear(_nextMonthDate), textDirection);
      _dayPickerController.nextPage(
          duration: _kMonthScrollDuration, curve: Curves.ease);
    }
  }

  void _handlePreviousMonth() {
    if (!_isDisplayingFirstMonth) {
      SemanticsService.announce(
          localizations.formatMonthYear(_previousMonthDate), textDirection);
      _dayPickerController.previousPage(
          duration: _kMonthScrollDuration, curve: Curves.ease);
    }
  }

  /// True if the earliest allowable month is displayed.
  bool get _isDisplayingFirstMonth {
    return !_currentDisplayedMonthDate
        .isAfter(DateTime(widget.firstDate.year, widget.firstDate.month));
  }

  /// True if the latest allowable month is displayed.
  bool get _isDisplayingLastMonth {
    return !_currentDisplayedMonthDate
        .isBefore(DateTime(widget.lastDate.year, widget.lastDate.month));
  }

  DateTime _previousMonthDate;
  DateTime _nextMonthDate;

  void _handleMonthPageChanged(int monthPage) {
    setState(() {
      _previousMonthDate =
          _addMonthsToMonthDate(widget.firstDate, monthPage - 1);
      _currentDisplayedMonthDate =
          _addMonthsToMonthDate(widget.firstDate, monthPage);
      _nextMonthDate = _addMonthsToMonthDate(widget.firstDate, monthPage + 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width - sizeSmall;
    return SizedBox(
      width: width,
      height: _kMaxDayPickerHeight,
      child: Stack(
        children: <Widget>[
          Semantics(
            sortKey: _MonthPickerSortKey.calendar,
            child: NotificationListener<ScrollStartNotification>(
              onNotification: (_) {
                _chevronOpacityController.forward();
                return false;
              },
              child: NotificationListener<ScrollEndNotification>(
                onNotification: (_) {
                  _chevronOpacityController.reverse();
                  return false;
                },
                child: PageView.builder(
                  key: ValueKey<DateTime>(widget.selectedFirstDate == null
                      ? widget.selectedFirstDate
                      : widget.selectedLastDate),
                  controller: _dayPickerController,
                  scrollDirection: Axis.horizontal,
                  itemCount: _monthDelta(widget.firstDate, widget.lastDate) + 1,
                  itemBuilder: _buildItems,
                  onPageChanged: _handleMonthPageChanged,
                ),
              ),
            ),
          ),
          Container(
            alignment: Alignment.topRight,
            margin: const EdgeInsets.only(right: sizeLarge),
            child: Semantics(
              sortKey: _MonthPickerSortKey.previousMonth,
              child: FadeTransition(
                opacity: _chevronOpacityAnimation,
                child: IconButton(
                  iconSize: sizeNormalxxx,
                  icon: const Icon(Icons.keyboard_arrow_left),
                  tooltip: _isDisplayingFirstMonth
                      ? null
                      : '${localizations.previousMonthTooltip} '
                  // ignore: lines_longer_than_80_chars
                      '${localizations.formatMonthYear(_previousMonthDate)}',
                  onPressed:
                  _isDisplayingFirstMonth ? null : _handlePreviousMonth,
                ),
              ),
            ),
          ),
          Container(
            alignment: Alignment.topRight,
            child: Semantics(
              sortKey: _MonthPickerSortKey.nextMonth,
              child: FadeTransition(
                opacity: _chevronOpacityAnimation,
                child: IconButton(
                  iconSize: sizeNormalxxx,
                  icon: const Icon(Icons.keyboard_arrow_right),
                  tooltip: _isDisplayingLastMonth
                      ? null
                      : '${localizations.nextMonthTooltip} '
                      '${localizations.formatMonthYear(_nextMonthDate)}',
                  onPressed: _isDisplayingLastMonth ? null : _handleNextMonth,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _dayPickerController?.dispose();
    super.dispose();
  }
}

// Defines semantic traversal order of the top-level widgets inside the month
// picker.
class _MonthPickerSortKey extends OrdinalSortKey {
  static const _MonthPickerSortKey previousMonth = _MonthPickerSortKey(1.0);
  static const _MonthPickerSortKey nextMonth = _MonthPickerSortKey(2.0);
  static const _MonthPickerSortKey calendar = _MonthPickerSortKey(3.0);

  const _MonthPickerSortKey(double order) : super(order);
}

/// A scrollable list of years to allow picking a year.
///
/// The year picker widget is rarely used directly. Instead, consider using
/// [showDatePicker], which creates a date picker dialog.
///
/// Requires one of its ancestors to be a [Material] widget.
///
/// See also:
///
///  * [showDatePicker]
///  * <https://material.google.com/components/pickers.html#pickers-date-pickers>
class YearPicker extends StatefulWidget {
  /// Creates a year picker.
  ///
  /// The [selectedDate] and [onChanged] arguments must not be null. The
  /// [lastDate] must be after the [firstDate].
  ///
  /// Rarely used directly. Instead, typically used as part of the dialog shown
  /// by [showDatePicker].
  YearPicker({
    Key key,
    @required this.selectedFirstDate,
    this.selectedLastDate,
    @required this.onChanged,
    @required this.firstDate,
    @required this.lastDate,
  })  : assert(selectedFirstDate != null, ''),
        assert(onChanged != null, ''),
        assert(!firstDate.isAfter(lastDate), ''),
        super(key: key);

  /// The currently selected date.
  ///
  /// This date is highlighted in the picker.
  final DateTime selectedFirstDate;
  final DateTime selectedLastDate;

  /// Called when the user picks a year.
  final ValueChanged<List<DateTime>> onChanged;

  /// The earliest date the user is permitted to pick.
  final DateTime firstDate;

  /// The latest date the user is permitted to pick.
  final DateTime lastDate;

  @override
  _YearPickerState createState() => _YearPickerState();
}

class _YearPickerState extends State<YearPicker> {
  static const double _itemExtent = 50.0;
  ScrollController scrollController;

  @override
  void initState() {
    super.initState();
    int offset;
    if (widget.selectedLastDate != null) {
      offset = widget.lastDate.year - widget.selectedLastDate.year;
    } else {
      offset = widget.selectedFirstDate.year - widget.firstDate.year;
    }
    scrollController = ScrollController(
      // Move the initial scroll position to the currently selected date's year.
      initialScrollOffset: offset * _itemExtent,
    );
  }

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMaterial(context), '');
    final themeData = Theme.of(context);
    final style = themeData.textTheme.bodyText2;
    return ListView.builder(
      controller: scrollController,
      itemExtent: _itemExtent,
      itemCount: widget.lastDate.year - widget.firstDate.year + 1,
      itemBuilder: (BuildContext context, int index) {
        final year = widget.firstDate.year + index;
        final isSelected = year == widget.selectedFirstDate.year ||
            (widget.selectedLastDate != null &&
                year == widget.selectedLastDate.year);
        final itemStyle = isSelected
            ? themeData.textTheme.headline5
                .copyWith(color: themeData.accentColor)
            : style;
        return InkWell(
          key: ValueKey<int>(year),
          onTap: () {
            List<DateTime> changes;
            if (widget.selectedLastDate == null) {
              final newDate = DateTime(year, widget.selectedFirstDate.month,
                  widget.selectedFirstDate.day);
              changes = [newDate, newDate];
            } else {
              changes = [
                DateTime(year, widget.selectedFirstDate.month,
                    widget.selectedFirstDate.day),
                null
              ];
            }
            widget.onChanged(changes);
          },
          child: Center(
            child: Semantics(
              selected: isSelected,
              child: Text(year.toString(), style: itemStyle),
            ),
          ),
        );
      },
    );
  }
}

class DatePickerDialogCustom extends StatefulWidget {
  const DatePickerDialogCustom({
    Key key,
    this.initialFirstDate,
    this.initialLastDate,
    this.firstDate,
    this.lastDate,
    this.selectableDayPredicate,
    this.initialDatePickerMode,
    this.onChangeDay,
    this.disableDate,
  }) : super(key: key);

  final DateTime initialFirstDate;
  final DateTime initialLastDate;
  final DateTime firstDate;
  final DateTime lastDate;
  final bool disableDate;
  final SelectableDayPredicate selectableDayPredicate;
  final MyDatePickerMode initialDatePickerMode;
  final Function onChangeDay;

  @override
  DatePickerDialogCustomState createState() => DatePickerDialogCustomState();
}

class DatePickerDialogCustomState extends State<DatePickerDialogCustom> {
  @override
  void initState() {
    super.initState();
    _selectedFirstDate = widget.initialFirstDate;
    _selectedLastDate = widget.initialLastDate;
    _mode = widget.initialDatePickerMode;
    _onChangeDay = widget.onChangeDay;
  }

  void updateStartEndDate(DateTime stateDate, DateTime endDate) {
    setState(() {
      _selectedFirstDate = stateDate;
      _selectedLastDate = endDate;
    });
  }

  bool _announcedInitialDate = false;

  MaterialLocalizations localizations;
  TextDirection textDirection;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    localizations = MaterialLocalizations.of(context);
    textDirection = Directionality.of(context);
    if (!_announcedInitialDate) {
      _announcedInitialDate = true;
      SemanticsService.announce(
        localizations.formatFullDate(_selectedFirstDate),
        textDirection,
      );
      if (_selectedLastDate != null) {
        SemanticsService.announce(
          localizations.formatFullDate(_selectedLastDate),
          textDirection,
        );
      }
    }
  }

  DateTime _selectedFirstDate;
  DateTime _selectedLastDate;
  MyDatePickerMode _mode;
  Function _onChangeDay;
  final GlobalKey _pickerKey = GlobalKey();

  void _vibrate() {
    switch (Theme.of(context).platform) {
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
        HapticFeedback.vibrate();
        break;
      case TargetPlatform.iOS:
        break;
      default:
    }
  }

  void handleModeChanged(MyDatePickerMode mode) {
    _vibrate();
    setState(() {
      _mode = mode;
      if (_mode == MyDatePickerMode.day) {
        SemanticsService.announce(
            localizations.formatMonthYear(_selectedFirstDate), textDirection);
        if (_selectedLastDate != null) {
          SemanticsService.announce(
              localizations.formatMonthYear(_selectedLastDate), textDirection);
        }
      } else {
        SemanticsService.announce(
            localizations.formatYear(_selectedFirstDate), textDirection);
        if (_selectedLastDate != null) {
          SemanticsService.announce(
              localizations.formatYear(_selectedLastDate), textDirection);
        }
      }
    });
  }

  void _handleYearChanged(List<DateTime> changes) {
    assert(changes != null && changes.length == 2, '');
    _vibrate();
    setState(() {
      _mode = MyDatePickerMode.day;
      _selectedFirstDate = changes[0];
      _selectedLastDate = changes[1];
    });
  }

  void _handleDayChanged(List<DateTime> changes) {
    assert(changes != null && changes.length == 2, '');
    _vibrate();
    setState(() {
      _selectedFirstDate = changes[0];
      _selectedLastDate = changes[1];
    });
    _onChangeDay(changes[0], changes[1] ?? changes[0]);
  }

  void handleOk() {
    final result = [];
    if (_selectedFirstDate != null) {
      result.add(_selectedFirstDate);
      if (_selectedLastDate != null) {
        result.add(_selectedLastDate);
      }
    }
    Navigator.pop(context, result);
  }

  Widget _buildPicker() {
    assert(_mode != null, '');
    switch (_mode) {
      case MyDatePickerMode.day:
        return MonthPicker(
          disableDate: widget.disableDate,
          key: _pickerKey,
          selectedFirstDate: _selectedFirstDate,
          selectedLastDate: _selectedLastDate,
          onChanged: _handleDayChanged,
          firstDate: widget.firstDate,
          lastDate: widget.lastDate,
          selectableDayPredicate: widget.selectableDayPredicate,
        );
      case MyDatePickerMode.year:
        return YearPicker(
          key: _pickerKey,
          selectedFirstDate: _selectedFirstDate,
          selectedLastDate: _selectedLastDate,
          onChanged: _handleYearChanged,
          firstDate: widget.firstDate,
          lastDate: widget.lastDate,
        );
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final Widget picker = Flexible(
      child: SizedBox(
        height: _kMaxDayPickerHeight,
        child: _buildPicker(),
      ),
    );
//    final Widget actions = ButtonBarTheme(
//      data: Theme.of(context).buttonBarTheme,
//      child: ButtonBar(
//        children: <Widget>[
//          FlatButton(
//            child: Text(localizations.cancelButtonLabel),
//            onPressed: _handleCancel,
//          ),
//          FlatButton(
//            child: Text(localizations.okButtonLabel),
//            onPressed: handleOk,
//          ),
//        ],
//      ),
//    );
    final dialog = Container(child: OrientationBuilder(
        builder: (BuildContext context, Orientation orientation) {
      assert(orientation != null, '');
      final Widget header = MyDatePickerHeader(
        selectedFirstDate: _selectedFirstDate,
        selectedLastDate: _selectedLastDate,
        mode: _mode,
        onModeChanged: handleModeChanged,
        orientation: orientation,
      );
      switch (orientation) {
        case Orientation.portrait:
          final width = MediaQuery.of(context).size.width - sizeSmall;
          return SizedBox(
            width: width,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
//                header,
                Container(
                  color: theme.dialogBackgroundColor,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      picker,
//                      actions,
                    ],
                  ),
                ),
              ],
            ),
          );
        case Orientation.landscape:
          return SizedBox(
            height: _kDatePickerLandscapeHeight,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                header,
                Flexible(
                  child: Container(
                    width: _kMonthPickerLandscapeWidth,
                    color: theme.dialogBackgroundColor,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[picker],
                    ),
                  ),
                ),
              ],
            ),
          );
      }
      return null;
    }));

    return Theme(
      data: theme.copyWith(
        dialogBackgroundColor: Colors.transparent,
      ),
      child: widget.disableDate
          ? const SizedBox(
              height: sizeNormal,
            )
          : dialog,
    );
  }
}

/// Signature for predicating dates for enabled date selections.
///
/// See [showDatePicker].
typedef SelectableDayPredicate = bool Function(DateTime day);

/// Shows a dialog containing a material design date picker.
///
/// The returned [Future] resolves to the date selected by the user when the
/// user closes the dialog. If the user cancels the dialog, null is returned.
///
/// An optional [selectableDayPredicate] function can be passed in to customize
/// the days to enable for selection. If provided, only the days that
/// [selectableDayPredicate] returned true for will be selectable.
///
/// An optional [initialDatePickerMode] argument can be used to display the
/// date picker initially in the year or month+day picker mode. It defaults
/// to month+day, and must not be null.
///
/// An optional [locale] argument can be used to set the locale for the date
/// picker. It defaults to the ambient locale provided by [Localizations].
///
/// An optional [textDirection] argument can be used to set the text direction
/// (RTL or LTR) for the date picker. It defaults to the ambient text direction
/// provided by [Directionality]. If both [locale] and [textDirection] are not
/// null, [textDirection] overrides the direction chosen for the [locale].
///
/// The `context` argument is passed to [showDialog], the documentation for
/// which discusses how it is used.
///
/// See also:
///
///  * [showTimePicker]
///  * <https://material.google.com/components/pickers.html#pickers-date-pickers>
Future<List<DateTime>> showDatePicker({
  @required BuildContext context,
  @required DateTime initialFirstDate,
  @required DateTime initialLastDate,
  @required DateTime firstDate,
  @required DateTime lastDate,
  SelectableDayPredicate selectableDayPredicate,
  MyDatePickerMode initialDatePickerMode = MyDatePickerMode.day,
  Locale locale,
  TextDirection textDirection,
}) async {
  assert(!initialFirstDate.isBefore(firstDate),
      'initialDate must be on or after firstDate');
  assert(!initialLastDate.isAfter(lastDate),
      'initialDate must be on or before lastDate');
  assert(!initialFirstDate.isAfter(initialLastDate),
      'initialFirstDate must be on or before initialLastDate');
  assert(
      !firstDate.isAfter(lastDate), 'lastDate must be on or after firstDate');
  assert(
      selectableDayPredicate == null ||
          selectableDayPredicate(initialFirstDate) ||
          selectableDayPredicate(initialLastDate),
      'Provided initialDate must satisfy provided selectableDayPredicate');
  assert(
      initialDatePickerMode != null, 'initialDatePickerMode must not be null');

  Widget child = DatePickerDialogCustom(
    initialFirstDate: initialFirstDate,
    initialLastDate: initialLastDate,
    firstDate: firstDate,
    lastDate: lastDate,
    selectableDayPredicate: selectableDayPredicate,
    initialDatePickerMode: initialDatePickerMode,
  );

  if (textDirection != null) {
    child = Directionality(
      textDirection: textDirection,
      child: child,
    );
  }

  if (locale != null) {
    child = Localizations.override(
      context: context,
      locale: locale,
      child: child,
    );
  }

  return showDialog<List<DateTime>>(
    context: context,
    builder: (BuildContext context) => child,
  );
}
