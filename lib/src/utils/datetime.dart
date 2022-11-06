import 'package:intl/intl.dart';

List<DateTime> getDates(DateTime startDate, DateTime endDate) {
  return [
    for (var current = startDate;
        current.isBefore(endDate);
        current = current.add(const Duration(days: 1)))
      current
  ];
}

extension Date on DateTime {
  //格式化日期
  String format(String pattern) {
    return DateFormat(pattern).format(this);
  }

  String weekdayAbbreviation() {
    switch (weekday) {
      case 1:
        return 'Mon';
      case 2:
        return 'Tue';
      case 3:
        return 'Wed';
      case 4:
        return 'Thu';
      case 5:
        return 'Fri';
      case 6:
        return 'Sat';
      default:
        return 'Sun';
    }
  }

  String monthAbbreviation() {
    switch (month) {
      case 1:
        return 'Jan';
      case 2:
        return 'Feb';
      case 3:
        return 'Mar';
      case 4:
        return 'Ari';
      case 5:
        return 'May';
      case 6:
        return 'Jun';
      case 7:
        return 'Jul';
      case 8:
        return 'Aut';
      case 9:
        return 'Sep';
      case 10:
        return 'Oct';
      case 11:
        return 'Nov';
      default:
        return 'Dec';
    }
  }
}
