import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
import 'package:marvista/common/localization/lang.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:easy_localization/easy_localization.dart';

class DateUtil {
  static const DATE_FORMAT_DDMMYYYY = 'dd/MM/yyyy';
  static const DATE_FORMAT_DDMMMYYYY = 'dd MMM ,yyyy';
  static const DATE_FORMAT_MMM = 'MMM';
  static const DATE_FORMAT_HHMMA = 'hh:mm a';
  static const DATE_FORMAT_HHMMSS = 'HH:mm:ss';
  static const DATE_FORMAT_EMMDDYYY = 'EEEE, MMMM do, yyyy';
  static const DATE_FORMAT_DD = 'dd';
  static const FORMAT_DATE_TIME_CS = 'dd/MM/yyyy HH:mm:ss';
  static const FORMAT_DATE_TIME = 'dd MMM, yyyy - hh:mm:ss';

  static String dateFormatYYYYMMdd(DateTime date,
      {String format = "yyyy-MM-dd'T'HH:mm:ss.SSS"}) {
    final s = DateFormat(format, 'en-US');
    return s.format(date);
  }

  static DateTime convertStringToDate(String date,
      {String formatData = "yyyy-MM-dd'T'HH:mm:ss.SSS",
      String local = 'en-US'}) {
    final s = DateFormat(formatData, local);
    return s.parse(date);
  }

  static String dateFormatEEEEddMM(DateTime date, {String local}) {
    final s = DateFormat('EEEE dd MMM', local);
    return s.format(date);
  }

  static String dateFormatDDMMYYYY(DateTime date, {String locale}) {
    if (date == null) {
      return '';
    }
    if (locale != null) {
      final s = DateFormat(DATE_FORMAT_DDMMYYYY, locale);
      return s.format(date);
    } else {
      final s = DateFormat(DATE_FORMAT_DDMMYYYY);
      return s.format(date);
    }
  }

  static String convertStringToDateFormat(String date,
      {String formatData = "yyyy-MM-dd'T'HH:mm:ss.SSS",
      String formatValue = 'dd MMM ,yyyy',
      String local = 'en-US'}) {
    try {
      final dateTime = convertStringToDate(date, formatData: formatData);
      final s = DateFormat(formatValue, local);
      final time = s.format(dateTime);
      return time;
    } catch (ex) {
      return '';
    }
  }

  static String formatOpenNow(String time) {
    if (time?.isEmpty ?? true) {
      return '';
    }

    final dateTime = convertStringToDate(time, formatData: 'HH:mm:ss');
    final s = DateFormat('HH:mm');
    return s.format(dateTime);
  }

  static String convertStringToDateJiffyFormat(String date,
      {String formatData = DATE_FORMAT_DDMMYYYY,
      String formatValue = DATE_FORMAT_EMMDDYYY,
      String local = 'en-US'}) {
    final dateTime =
        convertStringToDate(date, formatData: formatData, local: 'en-US');

    return Jiffy([dateTime.year, dateTime.month, dateTime.day])
        .format(DATE_FORMAT_EMMDDYYY);
  }

  static String greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return Lang.home_morning.tr();
    }
    if (hour < 17) {
      return Lang.home_afternoon.tr();
    }
    return Lang.home_evening.tr();
  }

  static String convertTimeAgo(String timeStamp,
      {String formatData = FORMAT_DATE_TIME_CS, String locale = 'en'}) {
    final date = DateTime.fromMillisecondsSinceEpoch(
        int.parse(timeStamp) * 1000,
        isUtc: true);
    final formatValue = timeago.format(date,
        clock: DateTime.now().toUtc(), locale: locale + '_short');
    return formatValue;
  }

  static String convertDateTime(String timeStamp,
      {String formatData = FORMAT_DATE_TIME, String locale = 'en'}) {
    final date = DateTime.fromMillisecondsSinceEpoch(
            int.parse(timeStamp) * 1000,
            isUtc: true)
        .add(const Duration(hours: 4));
    final s = DateFormat(formatData, locale);
    return s.format(date);
  }

  static int positionSameMomentAs(List<dynamic> list) {
    final date1 = convertStringToDate(
        dateFormatDDMMYYYY(DateTime.now(), locale: 'en-US'),
        formatData: DateUtil.DATE_FORMAT_DDMMYYYY,
        local: 'en-US');
    for (var i = 0; i < list.length; ++i) {
      print(list[i].date);
      final date2 = convertStringToDate(list[i].date,
          formatData: DateUtil.DATE_FORMAT_DDMMYYYY);
      if (date1.isBefore(date2) || date1.isAtSameMomentAs(date2)) {
        return i;
      }
    }
    return 0;
  }

  static bool isValidDOB(DateTime dob) {
    final birthDate = dob;
    final today = DateTime.now();

    final yearDiff = today.year - birthDate.year;
    final monthDiff = today.month - birthDate.month;
    final dayDiff = today.day - birthDate.day;

    return yearDiff > 13 ||
        (yearDiff == 13 && monthDiff >= 0) ||
        yearDiff == 13 && monthDiff == 0 && dayDiff >= 0;
  }
}
