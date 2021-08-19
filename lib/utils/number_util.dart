import 'package:intl/intl.dart';

String formatPriceNumber(int number, {String formatUnit = 'vn'}) {
  final formatter = NumberFormat('###,###');
  return formatter.format(number) + (formatUnit == 'vn' ? ' VND' : ' \$');
}

String formatPriceNumberNonUnit(int number) {
  final formatter = NumberFormat('###,###');
  return formatter.format(number);
}
