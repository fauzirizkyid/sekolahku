import 'package:date_format/date_format.dart';

class Utils {
  static getPeriod(
      String prevNextCurrentMonth, bool trueWithDayFalseWithoutDay) {
    DateTime now = DateTime.now();
    String period;

    if (prevNextCurrentMonth.toLowerCase() == "prev") {
      now = DateTime(now.year, now.month - 1, now.day);
    } else if (prevNextCurrentMonth.toLowerCase() == "next") {
      now = DateTime(now.year, now.month + 1, now.day);
    } else {
      now = DateTime(now.year, now.month, now.day);
    }

    if (trueWithDayFalseWithoutDay == true) {
      period = formatDate(now, [yyyy, mm, dd]);
    } else {
      period = formatDate(now, [yyyy, mm]);
    }

    return period;
  }
}
