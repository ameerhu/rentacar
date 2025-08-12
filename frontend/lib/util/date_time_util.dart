import 'package:intl/intl.dart';

class DateTimeUtil {
  static String format(DateTime dt) {
    return DateFormat('yyy-MM-dd').format(dt);
  }

  static String ymdhm(DateTime dt, [String? locale]) {
    return DateFormat('yyy-MM-dd HH:mm').format(dt);
  }

  /// Formats the date as a medium date, e.g., 'Sep 24, 2023' for en_US locale.
  static String ymd(DateTime dt, [String? locale]) {
    return DateFormat.yMd(locale).format(dt);
  }
}
