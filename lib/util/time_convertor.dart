import 'package:foap/helper/common_import.dart';

class TimeAgo {
  static String timeAgoSinceDate(DateTime timeAgoDate,
      {bool numericDates = true}) {
    final difference = DateTime.now().difference(timeAgoDate);

    if (difference.inDays > 8) {
      int days = difference.inDays;
      if (days > 365) {
        //Years
        int years = (days / 365).round();

        return years >= 2
            ? '$years ${LocalizationString.monthsAgo}'
            : '$years ${LocalizationString.monthAgo}';
      } else if (days > 30) {
        int months = (days / 30).round();
        return months >= 2
            ? '$months ${LocalizationString.monthsAgo}'
            : '$months ${LocalizationString.monthAgo}';
      } else {
        return '${(difference.inDays / 7).floor()} ${LocalizationString.weekAgo}';
      }
    } else if ((difference.inDays / 7).floor() >= 1) {
      return (numericDates)
          ? '1 ${LocalizationString.weekAgo}'
          : LocalizationString.lastWeek;
    } else if (difference.inDays >= 2) {
      return '${difference.inDays} ${LocalizationString.daysAgo}';
    } else if (difference.inDays >= 1) {
      return (numericDates)
          ? '1 ${LocalizationString.dayAgo}'
          : LocalizationString.yesterday;
    } else if (difference.inHours >= 2) {
      return '${difference.inHours} ${LocalizationString.hoursAgo}';
    } else if (difference.inHours >= 1) {
      return (numericDates)
          ? '1 ${LocalizationString.hoursAgo}'
          : LocalizationString.anHourAgo;
    } else if (difference.inMinutes >= 2) {
      return '${difference.inMinutes} ${LocalizationString.minutesAgo}';
    } else if (difference.inMinutes >= 1) {
      return (numericDates)
          ? '1 ${LocalizationString.minutesAgo}'
          : LocalizationString.aMinuteAgo;
    } else if (difference.inSeconds >= 3) {
      return '${difference.inSeconds} ${LocalizationString.secondsAgo}';
    } else {
      return LocalizationString.justNow;
    }
  }
}
